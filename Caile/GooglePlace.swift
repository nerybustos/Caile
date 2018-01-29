//
//  GooglePlace.swift
//  Caile
//
//  Created by Nery on 26/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlace{
    let nombre: String
    let direccion: String
    let coordenadas: CLLocationCoordinate2D
    let id : String
    var precio : Int?
    var calificacion : Double?
    var fotoDeReferencia: String?
    var foto: UIImage?
    
    init(diccionario:[String:Any]) {
        self.nombre  = diccionario["name"] as! String
        self.direccion = diccionario["vicinity"] as! String
        self.id = diccionario["place_id"] as! String
        let coo = diccionario["geometry"] as! NSDictionary
        let location =  coo["location"] as! NSDictionary
        let latitud = location["lat"] as! CLLocationDegrees
        let longitud = location["lng"] as! CLLocationDegrees
        self.coordenadas = CLLocationCoordinate2DMake(latitud, longitud)
        if  let arrayfotos = diccionario["photos"] as? NSArray{
            let dic  = arrayfotos[0] as! NSDictionary
            let foto  = dic["photo_reference"] as! String
            self.fotoDeReferencia = foto
        }
        if let cal = diccionario["rating"] as? Double {
            self.calificacion = cal
        }
        if let pre = diccionario["price_level"] as? Int{
            self.precio = pre
        }
    }
    
    init() {
        self.nombre = ""
        self.direccion = ""
        self.coordenadas = CLLocationCoordinate2DMake(0, 0)
        self.id = ""
    }
    
}


