//
//  MiProgressDialog.swift
//  Caile
//
//  Created by Nery on 26/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class MiProgressDialog {
     var progressView = UIView()//variable para el indicador de progreso
    /**
     Metodo encargado de iniciar un dialogo con un spin, para notificar un proceso
     - Parameter  view: Vista contenedora del progressdialog
     */
    func iniciaActivityIndicator(_ view:UIView){
        //Se configura la vista
        //Obtiene el cento de la vista
        let centro = view.center
        let x = centro.x
        let y = centro.y
        let ancho = view.frame.width / 1.2
        let alto = view.frame.height / 4
        progressView = UIView(frame: CGRect(x: x, y: y, width: ancho, height: alto))
        progressView.backgroundColor = MisColores.secondaryColor
        progressView.alpha = 0.8
        progressView.layer.cornerRadius = 10
        progressView.center = centro
        //Se inicialisa el activityView
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        let medidasProgress : CGFloat = 50
        activityView.frame = CGRect(x: (progressView.frame.width/2) - 25, y: 10, width: medidasProgress, height: medidasProgress)
        activityView.transform = CGAffineTransform(scaleX: 2, y: 2);
        activityView.startAnimating()
        let anchoTextLabel : CGFloat = progressView.frame.width - 10
        let textLabel = UITextView(frame: CGRect(x: (progressView.frame.width/2) - (anchoTextLabel/2) , y:activityView.frame.maxY, width: anchoTextLabel, height: progressView.frame.height/3))
        textLabel.backgroundColor = MisColores.secondaryColor
        textLabel.textColor = UIColor.white
        let random = randomInt(min: 0, max: 16)
        textLabel.text = Constantes.farcesDeBorrachos[random]
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name:"Ubuntu", size: 16)
        progressView.addSubview(activityView)
        progressView.addSubview(textLabel)
        view.addSubview(progressView)
    }
    
    /**
     Metodo encargado de ocultar el dialogo con un spin, para notificar un proceso
     */
    func detieneActivityIndicador(){
        progressView.removeFromSuperview()
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}
