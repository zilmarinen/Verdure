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
 
    internal func vertices(_ scale: Grid.Triangle.Scale) -> [Vector] { coordinates.map { Vector($0,
                                                                                                scale) } }
    
    internal var polygon: Polygon {
        
        get throws {
            
            let vertices = vertices(.tile).map { Vertex($0) }
            
            guard let polygon = Polygon(vertices) else { throw GeometryError.invalidPolygon }
            
            return polygon
        }
    }
}
