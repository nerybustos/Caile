    //
//  ViewControllerLugares.swift
//  Caile
//
//  Created by Nery on 23/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import FirebaseAuth


class ViewControllerLugares: UIViewController ,UITableViewDelegate,UITableViewDataSource,DescargaFotoUsuarioDelegate,CLLocationManagerDelegate,ConsumoWebServicesDelegate,DescargaImagenReferenciaDelegate{

    @IBOutlet weak var visualBlur: UIVisualEffectView!
    //UITableView que muestra los objetos del menu de hamburgesa
    @IBOutlet weak var tableViewMenu: UITableView!
    //Array que contiene los objetos que muestra el menu de hamburgesa
    var arrayMenuHamburgesa = [ObjetoMenu]()
    //Controla la vista del menu de hamburguesa
    var menuVisible = false
    //Vista que contiene el menu de haburguesa
    @IBOutlet weak var viewMenuHamburguesa: UIView!
    //Constrain para controlar el menu de hamburguesa
    @IBOutlet weak var constraintMenuHamburguesa: NSLayoutConstraint!
    var valorContrainMenuHamburguesaOculto : CGFloat = 0
    //Conponentes de la vista del menu de hamburgesa
    
    @IBOutlet weak var imageViewUsuario: UIImageView!
    @IBOutlet weak var lbUsuario: UILabel!
    let efectoBlur = EfectoBlur()
    //Objeto manejador de la localizacion
    let locationManager = CLLocationManager()
    var locations = [CLLocation]()
    //Objeto manejador de las consultas a los servicios web
    let consumoServiciosWeb = ConsumoWebServices()
    //Arreglo de lugares obtenidos de la consulta
    var lsGooglePlaces = [GooglePlace]()
    //UITableView encargada de controlar los googlePlaces
    @IBOutlet weak var tableViewGooglePlaces: UITableView!
    //Varible en donde se almacena la posicion del lugar seleccionado
    var seleccion = 0
    
    let miProgressDialog = MiProgressDialog()
    let descargaImagenReferencia = DescargaImagenReferencia()
    
