//
//  ViewControllerInfo.swift
//  Caile
//
//  Created by Nery on 28/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit

class ViewControllerInfo: UIViewController ,ConsumoWebServicesDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var imageViewInfo: UIImageView!
    var googlePlace = GooglePlace()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var txtViewDireccion: UITextView!
    
    @IBOutlet weak var lbTelefono: UILabel!
    
    @IBOutlet weak var viewDetalle: UIView!
    
    @IBOutlet weak var lbAbierto: UILabel!
    
    @IBOutlet weak var tableViewHorarios: UITableView!
    
    let consumoWebServices = ConsumoWebServices()
    
    var lsHorarios = [String]()
    var detalle = GooglePlaceDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        construyeUIT()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //****************************************************************************************************************
    //Metodos ConsumoWebservicesDelegate
    func consumoWebServices(consumoWebServices: ConsumoWebServices, correcto datos: Data, tipoConsulta: Int) {
        activityIndicator.stopAnimating()
        do{
            let diccionario = try JSONSerialization.jsonObject(with: datos, options: []) as! NSDictionary
            let status = diccionario["status"] as! String
            if status == "OK" {
                let result = diccionario["result"] as! [String:Any]
                obtenResultadosDeLaConsulta(diccionario: result)
            }else{
                //TODO : Notificar el error
                print(status)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func consumoWebServices(consumoWebServices: ConsumoWebServices, fallido error: Error, tipoConsulta: Int) {
        activityIndicator.stopAnimating()
    }
    
    func consumoWebServices(consumoWebServices: ConsumoWebServices, fallidoConMensaje mensaje: String, tipoConsulta: Int) {
        activityIndicator.stopAnimating()
    }
     //****************************************************************************************************************
    //Metodos de tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lsHorarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "horarios", for: indexPath) as! TableViewCellHorarios
        cell.lbHorarios.text = lsHorarios[indexPath.row]
        return cell
    }
    
    //****************************************************************************************************************
    //Metodos generales
    func construyeUIT() {
        
        tableViewHorarios.delegate = self
        tableViewHorarios.dataSource = self
        
        viewDetalle.layer.cornerRadius = 1
        viewDetalle.layer.shadowColor = UIColor.black.cgColor
        viewDetalle.layer.shadowOpacity = 1
        viewDetalle.layer.shadowOffset = CGSize.zero
        viewDetalle.layer.shadowRadius = 1
        
        consumoWebServices.delegate = self
        imageViewInfo.layer.borderWidth = 1
        imageViewInfo.layer.masksToBounds = false
        imageViewInfo.layer.borderColor = UIColor.black.cgColor
        imageViewInfo.layer.cornerRadius = imageViewInfo.frame.height/2
        imageViewInfo.clipsToBounds = true
        if let img =  googlePlace.foto {
            self.imageViewInfo.image = img
        }else{
            self.imageViewInfo.image = #imageLiteral(resourceName: "ic_google_place_default")
        }
        //Descarga el detalle del citio
        var componentesUrl = URLComponents(string: Constantes.URL_DETALLES)!
        componentesUrl.queryItems = [
        URLQueryItem(name: "key", value: Constantes.KEY_GOOGLE_PLACES),
        URLQueryItem.init(name: "placeid", value: self.googlePlace.id),
        URLQueryItem.init(name: "language", value:"es")
        ]
        self.consumoWebServices.consumoWeb(componentesUrl.url!, tipoConsulta: Constantes.WEBSERVICES_DETALLE)
    }
    
    func obtenResultadosDeLaConsulta(diccionario:[String:Any]) {
        DispatchQueue.global(qos: .background).async {
            //back ground
             self.detalle = GooglePlaceDetail(diccionario: diccionario)
            DispatchQueue.main.async {
                //hilo principal
                self.txtViewDireccion.text = self.detalle.direccion
                self.lbTelefono.text = self.detalle.numero
                if let a = self.detalle.abierto{
                    if a{
                        self.lbAbierto.textColor = MisColores.verde
                        self.lbAbierto.text = "ABIERTO"
                    }else{
                        self.lbAbierto.textColor = MisColores.rojo
                        self.lbAbierto.text = "CERRADO"
                    }
                }else if let cP = self.detalle.permanenteMenteCerrado{
                    if cP{
                        self.lbAbierto.textColor = MisColores.rojo_intenso
                        self.lbAbierto.text = "CERRADO PERMANENTEMENTE"
                    }
                }
                
                if let ls = self.detalle.horarios{
                    self.lsHorarios = ls
                    self.tableViewHorarios.reloadData()
                    //Selecciona el dia de  la semana
                    if let dia  = self.dayNumberOfWeek(){
                        let index = IndexPath(row: dia, section: 0)
                        let scroll = UITableViewScrollPosition(rawValue: dia)
                        self.tableViewHorarios.selectRow(at: index, animated: true, scrollPosition:scroll!)
                    }
                }
               
                self.activityIndicator.stopAnimating()
                //Envia notificacion para habilitar el segment controller
                let not = NotificationCenter.default
                not.post(name: NSNotification.Name(rawValue: Constantes.NOTIFICACION_DATOS_DESCARGADOS), object: nil)
            }
        }
    }
    
    func dayNumberOfWeek() -> Int? {
        
        if let dia  = Calendar.current.dateComponents([.weekday], from: Date()).weekday{
            
            let retorno  = dia - 2
            if retorno < 0{
                return 6
            }else{
                return retorno
            }
        }
        return nil
    }
    
    //****************************************************************************************************************
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
