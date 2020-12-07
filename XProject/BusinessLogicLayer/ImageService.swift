//
//  ImageLocalService.swift
//  XProject
//
//  Created by Максим Локтев on 29.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol ImageService {
    func imageWith(name: String?) throws -> UIImage
    func storeImage(image: UIImage?, name: String, completion: @escaping (Result<UIImage?, APIError>) -> Void)
    func loadImage(name: String, completion: @escaping (Result<UIImage?, APIError>) -> Void)
}

class ImageServiceImpl: ImageService {
    
    func imageWith(name: String?) throws -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
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
            throw APIError.createImageLocalError
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            
            guard let image = nameImage else {
                throw APIError.faildExtractOptionalValue
            }
            return image
        }
        throw APIError.createImageLocalError
    }
    
    func storeImage(image: UIImage?, name: String, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        if let pngRepresentation = image?.pngData() {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = path.appendingPathComponent(name)
                do {
                    try pngRepresentation.write(to: fileURL)
                    completion(.success(image))
                } catch {
                    completion(.failure(.storeImageLocalError(error)))
                }
            }
        }
    }
    
    func loadImage(name: String, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = path.appendingPathComponent(name)
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                completion(.success(image))
            } catch {
                completion(.failure(.loadImageLocalError(error)))
            }
        }
    }
}
