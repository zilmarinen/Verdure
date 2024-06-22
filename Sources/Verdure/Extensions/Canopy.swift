//
//  Canopy.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Deltille
import Euclid
import Foundation

extension Grid.Canopy {
    
    internal func vertices(scale: Grid.Scale,
                           normal: Vector,
                           color: Color) -> [Vertex] { coordinates.map { Vertex($0.convert(to: scale),
                                                                                normal,
                                                                                nil,
                                                                                color)} }
    
    func center(at scale: Grid.Scale) -> Vector { .zero }
}

