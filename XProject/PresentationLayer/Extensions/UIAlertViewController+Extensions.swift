//
//  UIAlertViewController+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 14.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Photos
import UIKit

extension UIAlertController {
    
    class func alert(title: String?, message: String, cancel: String) -> Self {
        let alertController = self.init(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: cancel, style: .cancel))
        return alertController
    }
    
    class func photoPermissionDeniedAlert() -> Self {
        let permissionDeniedAlertController = self.init(
            title: NSLocalizedString("У нашего приложения нет доступа к вашим фото", comment: ""),
            message: NSLocalizedString("Вы можете разрешить доступ в настройках конфиденциальности.",
                                       comment: ""),
            preferredStyle: .alert
        )
        permissionDeniedAlertController.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        permissionDeniedAlertController.addAction(UIAlertAction(title: "Ок", style: .cancel))
        return permissionDeniedAlertController
    }
    
    class func restrictedCameraAlertController() -> Self {
        let restrictedCameraAlertController = self.init(
            title: NSLocalizedString("Ошибка", comment: ""),
            message: NSLocalizedString("Камера недоступна на вашем устройстве", comment: ""),
            preferredStyle: .alert
        )
        return restrictedCameraAlertController
    }
    
    class func changePhotoAlert(onSourceSelected: @escaping (UIImagePickerController.SourceType) -> Void) -> Self {
        let restrictedCameraAlertController = AlertWindowController.restrictedCameraAlertController()
        let permissionDeniedAlertController = AlertWindowController.photoPermissionDeniedAlert()
        let alertController = self.init(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                onSourceSelected(.photoLibrary)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        onSourceSelected(.photoLibrary)
                    }
                }
            case .restricted:
                restrictedCameraAlertController.show()
            case .denied:
                permissionDeniedAlertController.show()
            case .limited:
                #warning("To do")
                break
            @unknown default:
                break
            }
        })
        alertController.addAction(UIAlertAction(title: "Сделать снимок", style: .default) { _ in
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                onSourceSelected(.camera)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        onSourceSelected(.camera)
                    }
                }
            case .restricted:
                restrictedCameraAlertController.show()
            case .denied:
                permissionDeniedAlertController.show()
            @unknown default:
                break
            }
        })
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        return alertController
    }
}
