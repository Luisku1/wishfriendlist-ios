//
//  AddNewEventCell.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 17/05/22.
//

import UIKit

class AddNewEventCell: UITableViewCell {

    @IBOutlet weak var imgCurrentUserImage: UIImageView!
    @IBOutlet weak var lblCurrentUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Las siguientes 4 líneas de código harán que la imagen de perfil del usuario loggeado sea redonda y tenga un borde de color "systemIndigo"
        imgCurrentUserImage.layer.cornerRadius = imgCurrentUserImage.frame.size.width / 2
        imgCurrentUserImage.layer.borderWidth = 1
        imgCurrentUserImage.layer.borderColor = UIColor.systemIndigo.cgColor
        imgCurrentUserImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
