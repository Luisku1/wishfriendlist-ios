//
//  SignUp.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 28/03/22.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore


class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpUpdateButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilePhotoButton: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfPassword: UITextField!
    
    var imageSelected : Bool = false
    var user : User = User()
    var action : String = "signup"
    
    private let db = Firestore.firestore()
    
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtName.delegate = self
        txtLastName.delegate = self
        txtBirthDate.delegate = self
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfPassword.delegate = self
        registerForKeyboardNotifications()
        createDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtName
        {
            txtLastName.becomeFirstResponder()
        
        } else {
            
            if textField == txtLastName
            {
                txtBirthDate.becomeFirstResponder()
            
            } else {
                
                if textField == txtBirthDate
                {
                    txtPhoneNumber.becomeFirstResponder()
                
                } else {
                    
                    if textField == txtPhoneNumber
                    {
                        txtEmail.becomeFirstResponder()
                    
                    } else {
                        
                        if textField == txtEmail
                        {
                            txtPassword.becomeFirstResponder()
                        
                        } else {
                            
                            if textField == txtPassword
                            {
                                txtConfPassword.becomeFirstResponder()
                            
                            } else {
                                
                                textField.resignFirstResponder()
                                
                                signUp(signUpUpdateButton)
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Las siguientes 4 líneas de código hace redonda el ImageView donde irá la imagen del usuario, además le pondrá un contorno de color "systemIndigo"
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.systemIndigo.cgColor
        
        //Las siguientes 4 líneas de código hace redonda el botón que permitirá al usuario seleccionar una imagen para su perfil
        profilePhotoButton.layer.cornerRadius = 0.5 * profilePhotoButton.bounds.size.width
        profilePhotoButton.clipsToBounds = true
        profilePhotoButton.layer.borderColor = UIColor.systemIndigo.cgColor
        profilePhotoButton.setBackgroundImage(UIImage(named: "addPhoto"), for: .normal)
        
        settingView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        
    }
    
    //settingView prepara la escena para el caso en el que se vaya a utilizar para editar a un usuario
    func settingView()
    {
        if action == "update"
        {
            signUpUpdateButton.setTitle("Update", for: .normal)
            
            UserService.getUser { [self] user in
                
                self.user = user
                
                self.txtName.text = self.user.name
                self.txtLastName.text = self.user.lastName
                self.txtEmail.text = self.user.email
                self.txtBirthDate.text = self.user.birthDate
                self.txtPhoneNumber.text = self.user.phoneNumber
                
                self.navigationItem.title = "\(self.user.name) \(self.user.lastName)"
                
                if self.user.profileImage == ""
                    
                {
                    self.profilePhotoButton.setImage(UIImage(named: "defaultProfileImage"), for: .normal)
                    
                } else {
                    
                    self.profileImage.sd_setImage(with: URL(string: self.user.profileImage))
                    
                }
            }
        }
    }
    
    //signUp valida que el usuario cumplió con el llenado del formato para darse de alta en la aplicación. Además, llama a las funciones correspondientes para el guardado o la actualización del usuario en la base de datos.
    @IBAction func signUp (_ sender: UIButton)
    {
        //Valida que se pueden desempaquetar los valores dentro de los textfield
        if let name = txtName.text, let lastName = txtLastName.text, let birthDate = txtBirthDate.text, let phoneNumber = txtPhoneNumber.text, let email = txtEmail.text, let password = txtPassword.text, let confPassword = txtConfPassword.text
            
        {
            //Condición que valida que los campos tienen información dentro
            if(name.isEmpty || lastName.isEmpty || birthDate.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty || confPassword.isEmpty)
            {
                
                sendAlert(title: "Error", message: "Some field is empty", self)
                
            } else {
                
                //Condición que valida que la contraseña ingresada coincida con la confirmación de la misma
                if(password == confPassword)
                {
                    
                    if action == "signup"
                    {
                        let credentials = AuthCredentials(email: email, password: password, name: name, lastName: lastName, birthDate: birthDate, phoneNumber: phoneNumber, profileImage: profileImage.image, provider: .basic)
                        
                        
                        AuthService.registerUser(withCredential: credentials, provider: .basic, self, imageSelected: imageSelected) { error in
                        
                            if let error = error {
                                
                                print("Failed to register user \(error.localizedDescription)")
                                
                                return
                                
                            }
                        }
                        
                    } else {
                        
                        let provider = UserDefaults.standard.value(forKey: "provider") as! String
                        
                        let credentials = AuthCredentials(email: email, password: password, name: name, lastName: lastName, birthDate: birthDate, phoneNumber: phoneNumber, profileImage: profileImage.image, provider: ProviderType(rawValue: provider)!)
                        
                        UserService.updateUser(withCredential: credentials, changePhoto: imageSelected, provider: ProviderType(rawValue: provider)!, self) { error in
                            
                            if let error = error
                            {
                                sendAlert(title: "Error", message: error.localizedDescription, self)
                            }
                        }
                    }
                    
                } else {
                    
                    sendAlert(title: "Error", message: "Passwords no matching", self)
                    
                }
            }
        }
    }
    
    
    // MARK: - Image Picker
    @IBAction func addPhotoAction(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        
        //Se delega las funcionalidades del imagePicker al ViewController SignUp
        imagePicker.delegate = self
        
        //Se el pop up que dará opciones al usuario para seleccionar una imagen
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle:.actionSheet)
        //Se genera la opción de cancelar la operación
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //Se añade la opción de cancelar la operación
        alertController.addAction(cancelAction)
        
        //Condición que valida que el dispositivo tiene acceso a la cámara
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //En caso de que si, se genera la opción de tomar una imagen para utilizarla en el proceso de alta
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            imagePicker.sourceType = .camera
            self.present (imagePicker, animated: true, completion: nil)
            })
            
            //Se añade la opción al pop up
            alertController.addAction(cameraAction)
        }
        
        //Condición que valida que el dispositivo en uso pueda acceder al almacenamiento del dispositivo para elegir una imagen desde ahí
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //Se crea la opción para elegir una imagen desde la librería de fotos
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present (imagePicker, animated: true, completion: nil)
            })
            //Se añade la opción de elegir una imagen de la librería para el usuario
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Se busca desempaquetar la imagen seleccionada por el usuario
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        //En caso de que se pueda se asigna la imagen a la previsualización del usuario
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.borderColor = UIColor.white.cgColor
        profilePhotoButton.layer.borderWidth = 2
        profileImage.image = selectedImage.withRenderingMode(.alwaysOriginal)
        imageSelected = true
        dismiss(animated: true)
    }
    
    // MARK: - Date Picker
    
    //createToolBar crea una barra de herramientas que se posicionará arriba del picker de fechas, para poder confirmar la fecha seleccionada
    func createToolBar () -> UIToolbar
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    //Se crea el date picker, aunque aun no se define cómo es que se mostrará este datePicker
    func createDatePicker()
    {
        datePicker.preferredDatePickerStyle = .wheels
        txtBirthDate.inputAccessoryView = createToolBar()
        txtBirthDate.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    //Se define una una función de tipo object que ocultará el datePicker y asignará la fecha seleccionada al textfield con un formato a string
    @objc func doneBtnPressed()
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        txtBirthDate.text = formatter.string(from: datePicker.date)
        
        txtPhoneNumber.becomeFirstResponder()
    }
    
    
    // MARK: - Funciones para ocultar el teclado al terminar la edición
    func registerForKeyboardNotifications() {
        
            NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
            NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
        bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification:
       NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    /*Fragmento de
    Develop in Swift Data Collections
    Apple Education
    https://books.apple.com/mx/book/develop-in-swift-data-collections/id1556365920
    Es posible que este material esté protegido por copyright.*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
