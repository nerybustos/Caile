//
//  ConsumoWebServices.swift
//  Caile
//
//  Created by Nery on 25/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class ConsumoWebServices{
    /**
     Este medoto es el que hace la conexion al servidor
     - Parameter url: url para hacer la consulta web
     - Parameter opcion: define el tipo de consulta (tiendas, categorias , indicadores)
     */
    
    weak var delegate : ConsumoWebServicesDelegate?
    let mensajeInesperado = "Lo sentimos, ocurrio algo inesperado al realizar la consulta"
    let mensajeNoEncontrado = "Lo sentimos, recurso no encontrado , contacte al administrador"
    
    func consumoWeb(_ url:URL,tipoConsulta:Int) {
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
                        self.delegate?.consumoWebServices(consumoWebServices: self, fallido: error, tipoConsulta: tipoConsulta)
                    }
                } else if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode{
                    case 200:
                        DispatchQueue.main.async{
                            self.delegate?.consumoWebServices(consumoWebServices: self, correcto: data!, tipoConsulta: tipoConsulta)
                        }
                    case 404:
                        DispatchQueue.main.async {
                            self.delegate?.consumoWebServices(consumoWebServices: self, fallidoConMensaje: self.mensajeNoEncontrado, tipoConsulta: tipoConsulta)
                        }
                    default:
                        DispatchQueue.main.async {
                           self.delegate?.consumoWebServices(consumoWebServices: self, fallidoConMensaje: self.mensajeInesperado, tipoConsulta: tipoConsulta)
                        }
                    }
                }
            })
            dataTask?.resume()
    }
}

protocol ConsumoWebServicesDelegate : class {
    func consumoWebServices(consumoWebServices:ConsumoWebServices,correcto datos:Data,tipoConsulta:Int)
    func consumoWebServices(consumoWebServices:ConsumoWebServices,fallido error:Error,tipoConsulta:Int)
    func consumoWebServices(consumoWebServices:ConsumoWebServices, fallidoConMensaje mensaje:String,tipoConsulta:Int)
}
