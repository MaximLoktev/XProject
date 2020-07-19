//
//  LetterImageGenerator.swift
//  XProject
//
//  Created by Максим Локтев on 16.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

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
    
    class func storeImage(image: UIImage?) -> URL? {
        
        let userImageKay = "userImageKay"
        
        if let pngRepresentation = image?.pngData() {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = path.appendingPathComponent(userImageKay + ".png")
                do {
                    try pngRepresentation.write(to: fileURL, options: .atomic)
                } catch {
                    _ = error.localizedDescription
                }
                return fileURL
            }
        }
        return nil
    }
}
