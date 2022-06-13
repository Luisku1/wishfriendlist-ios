//
//  PersonalDescription.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 09/06/22.
//

import UIKit

class PersonalDescription: UIViewController {
 
    @IBOutlet weak var txtPersonalD: UITextField!
    
    var object = WishObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func savePersonalD(_ sender: Any) {
        
        wishObjects[Int(object.id)! - 1].personalDescription = txtPersonalD.text!
        
        print("Debug:-\(wishObjects[Int(object.id)! - 1])")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
