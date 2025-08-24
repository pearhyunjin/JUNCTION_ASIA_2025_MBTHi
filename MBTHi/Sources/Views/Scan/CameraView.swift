//
//  CameraView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import AVFoundation
import PhotosUI

// MARK: - 카메라 세션 컨트롤러
final class CameraController: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let photoOutput = AVCapturePhotoOutput()
    private var photoCaptureDelegate: PhotoCaptureDelegate?

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input)
            else { return }

            self.session.addInput(input)

            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
                self.photoOutput.isHighResolutionCaptureEnabled = true
            }

            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    func capturePhoto(completion: @escaping (Data?) -> Void) {
        sessionQueue.async {
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            
            // 델리게이트를 프로퍼티에 저장하여 메모리에서 해제되지 않도록 합니다.
            self.photoCaptureDelegate = PhotoCaptureDelegate { [weak self] data in
                completion(data)
                self?.photoCaptureDelegate = nil // 작업 완료 후 델리게이트를 해제합니다.
            }
            
            self.photoOutput.capturePhoto(with: settings, delegate: self.photoCaptureDelegate!)
        }
    }

    // 내부 델리게이트 클래스
    private final class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
        private let completion: (Data?) -> Void
        
        init(completion: @escaping (Data?) -> Void) {
            self.completion = completion
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error {
                print("Error capturing photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(photo.fileDataRepresentation())
        }
    }
}

// MARK: - 프리뷰 레이어를 SwiftUI로 보여주기
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> Preview {
        let v = Preview()
        v.backgroundColor = .black
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        v.clipsToBounds = true
        return v
    }
    func updateUIView(_ uiView: Preview, context: Context) {}
    final class Preview: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
