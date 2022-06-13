//
//  UserCell.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 26/04/22.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Las siguientes 3 líneas son usadas para redondear la imagen del usuario en cuestión y darle un contorno de color "systemIndigo"
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width / 2
        userPhoto.layer.borderColor = UIColor.systemIndigo.cgColor
        userPhoto.layer.borderWidth = 1
        userPhoto.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
