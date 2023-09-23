//
//  Footprint.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Euclid
import Foundation

extension Grid.Footprint.Area {
    
    internal func vertices(scale: Grid.Scale,
                           normal: Vector,
                           color: Color) -> [Vertex] { perimeter.map { Vertex($0.convert(to: scale),
                                                                              normal,
                                                                              nil,
                                                                              color)} }
}
