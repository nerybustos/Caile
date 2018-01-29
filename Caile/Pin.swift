//
//  Pin.swift
//  Caile
//
//  Created by Nery on 27/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordenada:CLLocationCoordinate2D,titulo:String) {
        self.coordinate = coordenada
        self.title = titulo
    }
}

