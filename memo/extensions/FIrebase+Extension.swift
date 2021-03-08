//
//  FIrebase+Extension.swift
//  memo
//
//  Created by love family on 18.10.2020.
//

import Foundation
import UIKit
//import FirebaseStorage

//func uploadImageToFireStore1(image: UIImage?, name: String, onResult: @escaping (Bool, String?) -> Void) {
//    let storageRef = Storage.storage().reference().child("\(UserDefaultManager.share.getMyID())/\(name).jpg")
//    if let uploadData = image?.jpegData(compressionQuality: 1.0) {
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        storageRef.putData(uploadData, metadata: metadata
//                           , completion: { (metadata, error) in
//                            if error != nil {
//                                print("error -> ", error)
//                                onResult(false, nil)
//                                return
//                            } else {
//                                storageRef.downloadURL(completion: { (url, error) in
//                                    onResult(true, url?.absoluteString)
//                                })
//                            }
//
//                           }
//        )
//    }
//}

func uploadImageToFireStore(image: UIImage?, name: String, onResult: @escaping (Bool, String?) -> Void) {
    
    if(image == nil) {
        return
    }
    
    let image1: UIImage = image!
    
//    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    let fileManager = FileManager.default
    let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUPNAME)?.appendingPathComponent(name)
    
//    let fileName = name
//    let fileURL = documentsDirectory.appendingPathComponent(fileName)
//    print("fileURL -> ", fileURL)
    guard let data = image1.jpegData(compressionQuality: 1) else {
        onResult(false, "")
        return
    }
    
    //Checks if file exists, removes it if so.
    
    if fileManager.fileExists(atPath: url?.path ?? "") {
        
        do {
            try fileManager.removeItem(atPath: url?.path ?? "")
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
//    if FileManager.default.fileExists(atPath: fileURL.path) {
//        do {
//            try FileManager.default.removeItem(atPath: fileURL.path)
//            print("Removed old image")
//        } catch let removeError {
//            print("couldn't remove file at path", removeError)
//        }
//
//    }
    
    do {
        try data.write(to: url!)
    } catch let error {
        print("error saving file with error", error)
    }
    
    onResult(true, "")

}
