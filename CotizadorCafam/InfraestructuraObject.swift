//
//  InfraestructuraObject.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 20/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import Foundation
import SwiftyJSON

class InfraestructuraObject {
    var idInfraestructura: String!
    var idGeografia: Int!
    var nombre: String!
    var direccion: String!;
    var estado: String!;
    var fechaModificacion:String!;
    var usuarioModificacion:String!
    
    required init(json: JSON)
    {
      print("hpta",json["Nombre"])
      nombre = json["Nombre"].string
    }
}
