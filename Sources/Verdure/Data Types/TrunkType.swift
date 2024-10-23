//
//  TrunkType.swift
//
//  Created by Zack Brown on 01/08/2024.
//

import Bivouac
import Deltille
import Euclid

public enum TrunkType: String,
                       CaseIterable,
                       Identifiable {

    case small
    case medium
    case large
    
    public var id: String { rawValue.capitalized }
    
    internal var canopy: Grid.Triangle.Canopy {
        
        switch self {
            
        case .small: return .perlin
        case .medium: return .floret
        case .large: return .penrose
        }
    }
}

extension TrunkType {
    
    internal func mesh(_ canopy: Grid.Triangle.Canopy,
                       _ colorPalette: ColorPalette) throws -> Mesh {
        
        let template = try canopy.polygon
        let inset = 1.0 / 7.0
        let ratio = 1.5 / 7.0
        
        guard let base = template.inset(by: -inset),
              let trunk = template.inset(by: inset) else { throw GeometryError.invalidPolygon }
        
        let vertices = canopy.vertices(.tile).mid()
        let peak = trunk.vertices.map { $0.position }.mid()
        
        let s = Vector(0.0, ratio, 0.0)
        let t = Vector(0.0, ratio * 3.0, 0.0)
        
        var polygons: [Polygon] = []
        
        for i in 0..<vertices.count {
            
            let j = ((i - 1) + vertices.count) % vertices.count
            
            let v0 = vertices[i]
            let v1 = vertices[j]
            let v2 = base.vertices[i].position
            let v3 = template.vertices[i].position + s
            let v4 = trunk.vertices[i].position + t
            let v5 = peak[i] + t
            let v6 = peak[j] + t
            
            try polygons.append(Polygon.face([v0, v3, v2], colorPalette.tertiary))
            try polygons.append(Polygon.face([v2, v3, v1], colorPalette.tertiary))
            try polygons.append(Polygon.face([v0, v4, v3], colorPalette.tertiary))
            try polygons.append(Polygon.face([v3, v4, v1], colorPalette.tertiary))
            try polygons.append(Polygon.face([v0, v5, v4], colorPalette.tertiary))
            try polygons.append(Polygon.face([v4, v6, v1], colorPalette.tertiary))
        }
        
        return Mesh(polygons)
    }
}
