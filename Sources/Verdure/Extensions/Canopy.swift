//
//  Canopy.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Deltille
import Euclid

extension Grid.Triangle.Canopy {
    
    internal func vertices(scale: Grid.Triangle.Scale,
                           normal: Vector,
                           color: Color) -> [Vertex] { coordinates.map { Vertex(Vector($0,
                                                                                       scale),
                                                                                normal,
                                                                                nil,
                                                                                color)} }
    
    func center(at scale: Grid.Triangle.Scale) -> Vector { .zero }
}

