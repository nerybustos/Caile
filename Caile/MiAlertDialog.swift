//
//  MiAlertDialog.swift
//  Caile
//
//  Created by Nery on 22/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class MiAlertDialog {
    
    /**
     Muestra un alert dialog con un boton sin accion
    **/
    func alertDialogUnBoton(titulo:String,mensaje:String,view:UIViewController){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accion = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(accion)
        view.present(alert, animated: true, completion: nil)
    }
    
}
