//
//  CaptureFlowView.swift
//  PhotoLogger
//
//  Created by Fai on 11/03/26.
//

import SwiftUI

struct CaptureFlowView: View {
    @ObservedObject var viewModel: PhotoLogViewModel
    @Environment(\.dismiss) var dismiss
    @State private var draftNote: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if viewModel.currentStep == .review {
                reviewScreen
            } else {
                cameraScreen
            }
        }
        .onAppear {
            viewModel.resetCaptureSession()
        }
        .onDisappear {
            viewModel.cameraService.stopSession()
        }
    }
    
    private var cameraScreen: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            
            Text(viewModel.currentStep == .capturingBefore ? "Capture BEFORE Photo" : "Capture AFTER Photo")
                .font(.headline)
                .foregroundColor(.green)
            
            CameraPreviewView(session: viewModel.cameraService.getCaptureSession())
                .frame(maxHeight: .infinity)
                .cornerRadius(12)
                .padding()
            
            Button(action: {
                viewModel.capturePhoto()
            }) {
                Circle()
                    .stroke(Color.green, lineWidth: 4)
                    .frame(width: 70, height: 70)
                    .overlay(Circle().fill(Color.white).frame(width: 55, height: 55))
            }
            .padding(.bottom, 30)
        }
    }
    
    private var reviewScreen: some View {
        VStack(spacing: 20) {
            Text("Review Entry")
                .font(.title2)
                .bold()
                .foregroundColor(.green)
                .padding(.top)
            
            HStack(spacing: 10) {
                if let bData = viewModel.tempBeforeData, let uiImageB = UIImage(data: bData) {
                    Image(uiImage: uiImageB)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                }
                
                if let aData = viewModel.tempAfterData, let uiImageA = UIImage(data: aData) {
                    Image(uiImage: uiImageA)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                }
            }
            .padding()
            
            TextField("Add a note (optional)", text: $draftNote)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 40) {
                Button("Retake") {
                    viewModel.resetCaptureSession()
                }
                .foregroundColor(.white)
                
                Button("Save Entry") {
                    viewModel.saveEntry(note: draftNote)
                    dismiss()
                }
                .fontWeight(.bold)
                .padding()
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(12)
            }
            .padding(.bottom, 40)
        }
    }
}
