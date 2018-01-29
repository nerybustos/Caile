//
//  TableViewCellResena.swift
//  Caile
//
//  Created by Nery on 02/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import UIKit
import Cosmos

class TableViewCellResena: UITableViewCell {

    @IBOutlet weak var lbUsuario: UILabel!
    @IBOutlet weak var cosmosCalificacion: CosmosView!
    @IBOutlet weak var imageViewFoto: UIImageView!
    @IBOutlet weak var tetxViewResena: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
