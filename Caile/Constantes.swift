//
//  Constantes.swift
//  Caile
//
//  Created by Nery on 30/10/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import Foundation
//Contiene todas las constantes que implementa la aplicacion
class Constantes{
    //Faces que se muestran aleatoreamente en la pantalla de incio
    internal static let farcesDeBorrachos =
        [0:"\"Una no es ninguna \"🍺",
         1:"\"¡La última y nos vamos!\"🚶🏼‍♂️",
         2:"\"¿Cuál es mi vaso?\"🥃",
         3:"\"No estoy pedo\"😵",
         4:"\"¿Quén se tomó mi chela?\"😠",
         5:"\"Es que me pegó el aire\"💨",
         6:"\"No lo vuelvo a hacer\"🤒",
         7:"\"Te juro que solo me tomé dos\"🍻",
         9:"\"Te quiero un chingo güey\"👨‍❤️‍👨",
         10:"\"¡Esa es mi rola!\" 🕺",
         11:"\"¡No me dejes marcarle \"📞",
         12:"\"¡L@ amo güey!\"😭",
         13:"\"Yo no quería\"😔",
         14:"\"¡Salud!\" 🍻",
         15:"\"¡Yo invito!\" 💵",
         16:"\"¿Alguien vio mi cel?\"📲",
         17:"\"¿De aquí a dónde?\"😏"
         ]
    //internal static let KEY_GOOGLE_PLACES = "AIzaSyAvlPKHD5-TZx55cJnrEA0eULlOTsEFhPc"
    //Identificadores para los segues
    internal static let SEGUE_INGRESAR = "segue_ingresar"
    //Identificadores para ViewControllers
    internal static let VIEW_CONTROLLER_CREAR_CUENTA = "viewControllerCrearCuenta"
    internal static let VIEW_CONTROLLER_INGRESAR = "viewControllerLogin"

    internal static let NOTIFICACION_DATOS_DESCARGADOS = "not_datos_descargados"
    
    //identificadores para los ids de los objetos de menu de hamburgesa
     internal static let ID_SALIR = 0
    //Identificadores para las consultas de los servicios web
    internal static let WEBSERVICES_LUGARES_CERCANOS = 1
    internal static let WEBSERVICES_DETALLE = 2

    //Titulo de los objetos de menu de hamburgesa
    internal static let TITULO_MENU_SALIR = "Cerrar sesión"
    //URL consulta de lugares
     internal static let URL_LUGARES_CERCANOS = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
     internal static let URL_IMAGEN_REFERENCIA = "https://maps.googleapis.com/maps/api/place/photo?"
     internal static let URL_DETALLES = "https://maps.googleapis.com/maps/api/place/details/json?"
     internal static let KEY_GOOGLE_PLACES = "AIzaSyC8Xaj7GpR2xeNGOolslBzj3GjwfMbL5_w"
    

    
    
}
