//
//  Login.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 28/03/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

class Login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        txtEMail.delegate = self
        txtPassword.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        anyLoggedUser()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtEMail
        {
            txtPassword.becomeFirstResponder()
        
        } else {
            
            textField.resignFirstResponder()
            
            logIn(AnyObject.self)
            
            
        }
        
        return true
    }
    
    func anyLoggedUser(){
        
        let defaults = UserDefaults.standard
        
        if let _ = defaults.value(forKey: "uid") as? String {
            
            self.performSegue(withIdentifier: "segueLogInToMain", sender: nil)
         

        }
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        
        if let email = txtEMail.text, let password = txtPassword.text
            
        {
            if email.isEmpty || password.isEmpty
            {
                sendAlert(title: "Error", message: "Some field is empty", self)
                
            } else {
                
                Auth.auth().signIn(withEmail: email, password: password) {
                    (result, error) in
                    
                    if let result = result, error == nil{
                        
                        saveDefaultUser(result.user.uid, .basic)
                        
                        
                        self.performSegue(withIdentifier: "segueLogInToMain", sender: nil)
                    
                    } else {
                        
                        sendAlert(title: "Error", message: "Invalid email or password for this user", self)
                    }
                }
            }
        }
    }
    
    @IBAction func googleButtonAction(_ sender: Any){
        
        googleSignIn()
    }
    
    func googleSignIn (){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        //Se crea la configuración para el inicio de sesión con Google
        let config = GIDConfiguration(clientID: clientID)

        //Función que comienza el registro e identificación del usuario por Google
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {
            [unowned self] user, error in

          if error != nil {
            
              sendAlert(title: "Error", message: "An error has ocurred in the process", self)
              
            return
          }

            //Se obtiene la autenticación del usuario del servicio de Google
          guard
            let authentication = user?.authentication,
            //De la variable de autenticación se obtiene el token de autenticación del usuario
            let idToken = authentication.idToken
                
          else { return }

            //Se genera la credencial del usuario con el token de autenticación y el token de accesibilidad de google.
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            
            
            //Por último se llama a la función registerUserFromGoogle que inicia sesión, registra al usuario dentro de Firebase y lo registra en la base de datos de Firebase
            AuthService.registerUserFromGoogle(credential: credential, provider: .google) { error in
                
                if let error = error {
                    
                    print("Failed to register the user from facebook \(error.localizedDescription)")
                }
                
            }
            
            self.performSegue(withIdentifier: "segueLogInToMain", sender: nil)
        }
    }
        
    
    // MARK: - UNWIND
    //Unwind que permite al usuario regresar a la escena de login desde distintos puntos de la ejecución de la aplicación (Cerrar sesión, borrar cuenta)
    @IBAction func unwindToLogIn(_ : UIStoryboardSegue){
        
        txtEMail.text = ""
        txtPassword.text = ""
    }

}
