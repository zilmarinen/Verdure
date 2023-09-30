//
//  FoliageType.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Euclid
import Foundation

extension FoliageType {
    
    internal enum Canopy {
        
        internal enum Profile {
            
            typealias CanopyProfile = (crown: Double,
                                       throne: Double,
                                       mantle: Double)
            
            case equal
            case staggered
            
            internal var value: CanopyProfile {
                
                switch self {
                    
                case .equal: return (crown: 0.75,
                                     throne: 0.5,
                                     mantle: 0.25)
                    
                case .staggered: return (crown: 0.8,
                                         throne: 0.3,
                                         mantle: 0.1)
                }
            }
        }
        
        internal enum Radius {
            
            typealias CanopyRadius = (apex: Double,
                                      crown: Double,
                                      throne: Double,
                                      mantle: Double,
                                      base: Double)
         
            case thin
            case thick
            
            internal var value: CanopyRadius {
                
                switch self {
                    
                case .thin: return (apex: 0.2,
                                    crown: 0.1,
                                    throne: 0.0,
                                    mantle: 0.1,
                                    base: 0.2)
                    
                case .thick: return (apex: 0.2,
                                     crown: 0.1,
                                     throne: 0.0,
                                     mantle: 0.1,
                                     base: 0.2)
                }
            }
        }
        
        internal enum Height {
            
            case epic
            case tall
            case short
            
            internal var value: Double {
                
                switch self {
                
                case .epic: return 3.0
                case .tall: return 2.0
                case .short: return 1.0
                }
            }
        }
    }
    
    internal var canopyProfile: Canopy.Profile {
        
        switch self {
            
        case .cherryBlossom: return .staggered
        case .chicle: return .equal
        case .goldenGingko: return .equal
        case .jacaranda: return .staggered
        case .linden: return .staggered
        case .spruce: return .staggered
        case .thujaOccidentalis: return .staggered
        }
    }
    
    internal var canopyRadius: Canopy.Radius {
        
        switch self {
            
        case .cherryBlossom: return .thin
        case .chicle: return .thick
        case .goldenGingko: return .thick
        case .jacaranda: return .thin
        case .linden: return .thick
        case .spruce: return .thin
        case .thujaOccidentalis: return .thick
        }
    }
    
    internal var canopyHeight: Canopy.Height {
        
        switch self {
            
        case .cherryBlossom: return .tall
        case .chicle: return .short
        case .goldenGingko: return .tall
        case .jacaranda: return .short
        case .linden: return .short
        case .spruce: return .epic
        case .thujaOccidentalis: return .tall
        }
    }
    
