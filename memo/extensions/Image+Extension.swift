//
//  Image+Extension.swift
//  test
//
//  Created by love family on 17.10.2020.
//

import Foundation
import UIKit
import Combine

func saveImageToLocal(image: UIImage?) {
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let fileName = "image.jpg"
//    let fileURL = documentsDirectory.appendingPathComponent(fileName)
//    print("saveImageToLocal -> ", fileURL.path)
//    if let data = image?.jpegData(compressionQuality:  1.0),
//      !FileManager.default.fileExists(atPath: fileURL.path) {
//        do {
//            // writes the image data to disk
//            try data.write(to: fileURL)
//            print("file saved")
//        } catch {
//            print("error saving file:", error)
//        }
//    }
    if let image = image {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension URLSession {
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        dataTaskPublisher(for: url)
            .tryMap { data, _ -> UIImage in
                UIImage(data: data)!
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

func loadImageFromDiskWith(fileName: String) -> UIImage? {
    
    let fileManager = FileManager.default
    let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUPNAME)?.appendingPathComponent(fileName)
    
    if fileManager.fileExists(atPath: url?.path ?? "") {
        
        let image = UIImage(contentsOfFile: url?.path ?? "")
        return image
    }
    
    return nil
    
    // Read from Group Container - (PushNotification attachment example)
    // Add the attachment from group directory to the notification content
//    if let attachment = try? UNNotificationAttachment(identifier: "", url: url!) {
//
//        bestAttemptContent.attachments = [attachment]
//
//        // Serve the notification content
//        self.contentHandler!(self.bestAttemptContent!)
//    }
//
//    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//
//    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//
//    if let dirPath = paths.first {
//        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
//        let image = UIImage(contentsOfFile: imageUrl.path)
//        return image
//    }
//
//    return nil
    
    
}
