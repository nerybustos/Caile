//
//  GooglePlaceDetail.swift
//  Caile
//
//  Created by Nery on 28/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class GooglePlaceDetail{
    let sin_datos = "Sin datos"
    let sin_numero = "Sin número"
    let direccion : String
    let numero : String
    var abierto : Bool?
    var permanenteMenteCerrado : Bool?
    var horarios : [String]?
    var referenciaFotos = [String]()
    var lsImagenes : [UIImage]?
    var resenas  : [[String:Any]]?
    var fotos : [[String:Any]]?
    
    init() {
        self.direccion = sin_datos
        self.numero = sin_numero
    }
    
    init(diccionario:[String:Any]) {
        
        //Obtiene las fotografias
        if let fotosLugar = diccionario["photos"] as? [[String:Any]] {
            self.fotos = fotosLugar
        }
        //Obtiene las reseñas del lugar
        if let res  = diccionario["reviews"] as? [[String:Any]]{
         self.resenas = res
        }
        //Obtiene la direccion
        if let dic = diccionario["formatted_address"] as? String {
            self.direccion = dic
        }else{
            self.direccion = sin_datos
        }
        //Obtiene el numero telefonico
        if let num = diccionario["formatted_phone_number"] as? String {
            self.numero = num
        }else{
            self.numero = sin_numero
        }
        //Obtiene los horarios del lugar
        if let diccionarioHorario  = diccionario["opening_hours"] as? NSDictionary{
            
            if let openNow = diccionarioHorario["open_now"] as? Bool{
                self.abierto = openNow
            }
            
            if let mdias = diccionarioHorario["weekday_text"] as? [String]{
                self.horarios = mdias
            }
        }
        //Bool que es tru si el lugar esta permanentemente cerrrado
        if let cerradoPermanentemente = diccionario["permanently_closed"] as? Bool {
            self.permanenteMenteCerrado = cerradoPermanentemente
        }
        
        if let imagenesReferencia = diccionario["photos"] as? [[String:Any]]{
            for img in imagenesReferencia{
                let referencia = img["photo_reference"] as! String
                self.referenciaFotos.append(referencia)
            }
        }
        
    }
    
}
