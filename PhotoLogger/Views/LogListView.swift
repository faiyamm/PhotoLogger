//
//  LogListView.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import SwiftUI

struct LogListView: View {
    @StateObject private var viewModel = PhotoLogViewModel()
    @State private var showingCaptureFlow = false
    
    // UI Theme Colors
    let appGreen = Color.green
    let appBlack = Color.black
    
    var body: some View {
        NavigationView {
            ZStack {
                appBlack.ignoresSafeArea()
                
                if viewModel.logs.isEmpty {
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Text("No Logs Yet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(viewModel.logs) { log in
                            NavigationLink(destination: LogDetailView(log: log, viewModel: viewModel)) {
                                HStack {
                                    Image(uiImage: viewModel.loadUIImage(for: log.afterFileName))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    VStack(alignment: .leading) {
                                        Text(log.formattedDate)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        if !log.note.isEmpty {
                                            Text(log.note)
                                                .font(.caption)
                                                .foregroundColor(appGreen)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(appBlack)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("PhotoLogger")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingCaptureFlow = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(appGreen)
                            .font(.headline)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCaptureFlow) {
                CaptureFlowView(viewModel: viewModel)
            }
            // Apply green to navigation bar text globally
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = UIColor.black
                appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .accentColor(.green)
    }
}
