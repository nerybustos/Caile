//
//  ViewControllerDetalle.swift
//  Caile
//
//  Created by Nery on 27/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit
import MapKit

class ViewControllerDetalle: UIViewController , MKMapViewDelegate{
    //Lugar seleccionado en la vista anterior
    var googlePlace = GooglePlace()
    //Objeto MapView para mostrar la ubicacion de el lugar
    @IBOutlet weak var mapView: MKMapView!
    //Objeto para manejar el containerView
    var container : ContainerViewController!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    //****************************************************************************************************************************
    //Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = googlePlace.nombre
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        construyeUI()
        //Se registra a las notificaciones
        let not = NotificationCenter.default
        not.addObserver(self, selector: #selector(self.activaSegmentecControl), name: NSNotification.Name(rawValue: Constantes.NOTIFICACION_DATOS_DESCARGADOS), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         let not = NotificationCenter.default
        not.removeObserver(self, name: NSNotification.Name(rawValue: Constantes.NOTIFICACION_DATOS_DESCARGADOS), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //*******************************************************************************************************************************
    //Metodos de MapViewDelegate
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        //Deltas para la regoin que se va a mostrar en el mapview
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let region = MKCoordinateRegionMake(googlePlace.coordenadas, span)
        self.mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var cailePin = mapView.dequeueReusableAnnotationView(withIdentifier: "caile_pin")
        if cailePin == nil {
            cailePin = MKAnnotationView(annotation: annotation, reuseIdentifier: "caile_pin")
            cailePin?.image = #imageLiteral(resourceName: "ic_pn_caile")
            cailePin?.canShowCallout = true
        }
        return cailePin
    }
    
    //*******************************************************************************************************************************
    //Metodos generales
    /**
     Construye la interfaz de usuario
     */
    func construyeUI() {
        self.segmentedController.isEnabled = false
        self.mapView.delegate = self
        //Obteiene los marcadores del lugar seleccionado
        let pin = Pin(coordenada: googlePlace.coordenadas, titulo: googlePlace.nombre)
        //añade todas las ubicaciones
        self.mapView.addAnnotation(pin)
       
    }
    
    func cambiaController(controller:Int) {
        switch controller {
        case 0:
            container.segueIdentifierReceivedFromParent("uno")
        case 1:
            //El usuario selecciona el apartado de las reseñas
            if let controllerInfo = container!.currentViewController as? ViewControllerInfo{
                //Cambia del controller de info al de reseñas
                container.googlePlaceDetail = controllerInfo.detalle
            }else if let controllerFotos = container!.currentViewController as? ViewControllerFotos{
                //Cambia del controller de fotos al de reseñas
                 container.googlePlaceDetail = controllerFotos.googlePlaceDatail
            }
            container.segueIdentifierReceivedFromParent("dos")
        default:
            //El usuario selecciona el aparatdo de fotos
            if let controllerInfo = container!.currentViewController as? ViewControllerInfo{
                //Cambia de el controller de info al de fotos
                container.googlePlaceDetail = controllerInfo.detalle
            }else if let controllerResenas = container.currentViewController as? ViewControllerResenas{
                //Cambia de el controller de reseñas al de fotos 
                container.googlePlaceDetail = controllerResenas.googlePlaceDetalle
            }
            container.segueIdentifierReceivedFromParent("tres")
        }
    }
    
   @objc func activaSegmentecControl() {
        self.segmentedController.isEnabled = true
    }
    
    //*******************************************************************************************************************************
    //Accions
    
    
    @IBAction func onSegmentControlSelect(_ sender: UISegmentedControl) {
        cambiaController(controller: sender.selectedSegmentIndex)
    }
    
    //*******************************************************************************************************************************
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "container" {
            self.container = segue.destination as! ContainerViewController
            self.container.googlePlace = self.googlePlace
        }
    }


}
