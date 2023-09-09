//
//  Footprint.swift
//
//  Created by Zack Brown on 06/09/2023.
//

import Bivouac
import Euclid

extension Grid.Footprint {
    
    var center: Vector {
        
        var vector = Vector.zero
        
        for coordinate in coordinates {
            
            vector += coordinate.convert(to: .tile)
        }
        
        return vector / Double(coordinates.count)
    }
}

