//
//  Trunk.swift
//
//  Created by Zack Brown on 27/07/2024.
//

import Bivouac
import Deltille
import Euclid

public enum Trunk: String,
                   CaseIterable,
                   Identifiable {
    
    case one
    case two
    case three
    
    public var id: String { rawValue.capitalized }
    
    internal var canopy: Grid.Triangle.Canopy {
        
        switch self {
            
        case .one: return .truchet
        case .two: return .snub
        case .three: return .floret
        }
    }
}

extension Trunk {
    
    internal func mesh(_ colorPalette: ColorPalette) throws -> Mesh {
        
        Mesh.wrap(canopy.vertices(.tile),
                  nil,
                  colorPalette.quaternary,
                  0.5)
    }
}
