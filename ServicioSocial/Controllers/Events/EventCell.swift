//
//  EventCell.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 18/04/22.
//

import UIKit

class EventCell: UITableViewCell {
    
    
    @IBOutlet weak var imgEventUserImage: UIImageView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblEventTextArea: UILabel!
    @IBOutlet weak var imgEventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Las siguientes 4 líneas de código hacen que la imagen del usuario listado sea redonda y tenga un contorno de color "systemIndigo"
        imgEventUserImage.layer.cornerRadius = imgEventUserImage.frame.size.width / 2
        imgEventUserImage.clipsToBounds = true
        imgEventUserImage.layer.borderWidth = 1
        imgEventUserImage.layer.borderColor = UIColor.systemIndigo.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
