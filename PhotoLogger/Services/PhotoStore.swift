//
//  PhotoStore.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import Foundation
import UIKit

class PhotoStore {
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func savePhoto(data: Data) -> String? {
        let fileName = "photo_\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Failed to save photo: \(error)")
            return nil
        }
    }
    
    func loadPhoto(fileName: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    func deletePhoto(fileName: String) {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: fileURL)
    }
}
