//
//  CanopyType.swift
//
//  Created by Zack Brown on 01/08/2024.
//

import Bivouac
import Deltille
import Euclid

public enum CanopyType: String,
                        CaseIterable,
                        Identifiable {

    case rounded
    case stacked
    case tapered
    
    public var id: String { rawValue.capitalized }
}

extension CanopyType {
    
    internal func mesh(_ canopy: Grid.Triangle.Canopy,
                       _ colorPalette: ColorPalette) throws -> Mesh {
        
        switch self {
            
        case .rounded,
             .tapered: return try rounded(canopy,
                                          colorPalette,
                                          self == .tapered)
        case .stacked: return try stacked(canopy,
                                          colorPalette)
        }
    }
    
    internal func rounded(_ canopy: Grid.Triangle.Canopy,
                          _ colorPalette: ColorPalette,
                          _ tapered: Bool) throws -> Mesh {
        
        let template = try canopy.polygon
        let inset = 1.0 / 7.0
        let ratio = 2.0 / 7.0
        
        guard let base = template.inset(by: -inset),
              let apex = template.inset(by: inset) else { throw MeshError.invalidPolygon }
        
        let s = Vector(0.0, ratio, 0.0)
        let t = Vector(0.0, ratio * 3.0, 0.0)
        let u = Vector(0.0, ratio * 7.0, 0.0)
        let center = template.center + u
        
        var polygons: [Polygon] = []
        
        for i in 0..<template.vertices.count {
            
            let j = (i + 1) % template.vertices.count
            
            let v0 = apex.vertices[i].position
            let v1 = apex.vertices[j].position
            let v2 = base.vertices[i].position + s
            let v3 = base.vertices[j].position + s
            let v4 = (tapered ? template.vertices[i].position : base.vertices[i].position) + t
            let v5 = (tapered ? template.vertices[j].position : base.vertices[j].position) + t
            let v6 = v0 + u
            let v7 = v1 + u
            
            try polygons.append(Polygon.face([v0, v1, v2], colorPalette.primary))
            try polygons.append(Polygon.face([v1, v3, v2], colorPalette.primary))
            try polygons.append(Polygon.face([v5, v4, v2], colorPalette.primary))
            try polygons.append(Polygon.face([v3, v5, v2], colorPalette.primary))
            try polygons.append(Polygon.face([v4, v5, v6], colorPalette.primary))
            try polygons.append(Polygon.face([v5, v7, v6], colorPalette.primary))
            try polygons.append(Polygon.face([center, v6, v7], colorPalette.primary))
        }
        
        return Mesh(polygons)
    }
    
    internal func stacked(_ canopy: Grid.Triangle.Canopy,
                          _ colorPalette: ColorPalette) throws -> Mesh {
        
        let template = try canopy.polygon
        let inset = 1.0 / 7.0
        let ratio = 2.0 / 7.0
        
        guard let base = template.inset(by: -inset),
              let apex = template.inset(by: inset) else { throw MeshError.invalidPolygon }
        
        let a = Mesh.wrap(base.vertices.map { $0.position },
                          colorPalette.primary,
                          colorPalette.secondary,
                          ratio * 4)
        
        let b = Mesh.wrap(template.vertices.map { $0.position + Vector(0.0, ratio * 4, 0.0) },
                          colorPalette.primary,
                          colorPalette.secondary,
                          ratio * 2)
        
        let c = Mesh.wrap(apex.vertices.map { $0.position + Vector(0.0, ratio * 6, 0.0) },
                          colorPalette.primary,
                          colorPalette.secondary,
                          ratio)
        
        return a.merge(b.merge(c))
    }
}
