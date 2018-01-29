//
//  DescargaImagenReferencia.swift
//  Caile
//
//  Created by Nery on 27/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class DescargaImagenReferencia{
    
   
    let mensajeInesperado = "Lo sentimos, ocurrio algo inesperado al realizar la consulta"
    let mensajeNoEncontrado = "Lo sentimos, recurso no encontrado , contacte al administrador"
    weak var delegate : DescargaImagenReferenciaDelegate?
    
    func descarga(elemento:Int,referencia:String) {
        //Construye la url de descarga
        var componentesUrl = URLComponents (string:Constantes.URL_IMAGEN_REFERENCIA)!
        componentesUrl.queryItems = [
            URLQueryItem(name: "key", value: Constantes.KEY_GOOGLE_PLACES),
            URLQueryItem(name: "photoreference", value: referencia),
            URLQueryItem(name: "maxheight",value: "100"),
            URLQueryItem(name: "maxwidth",value:"100")
        ]
        let url = componentesUrl.url!
        print("url: \(url)")
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        var dataTask: URLSessionDataTask?
        let session = URLSession(configuration: urlconfig)
        session.configuration.timeoutIntervalForRequest = 20
        session.configuration.timeoutIntervalForResource = 20
        dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.descargaImagenReferencia(descargaImagenreferencia: self, fallido: error)
                }
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode{
                case 200:
                    DispatchQueue.main.async{
                        let imagen = UIImage(data: data!)
                        self.delegate?.descargaImagenReferencia(descargaImagenreferencia: self, correcto: imagen!, elemento: elemento)
                    }
                case 404:
                    DispatchQueue.main.async {
                        self.delegate?.descargaImagenReferencia(descargaImagenreferencia: self, fallido: self.mensajeNoEncontrado)
                    }
                default:
                    DispatchQueue.main.async {
                        self.delegate?.descargaImagenReferencia(descargaImagenreferencia: self, fallido: self.mensajeInesperado)
                    }
                }
            }
        })
        dataTask?.resume()
    }
}

protocol DescargaImagenReferenciaDelegate : class {
    func descargaImagenReferencia(descargaImagenreferencia:DescargaImagenReferencia,correcto imagn:UIImage,elemento:Int)
    func descargaImagenReferencia(descargaImagenreferencia:DescargaImagenReferencia,fallido error:Error)
    func descargaImagenReferencia(descargaImagenreferencia:DescargaImagenReferencia,fallido mensaje:String)
}