    internal func render(canopy position: Vector) throws -> Mesh {
        
        let height = canopyHeight.value
        let profile = canopyProfile.value
        let radius = canopyRadius.value
        
        guard let stencil = Polygon(area.vertices(scale: .tile,
                                                  normal: .up,
                                                  color: colorPalette.primary)),
              let apex = stencil.inset(by: radius.apex),
              let crown = stencil.inset(by: radius.crown),
              let throne = stencil.inset(by: radius.throne),
              let mantle = stencil.inset(by: radius.mantle),
              let base = stencil.inset(by: radius.base) else { throw MeshError.invalidStencil }
        
        let apexElevation = Vector(0.0, height, 0.0)
        let crownElevation = Vector(0.0, height * profile.crown, 0.0)
        let throneElevation = Vector(0.0, height * profile.throne, 0.0)
        let mantleElevation = Vector(0.0, height * profile.mantle, 0.0)
        
        let crownColor = colorPalette.secondary.lerp(colorPalette.primary, profile.crown)
        let throneColor = colorPalette.secondary.lerp(colorPalette.primary, profile.throne)
        let mantleColor = colorPalette.secondary.lerp(colorPalette.primary, profile.throne)
        
        let colors = [[colorPalette.secondary, colorPalette.secondary, mantleColor, mantleColor],
                      [mantleColor, mantleColor, throneColor, throneColor],
                      [throneColor, throneColor, crownColor, crownColor],
                      [crownColor, crownColor, colorPalette.primary, colorPalette.primary]]
        
        var polygons = [base.inverted().translated(by: position),
                        apex.translated(by: position + apexElevation)]
        
        for i in stencil.vertices.indices {

            let j = (i + 1) % stencil.vertices.count

            let av0 = position + apex.vertices[i].position + apexElevation
            let av1 = position + apex.vertices[j].position + apexElevation
            let cv0 = position + crown.vertices[i].position + crownElevation
            let cv1 = position + crown.vertices[j].position + crownElevation
            let tv0 = position + throne.vertices[i].position + throneElevation
            let tv1 = position + throne.vertices[j].position + throneElevation
            let mv0 = position + mantle.vertices[i].position + mantleElevation
            let mv1 = position + mantle.vertices[j].position + mantleElevation
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
    
    internal enum Trunk {
        
        internal enum Radius {
            
            typealias TrunkRadius = (apex: Double,
                                     base: Double)
         
            case thin
            case thick
            
            internal var value: TrunkRadius {
                
                switch self {
                    
                case .thin: return (apex: 0.25,
                                    base: 0.15)
                    
                case .thick: return (apex: 0.25,
                                     base: 0.1)
                }
            }
        }
        
        internal enum Height {
            
            case epic
            case tall
            case short
            
            internal var value: Double {
                
                switch self {
                
                case .epic: return 1.5
                case .tall: return 1.0
                case .short: return 0.5
                }
            }
        }
    }
    
    internal var trunkRadius: Trunk.Radius {
        
        switch self {
            
        case .cherryBlossom: return .thin
        case .chicle: return .thick
        case .goldenGingko: return .thick
        case .jacaranda: return .thick
        case .linden: return .thick
        case .spruce: return .thin
        case .thujaOccidentalis: return .thick
        }
    }
    
    internal var trunkHeight: Trunk.Height {
        
        switch self {
            
        case .cherryBlossom: return .epic
        case .chicle: return .short
        case .goldenGingko: return .tall
        case .jacaranda: return .short
        case .linden: return .short
        case .spruce: return .tall
        case .thujaOccidentalis: return .short
        }
    }
    
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
    
    internal func render(trunk position: Vector) throws -> Mesh {
        
        let height = trunkHeight.value
        let radius = trunkRadius.value
        
        guard let stencil = Polygon(trunk.vertices(scale: .tile,
                                                   normal: .up,
                                                   color: colorPalette.tertiary)),
              let apex = stencil.inset(by: radius.apex),
              let base = stencil.inset(by: radius.base) else { throw MeshError.invalidStencil }
        
        let apexElevation = Vector(0.0, height, 0.0)
        
        var polygons = [base.inverted().translated(by: position),
                        apex.translated(by: position + apexElevation)]
        
        for i in stencil.vertices.indices {
            
            let j = (i + 1) % stencil.vertices.count
            
            let av0 = position + apex.vertices[i].position + apexElevation
            let av1 = position + apex.vertices[j].position + apexElevation
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

extension FoliageType {
    
    internal enum Theme {
     
        internal static let darkTrunkPrimary = Color("65451F")
        internal static let darkTrunkSecondary = Color("765827")
        
        internal static let lightTrunkPrimary = Color("C8AE7D")
        internal static let lightTrunkSecondary = Color("EAC696")
    }
    
    public var colorPalette: ColorPalette {
        
        switch self {
            
        case .cherryBlossom: return .init(primary: Color("F8C4B4"),
                                          secondary: Color("FF8787"),
                                          tertiary: Theme.lightTrunkPrimary,
                                          quaternary: Theme.lightTrunkSecondary)
            
        case .chicle: return .init(primary: Color("F11A7B"),
                                   secondary: Color("982176"),
                                   tertiary: Theme.lightTrunkPrimary,
                                   quaternary: Theme.lightTrunkSecondary)
            
        case .goldenGingko: return .init(primary: Color("F2BE22"),
                                         secondary: Color("F29727"),
                                         tertiary: Theme.darkTrunkPrimary,
                                         quaternary: Theme.darkTrunkPrimary)
            
        case .jacaranda: return .init(primary: Color("713ABE"),
                                      secondary: Color("5B0888"),
                                      tertiary: Theme.lightTrunkPrimary,
                                      quaternary: Theme.lightTrunkSecondary)
            
        case .linden: return .init(primary: Color("176B87"),
                                   secondary: Color("053B50"),
                                   tertiary: Theme.lightTrunkPrimary,
                                   quaternary: Theme.lightTrunkSecondary)
            
        case .spruce: return .init(primary: Color("7A9D54"),
                                   secondary: Color("557A46"),
                                   tertiary: Theme.darkTrunkPrimary,
                                   quaternary: Theme.darkTrunkSecondary)
            
        case .thujaOccidentalis: return .init(primary: Color("C3EDC0"),
                                              secondary: Color("79AC78"),
                                              tertiary: Theme.darkTrunkPrimary,
                                              quaternary: Theme.darkTrunkPrimary)
        }
    }
}
