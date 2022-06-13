//
//  Config.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 16/05/22.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class Config: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    //profileConfig nos envía a la escena de configuración de perfil a través del segue "profileConfig"
    @IBAction func profileConfig(_ sender: Any) {
        
        performSegue(withIdentifier: "profileConfig", sender: nil)
        
    }
    
    //deleteAccountButton borrarlo al usuario del servicio de autenticación de firebase, además de borrarlo del almacenamiento local del dispositivo y de la base de datos de firebase
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        Auth.auth().currentUser?.delete(completion: { error in
            
            if let error = error
            {
                sendAlert(title: "Error", message: error.localizedDescription, self)
            }
        })
        
        UserService.deleteUser(vc : self)
        
        self.localStorageLogOut()       
    }
    
    //closeSessionButton cierra la sesión del usuario dependiendo del servicio de autenticación que usó (Google, Facebook o correo y contraseña)
    //Además, quita al usuario del almacenamiento local.
    @IBAction func closeSessionButton(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let provider : ProviderType = ProviderType.init(rawValue: defaults.value(forKey: "provider") as! String)!
        
        localStorageLogOut()
        
        switch provider {
            
        case .basic:
            
            firebaseLogout()
            
        case .google:

            GIDSignIn.sharedInstance.signOut()
            firebaseLogout()
            
        case .facebook:
            print("Facebook")
        }
    }
    
    //firebaseLogout realiza un cierre de sesión en el servicio de autenticación de firebase
    private func firebaseLogout(){
        
        do{
            try Auth.auth().signOut()
            
            
        } catch {
            
            sendAlert(title: "Error", message: "Something goes wrong", self)
        }
    }
    
    //localStorageLogOut borra al usuario del almacenamiento local, para que se tenga que volver a identificar en la próxima ejecución de la aplicación
    private func localStorageLogOut()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "uid")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profileConfig"
        {
            let signUpController = segue.destination as! SignUp
            
            signUpController.action = "update"
        }
    }
}
