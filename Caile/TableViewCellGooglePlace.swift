//
//  TableViewCellGooglePlace.swift
//  Caile
//
//  Created by Nery on 26/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit
import Cosmos

class TableViewCellGooglePlace: UITableViewCell {

    @IBOutlet weak var viewGooglePlaces: UIView!
    @IBOutlet weak var lbNombreGooglePlace: UILabel!
    @IBOutlet weak var lbDireccionGooglePlace: UILabel!
    @IBOutlet weak var imgViewGooglePlace: UIImageView!
    @IBOutlet weak var cosmosViewPrecio: CosmosView!
    @IBOutlet weak var cosmosViewCalificacion: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // construyeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func construyeUI()  {
        viewGooglePlaces.backgroundColor = UIColor.white
        viewGooglePlaces.layer.cornerRadius = 10
        viewGooglePlaces.layer.masksToBounds = false
        viewGooglePlaces.layer.shadowColor = UIColor.black.cgColor
        viewGooglePlaces.layer.shadowOpacity = 0.5
        viewGooglePlaces.layer.shadowOffset = CGSize.zero
        viewGooglePlaces.layer.shadowRadius = 2
    }

}
