//
//  ImageUploader.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 27/04/22.
//

import FirebaseStorage
import UIKit


struct ImageUploader {
    
    static func uploadProfileImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) {
            
            (metadata, error) in
                
            if let error = error {
                
                print("Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL {(url, error ) in
                
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
                
            }
        }
    }
    
    static func uploadEventImage(image: UIImage, completion: @escaping(String) -> Void)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/events_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil)
        {
            (metadata, error) in
            
            if let error = error
            {
                print("Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL
            {
                (url, error) in
                
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}


