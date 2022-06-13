//
//  ViewController.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 28/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vLogin: UIView!
    @IBOutlet weak var vSignUp: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //Función que maneja la lógica del cambio de vistas a la hora de seleccionar las opciones login o signup
    @IBAction func switchViewContainers(segment : UISegmentedControl) {
        
        vLogin.isHidden = true
        vSignUp.isHidden = true
        
        if segment.selectedSegmentIndex == 0
        {
            vLogin.isHidden = false
        
        } else {
            
            vSignUp.isHidden = false
        }
    }
}

