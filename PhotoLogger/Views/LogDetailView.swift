//
//  LogDetailView.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import SwiftUI

struct LogDetailView: View {
    let log: PhotoLogEntry
    @ObservedObject var viewModel: PhotoLogViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text(log.formattedDate)
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    VStack {
                        Text("BEFORE")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                        Image(uiImage: viewModel.loadUIImage(for: log.beforeFileName))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    }
                    
                    VStack {
                        Text("AFTER")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.green)
                        Image(uiImage: viewModel.loadUIImage(for: log.afterFileName))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    }
                    
                    if !log.note.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Note:")
                                .font(.caption)
                                .foregroundColor(.green)
                            Text(log.note)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Delete Entry?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteLog(log)
                dismiss()
            }
        }
    }
}
