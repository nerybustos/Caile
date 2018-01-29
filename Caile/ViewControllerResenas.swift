//
//  ViewControllerResenas.swift
//  Caile
//
//  Created by Nery on 28/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit

class ViewControllerResenas: UIViewController ,UITableViewDataSource,UITableViewDelegate,DescargaFotoPerfilResenaDelegate{
    
    var googlePlaceDetalle = GooglePlaceDetail()
    var lsResenas = [GooglePlaceResena]()
    let descargaFotoPerfil = DescargaFotoPerfilResena()
    
    
    @IBOutlet weak var tableViewResenas: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        construyeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //*****************************************************************************************************************************************************
    //Metodos de UITableViewDelegate y UITableViewDataSourse
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lsResenas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resena = lsResenas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_resena", for: indexPath) as! TableViewCellResena
        cell.lbUsuario.text = resena.autor
        cell.tetxViewResena.text = resena.texto
        cell.cosmosCalificacion.rating = Double(resena.calificacion)
        if let url = resena.urlFoto {
            if let foto = resena.foto {
                cell.imageViewFoto.image = foto
            }else{
                //Descarga la fotografia de perfil del usuario
               self.descargaFotoPerfil.descarga(elemento: indexPath.row, urlString: url)
            }
        }else{
            cell.imageViewFoto.image = #imageLiteral(resourceName: "ic_account")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //*****************************************************************************************************************************************************
    //Metodos de DescargaFotoPErfilResenaDelegate
    func descargaFotoPerfilResena(descargaFotoPerfilResena: DescargaFotoPerfilResena, fallido error: Error) {
        print(error.localizedDescription)
    }
    
    func descargaFotoPerfilResena(descargaFotoPerfilResena: DescargaFotoPerfilResena, fallido mensaje: String) {
        print(mensaje)
    }
    
    func descargaFotoPerfilResena(descargaFotoPerfilResena: DescargaFotoPerfilResena, correcto indice: Int, foto: UIImage) {
        lsResenas[indice].foto = foto
        if lsResenas.count < 3  {
            tableViewResenas.reloadData()
        }else if indice == 2 {
            tableViewResenas.reloadData()
        }
    }
    
    //*****************************************************************************************************************************************************
    //Metodos generales
    func construyeUI(){
        self.descargaFotoPerfil.delegate = self
        self.tableViewResenas.dataSource = self
        self.tableViewResenas.delegate = self
        self.tableViewResenas.tableFooterView = UIView()
        //Obtienene todos los datos del array de resenas
        DispatchQueue.global(qos: .background).async {
            //back ground
            if let res = self.googlePlaceDetalle.resenas{
                for r in res{
                    let resena  = GooglePlaceResena(diccionario: r)
                    self.lsResenas.append(resena)
                }
            }
            DispatchQueue.main.async {
                //hilo principal
                if self.lsResenas.count > 0{
                    self.tableViewResenas.reloadData()
                }else{
                    //TODO: MOSTRAR UNA IMAGEN AL USUARIO NOTIFICANDO QUE NO HAY RESEÑAS
                }
            }
        }
    }
    //*****************************************************************************************************************************************************
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
