//
//  ListsObjectCell.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import UIKit

class ListsObjectCell: UITableViewCell {

    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var lblObjectName: UILabel!
    @IBOutlet weak var lblObjectPrice: UILabel!
    @IBOutlet weak var lblObjectDisponibility: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
