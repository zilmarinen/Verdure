//
//  FoliageType.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Euclid
import Foundation

extension FoliageType {
    
    typealias CanopyApex = (apex: Vector,
                            crown: Vector,
                            throne: Vector,
                            mantle: Vector)
    
    typealias CanopyRadius = (apex: Double,
                              crown: Double,
                              throne: Double,
                              mantle: Double,
                              base: Double)
    
    internal var canopy: Grid.Footprint.Area { area }
    
    internal var canopyApex: CanopyApex {
        
        switch self {
            
        case .cherryBlossom:
            
            let apex = Grid.Triangle.Kite.base * .silver
            let step = apex / 5.0
            
            return (apex: Vector(0.0, step * 5.0, 0.0),
                    crown: Vector(0.0, step * 3.0, 0.0),
                    throne: Vector(0.0, step * 2.0, 0.0),
                    mantle: Vector(0.0, step, 0.0))
            
        case .chicle:
            
            return (apex: Vector(0.0, 1.0, 0.0),
                    crown: Vector(0.0, 0.75, 0.0),
                    throne: Vector(0.0, 0.5, 0.0),
                    mantle: Vector(0.0, 0.25, 0.0))
            
        case .goldenGingko:
            
            let apex = Grid.Triangle.Kite.base * .silver * .silver
            let step = apex / 6.0
            
            return (apex: Vector(0.0, step * 6.0, 0.0),
                    crown: Vector(0.0, step * 3.0, 0.0),
                    throne: Vector(0.0, step * 2.0, 0.0),
                    mantle: Vector(0.0, step, 0.0))
            
        case .jacaranda:
            
            let apex = Grid.Triangle.Kite.base * .silver * (.silver / 2.0)
            let step = apex / 7.0
            
            return (apex: Vector(0.0, step * 7.0, 0.0),
                    crown: Vector(0.0, step * 4.0, 0.0),
                    throne: Vector(0.0, step * 2.0, 0.0),
                    mantle: Vector(0.0, step, 0.0))
            
        case .spruce:
            
            let apex = Grid.Triangle.Kite.base * .silver * 2.0
            let step = apex / 5.0
            
            return (apex: Vector(0.0, step * 5.0, 0.0),
                    crown: Vector(0.0, step * 3.0, 0.0),
                    throne: Vector(0.0, step * 2.0, 0.0),
                    mantle: Vector(0.0, step, 0.0))
            
        default:
            
            let apex = Grid.Triangle.Kite.base * .silver
            let step = apex / 5.0
            
            return (apex: Vector(0.0, step * 5.0, 0.0),
                    crown: Vector(0.0, step * 3.0, 0.0),
                    throne: Vector(0.0, step * 2.0, 0.0),
                    mantle: Vector(0.0, step, 0.0))
        }
    }
    
    internal var canopyRadius: CanopyRadius {
        
        switch self {
            
        case .cherryBlossom:
            
            let radius = 0.21
            let step = radius / 5.0
            
            return (apex: step * 5.0,
                    crown: step * 2.0,
                    throne: step * 1.0,
                    mantle: step * 3.0,
                    base: step * 5.0)
            
        case .chicle:
            
            let radius = 0.21
            let step = radius / 5.0
            
            return (apex: step * 5.0,
                    crown: step * 2.0,
                    throne: step * 1.0,
                    mantle: step * 3.0,
                    base: step * 5.0)
            
        case .goldenGingko:
            
            let radius = 0.4
            let step = radius / 5.0
            
            return (apex: step * 6.0,
                    crown: step * 2.0,
                    throne: step * 1.0,
                    mantle: step * 2.0,
                    base: step * 3.5)
            
        case .jacaranda:
            
            let radius = 0.21
            let step = radius / 6.0
            
            return (apex: step * 6.0,
                    crown: step * 2.0,
                    throne: step * 1.0,
                    mantle: step * 2.0,
                    base: step * 4.5)
            
        case .spruce:
            
            let radius = 0.3
            let step = radius / 5.0
            
            return (apex: step * 6.0,
                    crown: step * 2.0,
                    throne: step * 1.0,
                    mantle: step * 0.5,
                    base: step * 5.0)
            
        default:
            
            let radius = 0.21
            let step = radius / 5.0
            
            return (apex: step * 5.0,
                    crown: step * 2.0,
                    throne: step * 2.0,
                    mantle: step * 3.0,
                    base: step * 5.0)
        }
    }
    
