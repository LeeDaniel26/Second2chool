//
//  CameraViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/16.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {

    private var output = AVCapturePhotoOutput()     // ???
    private var captureSession: AVCaptureSession?   // ???
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Take Photo"
    
        setupNavBar()
        checkCameraPermission()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
//        // This three navigationBar settings are for transparent navigationBar
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .authorized:
            setupCamera()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {  // This 'canAddInput'(or canAddOutput) is to avoid conflict between input devices..?
                    captureSession.addInput(input)
                }
            }
            catch {
                print(error)
            }
            
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }
            
            // layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            // frame for 'previewLayer' is set in viewDidLayoutSubviews()
            view.layer.addSublayer(previewLayer )
            
            captureSession.startRunning()
        }
        
        // Add device
    }
    
    @objc private func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
}
