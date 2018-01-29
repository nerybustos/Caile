//
//  EfectoBlur.swift
//  Caile
//
//  Created by Nery on 23/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class EfectoBlur {
    
    let efectoBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var vistaEfectoBlur:UIVisualEffectView? = nil
    
    func iniciaEfectoBlur(view:UIView) {
        vistaEfectoBlur = UIVisualEffectView(effect:efectoBlur)
        vistaEfectoBlur!.frame = view.bounds
        vistaEfectoBlur!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vistaEfectoBlur!)
    }
    
    func detenEfectoBlur(){
        if let compruebaVista : UIVisualEffectView = vistaEfectoBlur {
            compruebaVista.removeFromSuperview()
        }
    }
}
