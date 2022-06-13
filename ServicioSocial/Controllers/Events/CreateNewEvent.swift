//
//  CreateNewEvent.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 23/05/22.
//

import UIKit
import YPImagePicker

class CreateNewEvent: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtNameEvent: UITextField!
    @IBOutlet weak var txtDateEvent: UITextField!
    @IBOutlet weak var txtTextEvent: UITextField!
    @IBOutlet weak var imgImageEvent: UIImageView!
    var imageSelected : Bool = false
    var currentUser : User?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNameEvent.delegate = self
        txtTextEvent.delegate = self
        
        
        createDatePicker()
        print("Debug on New Event:- \(currentUser!)")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //createEvent registra al evento del usuario en la base de datos
    @IBAction func createEvent(_ sender: Any) {
        
        if let nameEvent = txtNameEvent.text, let dateEvent = txtDateEvent.text, let textEvent = txtTextEvent.text
        {
            if nameEvent.isEmpty
            {
                sendAlert(title: "Missing data", message: "Choose a name for your event", self)
            
            } else {
                
                if dateEvent.isEmpty
                {
                    sendAlert(title: "Missing data", message: "Give us a date for your event", self)
                
                } else {
                    
                    if textEvent.isEmpty
                    {
                        sendAlert(title: "Missing data", message: "Give a description of your event", self)
                    
                    } else {
                        
                        guard let currentUser = self.currentUser else { return }
                        
                        EventService.uploadEvent(nameEvent: nameEvent, dateEvent: dateEvent, textEvent: textEvent, image: imgImageEvent.image, imageSelected: imageSelected, user: currentUser) { error in
                            
                            if error == nil
                            {
                                self.navigationController?.popViewController(animated: true)
                            
                            } else {
                                
                                sendAlert(title: "Error", message: error!.localizedDescription, self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Image Picker
    @IBAction func selectImageButtonAction(_ sender: UIButton) {
     
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        
        didSelectedImage(picker)
    }
    
    func didSelectedImage(_ picker : YPImagePicker)
    {
        picker.didFinishPicking { items, _ in
            
            picker.dismiss(animated: true)
            {
                guard let selectedImage = items.singlePhoto?.image else { return }
                self.imgImageEvent.image = selectedImage
                self.imageSelected = true
            }
        }
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
        txtDateEvent.inputAccessoryView = createToolBar()
        txtDateEvent.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    //Se define una una función de tipo object que ocultará el datePicker y asignará la fecha seleccionada al textfield con un formato a string
    @objc func doneBtnPressed()
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        txtDateEvent.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}
