//
//  DescargaFotoUsuario.swift
//  Caile
//
//  Created by Nery on 23/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation

class DescargaFotoUsuario {
    weak var delegate : DescargaFotoUsuarioDelegate?
    
    func conecta(url:URL){
        //Create URL to the source file you want to download
        let fileURL = url
        print("\(fileURL)")
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let nombreArchivo = "foto_usuario.jpg"
        //agregar al destino el archivo
        let destinationFileUrl = documentsUrl.appendingPathComponent(nombreArchivo)
        //archivo existente???....................................................
        let fileExists = FileManager().fileExists(atPath: destinationFileUrl.path)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL)
        // si el archivo ya existe, no descargarlo de nuevo y enviar ruta de destino.........................................................................
        if fileExists == true {
            print(destinationFileUrl)
            self.delegate?.descargaImagen(descargaFotoUsuario: self, correcto: destinationFileUrl)
        }
            // si el archivo aun no existe, descargarlo y mostrar ruta de destino..........................................................................
        else{
            print("descargar archivo")
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success se ah descargado correctamente...................................
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        if statusCode == 200{
                            do {
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                                self.delegate?.descargaImagen(descargaFotoUsuario: self, correcto: destinationFileUrl)
                            } catch (let writeError) {
                                self.delegate?.descargaImagen(descargaFotoUsuario: self, error: writeError)
                                return
                            }
                            
                        }else {
                            self.delegate?.descargaImagen(descargaFotoUsuario: self, error: error!)
                            return
                        }
                    }
                } else {
                    self.delegate?.descargaImagen(descargaFotoUsuario: self, error: error!)
                    return
                }
            }
            task.resume()
        }
    }
}

protocol DescargaFotoUsuarioDelegate : class {
    func descargaImagen( descargaFotoUsuario : DescargaFotoUsuario, correcto ruta:URL)
    func descargaImagen( descargaFotoUsuario : DescargaFotoUsuario, error miError:Error)
}
