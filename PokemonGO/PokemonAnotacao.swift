//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by Enzo on 26/09/23.
//

import UIKit
import MapKit

class PokemonAnotacao:  NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
}

}