    //***********************************************************************************************************************************
    //Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        construyeUI()
        // Do any additional setup after loading the view.
        //Configuramos los parametros para la geolocaclizacion
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        consumoServiciosWeb.delegate = self
         self.tabBarController?.tabBar.isHidden = false
        if lsGooglePlaces.count > 0 {
            tableViewGooglePlaces.reloadData()
            let index = IndexPath(row: self.seleccion, section: 0)
            let scroll =  UITableViewScrollPosition(rawValue: self.seleccion)!
            tableViewGooglePlaces.scrollToRow(at: index, at: scroll, animated: false)
            return
        }
        //Conmienza a obtener la localizacion actual de el usuario
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
       // obtenLugaresCercanos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //**********************************************************************************************************************************
    //Metodos de UITableViewDelegate y UITableViewDataSourse
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Identofoca cual tabla se esta constuyendo
        if tableView == tableViewMenu {
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Identofoca cual tabla se esta constuyendo
        if tableView == tableViewMenu {
            return arrayMenuHamburgesa.count
        }else{
            return lsGooglePlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewMenu {
            return construyeCeldaMenu(indexPath: indexPath, tableView: tableView)
        }else{
            return construyeCeldaGooglePlace(indexPath: indexPath, tableView: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewMenu {
            return 44
        }else{
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tableViewMenu {
            eventoMenu(objetoMenu: arrayMenuHamburgesa[indexPath.row])
        }else{
            self.seleccion = indexPath.row
            performSegue(withIdentifier: "segue_google_place_detalle", sender: lsGooglePlaces[indexPath.row])
        }
    }
    //*********************************************************************************************************************************
    //Metodos de DescargaFotoUsuarioDelegate
    func descargaImagen(descargaFotoUsuario: DescargaFotoUsuario, correcto ruta: URL) {
        do{
            let data = try Data(contentsOf: ruta)
            let image = UIImage(data: data)
            self.imageViewUsuario.image = image
            //Hace redondo el imageview que contiene la foto de usuario
            imageViewUsuario.layer.borderWidth = 1
            imageViewUsuario.layer.masksToBounds = false
            imageViewUsuario.layer.borderColor = UIColor.black.cgColor
            imageViewUsuario.layer.cornerRadius = imageViewUsuario.frame.height/4
            imageViewUsuario.clipsToBounds = true
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func descargaImagen(descargaFotoUsuario: DescargaFotoUsuario, error miError: Error) {
        
    }
    //**********************************************************************************************************************************
    //Metodos de CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.locations.count == 0 {
            self.locations = locations
            obtenLugaresCercanos()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO NOTIFICAR EL ERRO AL USUARIO
        locationManager.stopUpdatingLocation()
    }
    //**********************************************************************************************************************************
    //Metodos de consumoWebDelegate
    func consumoWebServices(consumoWebServices: ConsumoWebServices, correcto datos: Data, tipoConsulta: Int) {
        do{
            let arrayLugares = try JSONSerialization.jsonObject(with: datos, options: []) as! [String:Any]
            let status = arrayLugares["status"] as! String
            if status.elementsEqual("OK") {
                DispatchQueue.global(qos: .background).async {
                    //back ground
                     self.lsGooglePlaces = self.arrayToPlaces(array: arrayLugares)
                    DispatchQueue.main.async {
                        //hilo principal
                         self.efectoBlur.detenEfectoBlur()
                         self.miProgressDialog.detieneActivityIndicador()
                         self.tableViewGooglePlaces.reloadData()
                    }
                }
            
               
            }else{
                //TODO: notificar error al obtener los lugares desde google places
                print("error \(status)")
                self.efectoBlur.detenEfectoBlur()
                self.miProgressDialog.detieneActivityIndicador()
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func consumoWebServices(consumoWebServices: ConsumoWebServices, fallido error: Error, tipoConsulta: Int) {
        print(error.localizedDescription)
        efectoBlur.detenEfectoBlur()
        miProgressDialog.detieneActivityIndicador()
    }
    
    func consumoWebServices(consumoWebServices: ConsumoWebServices, fallidoConMensaje mensaje: String, tipoConsulta: Int) {
      print(mensaje)
        efectoBlur.detenEfectoBlur()
        miProgressDialog.detieneActivityIndicador()
    }
    //**********************************************************************************************************************************
    //Metodos de DescragaImagenDeReferenciaDelegate
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, fallido error: Error) {
        print(error.localizedDescription)
    }
    
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, fallido mensaje: String) {
        print(mensaje)
    }
    
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, correcto imagn: UIImage, elemento: Int) {
        print("descargaImagenReferencia correcto \(elemento)")
        let googlePlace = lsGooglePlaces[elemento]
        googlePlace.foto = imagn
    }
    
    //**********************************************************************************************************************************
    //Metodos generales
    /**
     Se encarga de configurar todos los elementos que conforman la interfaz de usuario
     */
    func construyeUI() {
        self.tableViewGooglePlaces.tableFooterView = UIView()
        //Obtiene los datos del usuario actual
        if let user =  Auth.auth().currentUser{
            if let nombre = user.displayName{
                lbUsuario.text = nombre
            }
            if let urlFoto = user.photoURL{
                let  descargafoto = DescargaFotoUsuario()
                descargafoto.delegate = self
                descargafoto.conecta(url: urlFoto)
            }
        }
        //Obtiene el valor del contraint del menu de hamburguesa
        valorContrainMenuHamburguesaOculto = constraintMenuHamburguesa.constant
        tableViewMenu.tableFooterView = UIView()
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        tableViewGooglePlaces.delegate = self
        tableViewGooglePlaces.dataSource = self
        descargaImagenReferencia.delegate = self
        // Construye los elementos que contiene el menu de hamburguesa
        //Objeto salir de la app
        let objetoSalir = ObjetoMenu(id: Constantes.ID_SALIR, titulo: Constantes.TITULO_MENU_SALIR)
        arrayMenuHamburgesa.append(objetoSalir)
    }
    /**
     Construye las celdas que corresponden a la lista del menu de hamburgesa
     - Parameter indexPath : indice que contiene informavcion de la seccion y la fila de la tabla
     - Parameter tableView : TableView correspondiente al menu de hamburguesa
     - Retuns : Celda con una imagen y tituto correspondiente al menu de hamburguesa
     */
    func construyeCeldaMenu(indexPath:IndexPath,tableView:UITableView) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cleda_menu", for: indexPath) as! TableViewCellMenu
        let objetoMenu = arrayMenuHamburgesa[indexPath.row]
        cell.labelTituloMenu.text = objetoMenu.titulo
        switch objetoMenu.id {
        case Constantes.ID_SALIR:
            cell.imageViewIconoMenu.image = #imageLiteral(resourceName: "ic_exit")
        default:
            return cell
        }
        return cell
    }
    
    /**
     Construye las celdas que corresponden a la lista delugares
     - Parameter indexPath : indice que contiene informavcion de la seccion y la fila de la tabla
     - Parameter tableView : TableView correspondiente a la lista de lugares
     - Retuns : Celda con una imagen y tituto correspondiente a la lista de lugares
     */
    func construyeCeldaGooglePlace(indexPath:IndexPath,tableView:UITableView) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell_google_place", for: indexPath) as! TableViewCellGooglePlace
        let googlePlace = lsGooglePlaces[indexPath.row]
        cell.lbNombreGooglePlace.text = googlePlace.nombre
        cell.lbDireccionGooglePlace.text = googlePlace.direccion
        if let cal = googlePlace.calificacion {
            cell.cosmosViewCalificacion.rating = cal
            cell.cosmosViewCalificacion.text = ""
        }else{
            cell.cosmosViewCalificacion.rating = 0
            cell.cosmosViewCalificacion.text = "No disponible"
        }
        if let pre = googlePlace.precio {
            cell.cosmosViewPrecio.rating = Double(pre)
            cell.cosmosViewPrecio.text = ""
        }else{
            cell.cosmosViewPrecio.rating = 0
            cell.cosmosViewPrecio.text = "No disponible"
        }
        if let idFotoReferencia = googlePlace.fotoDeReferencia {
            if let imagen = googlePlace.foto{
                cell.imgViewGooglePlace.backgroundColor = UIColor.black
                cell.imgViewGooglePlace.image = imagen
            }else{
                //Descarga la foto de referencia
                descargaImagenReferencia.descarga(elemento: indexPath.row, referencia: idFotoReferencia)
                print("Descarga imagen \(indexPath.row)")
            }
        }else{
            cell.imgViewGooglePlace.image = #imageLiteral(resourceName: "ic_google_place_default")
            cell.imgViewGooglePlace.backgroundColor = MisColores.gris
        }
        
        return cell
    }
    
    /**
     Reacciona al evento del objeto seleccionado en el menu de hamburgesa
     - Parameter objetoMenu : objeto del menu seleccionado
     */
    func eventoMenu(objetoMenu:ObjetoMenu)  {
        //Oculta el menu
        constraintMenuHamburguesa.constant = valorContrainMenuHamburguesaOculto
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.visualBlur.isHidden = true
        })
        menuVisible = false
        switch objetoMenu.id {
        case Constantes.ID_SALIR:
            logout()
        default:
            return
        }
    }
    /**
     Realiza la consulta de los lugares cecanos a la localizacion del usuario
     */
    func obtenLugaresCercanos(){
        efectoBlur.iniciaEfectoBlur(view: self.view)
        miProgressDialog.iniciaActivityIndicator(self.view)
        //Contruye la Urlpar la consulta
        let currentLocation = self.locations.first!
        let location : String = String(currentLocation.coordinate.latitude) + "," + String(currentLocation.coordinate.longitude)
        //let location = "19.435320175614557,-99.21201342127877"
        //let location = "19.35,-99.161667"
        //let location = "19.3188895,-99.18436759999997"
        var componentesUrl =  URLComponents(string: Constantes.URL_LUGARES_CERCANOS)!
        componentesUrl.queryItems = [
            URLQueryItem(name: "key", value: Constantes.KEY_GOOGLE_PLACES),
            URLQueryItem(name: "location", value:location),
            URLQueryItem(name: "rankby",value:"distance"),
            URLQueryItem(name: "types",value:"bar|night_club")
        ]
        let url = componentesUrl.url!
        consumoServiciosWeb.consumoWeb(url, tipoConsulta: Constantes.WEBSERVICES_LUGARES_CERCANOS)
    }
    
    /**
     Convierte el array a una lista de objetos tipo Googleplace
     - Parameter array : array obtenido de la consulta web
     - returns : [GooglePlace] lista que contiene objetos del tipo GooglePlace
     */
    func arrayToPlaces( array:[String:Any]) -> [GooglePlace]{
        var lsGoo = [GooglePlace]()
        let lugares = array["results"] as! [[String:Any]]
        for lugar in lugares {
         let googlePlace = GooglePlace(diccionario: lugar)
            lsGoo.append(googlePlace)
        }
        return lsGoo
    }
    
    /**
     Hace el logaout de un usuario
     */
    func logout()  {
        //
        //Validar si el usuario se logueo con FB
        if PreferenciasDeUsuario.isLogueadoFB(){
            //LogoautFB
            if let token = FBSDKAccessToken.current() {
                PreferenciasDeUsuario.setLogueadoFB(logueado: false)
                print(token)
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                FBSDKAccessToken.setCurrent(nil)
                FBSDKProfile.setCurrent(nil)
                
            }
        }
        //Logout Firebase
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "vc_principal")
        //Intacia de uiAplication
        let uiApp = UIApplication.shared.delegate as! AppDelegate
        uiApp.window?.rootViewController = vc
        
    }
    
    //***********************************************************************************************************************************
    //Acions
    @IBAction func btnMuenuHamburgesa(_ sender: Any) {
        if menuVisible {
            //Oculta el menu
            constraintMenuHamburguesa.constant = valorContrainMenuHamburguesaOculto
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                 self.visualBlur.isHidden = true
            })
        }else{
            //Hace visible el menu
            constraintMenuHamburguesa.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.visualBlur.isHidden = false
            })
        }
        menuVisible = !menuVisible
    }
    
    
    @IBAction func onTapGesture(_ sender: Any) {
        if menuVisible {
            //Oculta el menu
            //Oculta el menu
            constraintMenuHamburguesa.constant = valorContrainMenuHamburguesaOculto
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.visualBlur.isHidden = true
            })
            menuVisible = false
        }
    }
    
    //********************************************************************************************************************************

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewCotroller = segue.destination as! ViewControllerDetalle
        viewCotroller.googlePlace = sender as! GooglePlace
    }
    

}