    internal func render(canopy position: Vector) throws -> Mesh {
        
        let radius = canopyRadius
        
        guard let stencil = Polygon(canopy.vertices(scale: .tile,
                                                    normal: .up,
                                                    color: colorPalette.primary)),
              let apex = stencil.inset(by: radius.apex),
              let crown = stencil.inset(by: radius.crown),
              let throne = stencil.inset(by: radius.throne),
              let mantle = stencil.inset(by: radius.mantle),
              let base = stencil.inset(by: radius.base) else { throw MeshError.invalidStencil }
        
        let peak = canopyApex
        
        var polygons = [base.inverted().translated(by: position),
                        apex.translated(by: position + peak.apex)]
        
        let c0 = colorPalette.primary.lerp(colorPalette.secondary, 0.25)
        let c1 = colorPalette.primary.lerp(colorPalette.secondary, 0.5)
        let c2 = colorPalette.primary.lerp(colorPalette.secondary, 0.75)
        
        let colors = [[colorPalette.secondary, colorPalette.secondary, c2, c2],
                      [c2, c2, c1, c1],
                      [c1, c1, c0, c0],
                      [c0, c0, colorPalette.primary, colorPalette.primary]]
        
        for i in stencil.vertices.indices {

            let j = (i + 1) % stencil.vertices.count

            let av0 = position + apex.vertices[i].position + peak.apex
            let av1 = position + apex.vertices[j].position + peak.apex
            let cv0 = position + crown.vertices[i].position + peak.crown
            let cv1 = position + crown.vertices[j].position + peak.crown
            let tv0 = position + throne.vertices[i].position + peak.throne
            let tv1 = position + throne.vertices[j].position + peak.throne
            let mv0 = position + mantle.vertices[i].position + peak.mantle
            let mv1 = position + mantle.vertices[j].position + peak.mantle
            let bv0 = position + base.vertices[i].position
            let bv1 = position + base.vertices[j].position

            let vectors = [[bv0, bv1, mv1, mv0],
                           [mv0, mv1, tv1, tv0],
                           [tv0, tv1, cv1, cv0],
                           [cv0, cv1, av1, av0]]
            
            for i in vectors.indices {
                
                let face = Polygon.Face(vectors[i],
                                        colors: colors[i])

                try polygons.glue(face?.polygon)
            }
        }
        
        return Mesh(polygons)
    }
}

extension FoliageType {
    
    typealias TrunkRadius = (apex: Double,
                             base: Double)
    
    internal var trunk: Grid.Footprint.Area {
        
        switch self {
            
        case .cherryBlossom: return .escher
        case .chicle: return .floret
        case .goldenGingko: return .pinwheel
        case .jacaranda: return .escher
        case .linden: return .floret
        case .spruce: return .escher
        case .thujaOccidentalis: return .truchet
        }
    }
    
    internal var trunkApex: Vector {
        
        switch self {
            
        case .cherryBlossom: return Vector(0.0, Grid.Triangle.Kite.base * 1.5, 0.0)
        case .chicle: return Vector(0.0, Grid.Triangle.Kite.base, 0.0)
        case .goldenGingko: return Vector(0.0, Grid.Triangle.Kite.base, 0.0)
        case .jacaranda: return Vector(0.0, Grid.Triangle.Kite.base * 1.5, 0.0)
        case .linden: return Vector(0.0, Grid.Triangle.Kite.base, 0.0)
        case .spruce: return Vector(0.0, Grid.Triangle.Kite.base, 0.0)
        case .thujaOccidentalis: return Vector(0.0, Grid.Triangle.Kite.base, 0.0)
        }
    }
    
    internal var trunkRadius: TrunkRadius {
        
        switch self {
            
        case .cherryBlossom: return (apex: 0.25,
                                     base: 0.15)
            
        case .chicle: return (apex: 0.25,
                              base: 0.15)
            
        case .goldenGingko: return (apex: 0.25,
                                    base: 0.15)
            
        case .jacaranda: return (apex: 0.25,
                                 base: 0.15)
            
        case .linden: return (apex: 0.25,
                              base: 0.15)
            
        case .spruce: return (apex: 0.25,
                              base: 0.15)
            
        case .thujaOccidentalis: return (apex: 0.25,
                                         base: 0.15)
        }
    }
    
    internal func render(trunk position: Vector) throws -> Mesh {
        
        let radius = trunkRadius
        
        guard let stencil = Polygon(trunk.vertices(scale: .tile,
                                                   normal: .up,
                                                   color: colorPalette.tertiary)),
              let base = stencil.inset(by: radius.base),
              let apex = stencil.inset(by: radius.apex) else { throw MeshError.invalidStencil }
        
        let peak = trunkApex
        
        var polygons = [base.inverted().translated(by: position),
                        apex.translated(by: position + peak)]
        
        for i in stencil.vertices.indices {
            
            let j = (i + 1) % stencil.vertices.count
            
            let av0 = position + apex.vertices[i].position + peak
            let av1 = position + apex.vertices[j].position + peak
            let bv0 = position + base.vertices[i].position
            let bv1 = position + base.vertices[j].position
            
            let vectors = [bv0,
                           bv1,
                           av1,
                           av0]
            
            let colors = [colorPalette.quaternary,
                          colorPalette.quaternary,
                          colorPalette.tertiary,
                          colorPalette.tertiary]
            
            let face = Polygon.Face(vectors,
                                    colors: colors)
            
            try polygons.glue(face?.polygon)
        }
        
        return Mesh(polygons)
    }
}
