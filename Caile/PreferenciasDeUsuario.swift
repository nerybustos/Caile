//
//  PreferenciasDeUsuario.swift
//  Caile
//
//  Created by Nery on 03/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import Foundation
class PreferenciasDeUsuario {
    static let PREFS : UserDefaults = UserDefaults.standard
    static let LOGUEDO_FACEBOOCK = "logeaodo_fb"
    
    /**
     Consulta si el usuario se logueo con FB
     - Returns: true -> el usuario esta logueado con FB , false-> el usuario no esta loguedo con FB
     */
    static func isLogueadoFB() -> Bool {
        var retorno : Bool = false
        let retornoCheck : Bool? = self.PREFS.bool(forKey: LOGUEDO_FACEBOOCK)
        if let logueado: Bool =  retornoCheck {
            retorno = logueado
        }else {
            retorno = false
        }
        return retorno
    }
    /**
     Guarda el estado del usuario
     - Parameter logueado: true -> el usuario esta logueado , false-> el usuario no esta loguedo
     */
    static func setLogueadoFB(logueado:Bool){
        PREFS.set(logueado, forKey: LOGUEDO_FACEBOOCK)
        PREFS.synchronize()
    }
    
}
