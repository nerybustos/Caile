//
//  DescargaFotoPerfilResena.swift
//  Caile
//
//  Created by Nery on 02/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import Foundation

class DescargaFotoPerfilResena {
    let mensajeInesperado = "Lo sentimos, ocurrio algo inesperado al realizar la consulta"
    let mensajeNoEncontrado = "Lo sentimos, recurso no encontrado , contacte al administrador"
    weak var delegate : DescargaFotoPerfilResenaDelegate?
    
    func descarga(elemento:Int,urlString:String) {
        let url = URL(string: urlString)!
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
                    self.delegate?.descargaFotoPerfilResena(descargaFotoPerfilResena: self, fallido: error)
                }
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode{
                case 200:
                    DispatchQueue.main.async{
                        let imagen = UIImage(data: data!)
                        self.delegate?.descargaFotoPerfilResena(descargaFotoPerfilResena: self, correcto: elemento, foto: imagen!)
                    }
                case 404:
                    DispatchQueue.main.async {
                        self.delegate?.descargaFotoPerfilResena(descargaFotoPerfilResena: self, fallido: self.mensajeNoEncontrado)
                    }
                default:
                    DispatchQueue.main.async {
                        self.delegate?.descargaFotoPerfilResena(descargaFotoPerfilResena: self, fallido: self.mensajeInesperado)
                    }
                }
            }
        })
        dataTask?.resume()
    }
}

protocol DescargaFotoPerfilResenaDelegate : class {
    func descargaFotoPerfilResena(descargaFotoPerfilResena : DescargaFotoPerfilResena, correcto indice:Int,foto:UIImage)
    func descargaFotoPerfilResena(descargaFotoPerfilResena : DescargaFotoPerfilResena, fallido error:Error)
    func descargaFotoPerfilResena(descargaFotoPerfilResena : DescargaFotoPerfilResena, fallido mensaje:String)
}
