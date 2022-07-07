//
//  SaveLoadManager.swift
//  train
//
//  Created by Алексей Моторин on 05.07.2022.
//

import UIKit

class SaveLoadManager {
    var saveLoadManager = SaveLoadManager()
    
    private init() {}
    
    static func saveImage(image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = UUID().uuidString
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: fileUrl.path)
                print("Remove old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        
        do {
            try data.write(to: fileUrl)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
