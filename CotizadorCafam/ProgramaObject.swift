//
//  ProgramaObject.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 26/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//
import Foundation

class ProgramaObject {
   
    var IDPrograma: String!
    var Nombre: String!
    
    init(nombre: String)
    {
        self.Nombre = nombre
    }
    init(nombre: String, idPrograma: String)
    {
        self.Nombre = nombre
        self.IDPrograma = idPrograma;
    }
}

