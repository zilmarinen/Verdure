//
//  Canopy.swift
//
//
//  Created by Zack Brown on 27/07/2024.
//

import Bivouac
import Deltille
import Euclid

extension Grid.Triangle.Canopy {
 
    internal func vertices(_ scale: Grid.Triangle.Scale) ->  [Vector] { coordinates.map { Vector($0,
                                                                                                 scale) } }
}

extension Grid.Triangle.Canopy {
    
    internal func mesh(_ colorPalette: ColorPalette) throws -> Mesh {
        
        Mesh.wrap(vertices(.tile),
                  colorPalette.primary,
                  colorPalette.secondary,
                  1.0)
    }
}
