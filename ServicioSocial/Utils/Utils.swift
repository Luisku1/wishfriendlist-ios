//
//  Utils.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 22/04/22.
//

import Foundation
import UIKit


func sendAlert(title : String, message : String, _ controller : UIViewController){
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
    controller.present(alertController, animated: true, completion: nil)
}


func saveDefaultUser(_ uid : String, _ provider : ProviderType){
    
    let defaults = UserDefaults.standard
    defaults.set(uid, forKey: "uid")
    defaults.set(provider.rawValue, forKey: "provider")
    defaults.synchronize()
    
}
