//
//  LetterImageGenerator.swift
//  XProject
//
//  Created by Максим Локтев on 16.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseStorage
import UIKit

class LetterImageGenerator: NSObject {
    
    class func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .green
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    class func storeImage(image: UIImage?, name: String) {
        if let pngRepresentation = image?.pngData() {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = path.appendingPathComponent(name)
                do {
                    try pngRepresentation.write(to: fileURL)
                } catch {
                    _ = error.localizedDescription
                }
            }
        }
    }
    
    class func loadImage(name: String) -> UIImage? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = path.appendingPathComponent(name)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                _ = error.localizedDescription
            }
        }
        return nil
    }
    
    class func saveImageInFirebase(imageName: String, completion: ((Result<String, APIError>) -> Void)?) {
        let storageReference = Storage.storage().reference()
        let imagesReference = storageReference.child("images")
        let imageReference = imagesReference.child(imageName)
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = path.appendingPathComponent(imageName)
        imageReference.putFile(from: fileURL, metadata: nil) { _, error in
            if let error = error {
                completion?(.failure(.firebase(error)))
                return
            }
            
            imageReference.downloadURL { url, error in
                guard let url = url else {
                    return
                }
                if let error = error {
                    completion?(.failure(.firebase(error)))
                    return
                }
                completion?(.success(url.absoluteString))
            }
        }
    }
}
