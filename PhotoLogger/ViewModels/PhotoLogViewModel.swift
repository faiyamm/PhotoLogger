//
//  PhotoLogViewModel.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import Foundation
import UIKit
import Combine

enum CaptureStep {
    case capturingBefore
    case capturingAfter
    case review
}

class PhotoLogViewModel: ObservableObject {
    @Published var logs: [PhotoLogEntry] = []
    @Published var cameraService = CameraService()
    
    @Published var currentStep: CaptureStep = .capturingBefore
    @Published var tempBeforeData: Data?
    @Published var tempAfterData: Data?
    
    private let photoStore = PhotoStore()
    private let fileManager = FileManager.default
    
    private var logsFileURL: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("photologs.json")
    }
    
    init() {
        loadLogs()
        cameraService.setupCamera()
    }
    
    func capturePhoto() {
        cameraService.capturePhoto { [weak self] data in
            guard let self = self, let data = data else { return }
            DispatchQueue.main.async {
                if self.currentStep == .capturingBefore {
                    self.tempBeforeData = data
                    self.currentStep = .capturingAfter
                } else if self.currentStep == .capturingAfter {
                    self.tempAfterData = data
                    self.currentStep = .review
                    self.cameraService.stopSession()
                }
            }
        }
    }
    
    func resetCaptureSession() {
        tempBeforeData = nil
        tempAfterData = nil
        currentStep = .capturingBefore
        cameraService.startSession()
    }
    
    func saveEntry(note: String) {
        guard let beforeData = tempBeforeData,
              let afterData = tempAfterData,
              let beforeFile = photoStore.savePhoto(data: beforeData),
              let afterFile = photoStore.savePhoto(data: afterData) else { return }
        
        let newLog = PhotoLogEntry(beforeFileName: beforeFile, afterFileName: afterFile, note: note)
        logs.insert(newLog, at: 0)
        saveLogs()
        resetCaptureSession()
    }
    
    func deleteLog(_ log: PhotoLogEntry) {
        photoStore.deletePhoto(fileName: log.beforeFileName)
        photoStore.deletePhoto(fileName: log.afterFileName)
        logs.removeAll { $0.id == log.id }
        saveLogs()
    }
    
    func loadUIImage(for fileName: String) -> UIImage {
        return photoStore.loadPhoto(fileName: fileName) ?? UIImage()
    }
    
    private func saveLogs() {
        if let data = try? JSONEncoder().encode(logs) {
            try? data.write(to: logsFileURL)
        }
    }
    
    private func loadLogs() {
        if let data = try? Data(contentsOf: logsFileURL),
           let savedLogs = try? JSONDecoder().decode([PhotoLogEntry].self, from: data) {
            self.logs = savedLogs
        }
    }
}
