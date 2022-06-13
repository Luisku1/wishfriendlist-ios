//
//  AuthService.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 27/04/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct AuthCredentials {
    
    let email : String, password : String, name : String, lastName : String , birthDate : String, phoneNumber : String, profileImage : UIImage?, provider : ProviderType
}

struct AuthService {
    
    static func registerUser(withCredential credentials : AuthCredentials, provider: ProviderType, _ viewController : UIViewController, imageSelected: Bool, completion : @escaping(Error?) -> Void){
        
        if imageSelected
        {
            ImageUploader.uploadProfileImage(image: credentials.profileImage!) {
                imageUrl in
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    
                    if let error = error {
                        
                        sendAlert(title: "Error", message: error.localizedDescription, viewController)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    saveDefaultUser(uid, provider)
                    
                    Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { result, error in

                        if let error = error
                        {
                            print("DEBUG signIn:- \(error.localizedDescription)")
                            
                        } else {
                            
                            viewController.performSegue(withIdentifier: "segueSignUpToMain", sender: nil)
                        }
                    }
                    
                    COLLECTION_USERS.document(uid).setData([
                        "email" : credentials.email,
                        "name": credentials.name,
                        "lastName": credentials.lastName,
                        "birthDate": credentials.birthDate,
                        "phoneNumber": credentials.phoneNumber,
                        "profileImage": imageUrl,
                        "uid": uid,
                        "provider": credentials.provider.rawValue
                        
                    ])
                }
            }
            
        } else {
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                
                if let error = error {
                    
                    sendAlert(title: "Error", message: error.localizedDescription, viewController)
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                saveDefaultUser(uid, provider)
                
                Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { result, error in

                    if let error = error
                    {
                        print("DEBUG signIn:- \(error.localizedDescription)")
                        
                    } else {
                        
                        viewController.performSegue(withIdentifier: "segueSignUpToMain", sender: nil)
                    }
                }
                
                COLLECTION_USERS.document(uid).setData([
                    "email" : credentials.email,
                    "name": credentials.name,
                    "lastName": credentials.lastName,
                    "birthDate": credentials.birthDate,
                    "phoneNumber": credentials.phoneNumber,
                    "profileImage": "",
                    "uid": uid,
                    "provider": credentials.provider.rawValue
                    
                ])
            }
        }
    }
    
    static func registerUserFromGoogle(credential: AuthCredential, provider: ProviderType, completion : @escaping(Error?) -> Void){
        
        
        
        Auth.auth().signIn(with: credential) {
            
            (result, error) in
        
            if let error = error {
                
                print("Failed to register user \(error.localizedDescription)")
                return
            }
                
            guard let uid = result?.user.uid else { return }
            
            let url = result?.user.photoURL?.absoluteString

            
            saveDefaultUser(uid, provider)
            
            COLLECTION_USERS.document(uid).getDocument { snapshot, error in
                
                if let snapshot = snapshot, !snapshot.exists
                {
                    COLLECTION_USERS.document(uid).setData([
                        "email" : result?.user.email ?? "Edit your profile",
                        "name": result?.user.displayName ?? "Edit your profile",
                        "lastName": "",
                        "birthDate": "Edit your profile",
                        "phoneNumber": result?.user.phoneNumber ?? "Edit your profile",
                        "profileImage": url ?? "",
                        "uid": uid,
                        "provider": provider.rawValue
                        
                    ])
                }
            }
        }
    }
}
