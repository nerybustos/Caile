//
//  File.swift
//  Caile
//
//  Created by Nery on 02/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import Foundation
class GooglePlaceFoto {
    let referencia : String
    var foto : UIImage?
    
    init() {
        self.referencia = ""
    }
    
    init(diccionario:[String:Any]) {
        self.referencia = diccionario["photo_reference"] as! String
    }
    
}
