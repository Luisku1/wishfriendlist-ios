//
//  Product.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import UIKit

class WishObjectView: UIViewController {

    @IBOutlet weak var lblObjectName: UILabel!
    @IBOutlet weak var lblObjectPrice: UILabel!
    @IBOutlet weak var lblObjectDisponibility: UILabel!
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var personalD: UILabel!
    
    var object = WishObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadObjectInfo()
    }
    
    func loadObjectInfo()
    {
        lblObjectName.text = self.object.name
        lblObjectPrice.text = "$\(self.object.price)"
        lblObjectDisponibility.text = String(self.object.stock)
        objectImage.image = UIImage(named: self.object.image)
        personalD.text = object.personalDescription
    }
    
    @IBAction func addPersonalD(_ sender: Any) {
        
        performSegue(withIdentifier: "viewToPersonalD", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewToPersonalD"
        {
            let vc = segue.destination as! PersonalDescription
            
            vc.object = self.object
        }
    }
    
    @IBAction func unwind(_ : UIStoryboardSegue)
    {
        
    }
}
