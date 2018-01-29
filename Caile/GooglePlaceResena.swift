//
//  GooglePlaceResena.swift
//  Caile
//
//  Created by Nery on 02/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import Foundation

class GooglePlaceResena {
    let autor : String
    let texto : String
    let calificacion : Int
    var urlFoto : String?
    var foto : UIImage?
    
    
    init() {
        self.autor = "Usuario"
        self.texto = ""
        self.calificacion = 0
    }
    
    init(diccionario:[String:Any]) {
        self.autor = diccionario["author_name"] as! String
        self.texto = diccionario["text"] as! String
        self.calificacion = diccionario ["rating"] as! Int
        if let url = diccionario["profile_photo_url"] as? String {
            self.urlFoto = url
        }
    }
    
}

