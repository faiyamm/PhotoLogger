//
//  PhotoLogEntry.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import Foundation

struct PhotoLogEntry: Identifiable, Codable {
    let id: UUID
    let dateCreated: Date
    let beforeFileName: String
    let afterFileName: String
    var note: String
    
    init(beforeFileName: String, afterFileName: String, note: String) {
        self.id = UUID()
        self.dateCreated = Date()
        self.beforeFileName = beforeFileName
        self.afterFileName = afterFileName
        self.note = note
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateCreated)
    }
}
