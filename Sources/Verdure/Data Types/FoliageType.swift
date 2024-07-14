//
//  FoliageType.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Deltille
import Euclid
import Foundation

public extension Double {
    func isApproximatelyEqual(to other: Double, withPrecision p: Double) -> Bool {
        self == other || abs(self - other) < p
    }
}

public extension Vector {
    
    /// Approximate equality
    func isApproximatelyEqual(to other: Vector, withPrecision p: Double = 1e-8) -> Bool {
        x.isApproximatelyEqual(to: other.x, withPrecision: p) &&
            y.isApproximatelyEqual(to: other.y, withPrecision: p) &&
            z.isApproximatelyEqual(to: other.z, withPrecision: p)
    }
}

public extension Polygon {
    
    func tempEdgePlane(for edge: LineSegment) -> Plane {
        let tangent = edge.end - edge.start
        let normal = tangent.cross(plane.normal).normalized()
        return Plane(normal: normal, pointOnPlane: edge.start)!
    }
    
    func inset(by t: Double) -> Self? {
        let v: [Vertex] = orderedEdges.indices.compactMap {
            let e0 = orderedEdges[$0]
            let e1 = orderedEdges[($0 + 1) % orderedEdges.count]

            let p0 = tempEdgePlane(for: e0)
            let p1 = tempEdgePlane(for: e1)

            let lhs = p0.translated(by: -p0.normal * t)
            let rhs = p1.translated(by: -p1.normal * t)

            let vertex = vertices.first { $0.position.isApproximatelyEqual(to: e0.end) }

            guard let vertex,
                  let intersection = lhs.intersection(with: rhs) else { return nil }

            return Vertex(intersection.origin, vertex.normal, vertex.texcoord, vertex.color)
        }

        return Self(v)
    }
}

public enum FoliageType: String,
                         CaseIterable,
                         Identifiable {

    case cherryBlossom = "Cherry Blossom"
    case chicle
    case goldenGingko = "Golden Gingko"
    case jacaranda
    case linden
    case spruce
    case thujaOccidentalis = "Thuja Occidentalis"
    
    public var id: String { rawValue.capitalized }
    
    public var area: Grid.Triangle.Canopy {
        
        switch self {
            
        case .cherryBlossom: return .truchet
        case .chicle: return .pinwheel
        case .goldenGingko: return .penrose
        case .jacaranda: return .wang
        case .linden: return .snub
        case .spruce: return .floret
        case .thujaOccidentalis: return .voronoi
        }
    }
}

extension FoliageType {
    
    internal var canopy: Canopy {
        
        switch self {
            
        case .cherryBlossom: return .cherryBlossom
        case .chicle: return .chicle
        case .goldenGingko: return .goldenGingko
        case .jacaranda: return .jacaranda
        case .linden: return .linden
        case .spruce: return .spruce
        case .thujaOccidentalis: return .thujaOccidentalis
        }
    }
    
    internal var trunk: Trunk {
        
        switch self {
            
        case .cherryBlossom: return .cherryBlossom
        case .chicle: return .chicle
        case .goldenGingko: return .goldenGingko
        case .jacaranda: return .jacaranda
        case .linden: return .linden
        case .spruce: return .spruce
        case .thujaOccidentalis: return .thujaOccidentalis
        }
    }
}

extension FoliageType {
    
    internal struct Canopy {
        
        internal static let cherryBlossom = Canopy(height: .tall,
                                                   profile: .staggered,
                                                   radius: .thin)
        
        internal static let chicle = Canopy(height: .tall,
                                            profile: .stepped,
                                            radius: .thin)
        
        internal static let goldenGingko = Canopy(height: .epic,
                                                  profile: .stepped,
                                                  radius: .chonki)
        
        internal static let jacaranda = Canopy(height: .tall,
                                               profile: .stepped,
                                               radius: .thin)
        
        internal static let linden = Canopy(height: .tall,
                                            profile: .equal,
                                            radius: .thick)
        
        internal static let spruce = Canopy(height: .epic,
                                            profile: .staggered,
                                            radius: .thin)
        
        internal static let thujaOccidentalis = Canopy(height: .tall,
                                                       profile: .stepped,
                                                       radius: .chonki)
        
        internal enum Profile {
            
            typealias CanopyProfile = (crown: Double,
                                       throne: Double,
                                       mantle: Double)
            
            case equal
            case staggered
            case stepped
            
            internal var value: CanopyProfile {
                
                switch self {
                    
                case .equal: return (crown: 0.75,
                                     throne: 0.5,
                                     mantle: 0.25)
                    
                case .staggered: return (crown: 0.8,
                                         throne: 0.3,
                                         mantle: 0.1)
                    
                case .stepped: return (crown: 0.6,
                                       throne: 0.35,
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
            
            case chonki
            case thin
            case thick
            
            internal var value: CanopyRadius {
                
                switch self {
                    
                case .chonki: return (apex: 0.35,
                                      crown: 0.1,
                                      throne: 0.0,
                                      mantle: 0.1,
                                      base: 0.3)
                    
                case .thin: return (apex: 0.21,
                                    crown: 0.1,
                                    throne: 0.0,
                                    mantle: 0.1,
                                    base: 0.21)
                    
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
            
            internal var value: Double {
                
                switch self {
                    
                case .epic: return .sqrt3 * .sqrt3
                case .tall: return .sqrt3
                }
            }
        }
        
        internal let height: Height
        internal let profile: Profile
        internal let radius: Radius
    }
}

extension FoliageType {
    
    internal struct Trunk {
        
        internal static let cherryBlossom = Trunk(area: .escher,
                                                  height: .tall,
                                                  radius: .thin)
        
        internal static let chicle = Trunk(area: .floret,
                                           height: .short,
                                           radius: .thick)
        
        internal static let goldenGingko = Trunk(area: .pinwheel,
                                                 height: .short,
                                                 radius: .thick)
        
        internal static let jacaranda = Trunk(area: .floret,
                                              height: .short,
                                              radius: .thick)
        
        internal static let linden = Trunk(area: .floret,
                                           height: .tall,
                                           radius: .thick)
        
        internal static let spruce = Trunk(area: .escher,
                                           height: .short,
                                           radius: .thin)
        
        internal static let thujaOccidentalis = Trunk(area: .truchet,
                                                      height: .short,
                                                      radius: .thick)
        
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
                    
                case .epic: return .sqrt3
                case .tall: return .sqrt3 / 2.0
                case .short: return .sqrt3 / 4.0
                }
            }
        }
        
        internal let area: Grid.Triangle.Canopy
        internal let height: Height
        internal let radius: Radius
    }
}

extension FoliageType {
    
    internal func render(canopy position: Vector) throws -> Mesh {
        
        let height = canopy.height.value
        let profile = canopy.profile.value
        let radius = canopy.radius.value
        
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
                
                let polygon = Polygon.face(vectors[i],
                                           //colors[i])
                                           colorPalette.primary)
                
                try polygons.append(polygon)
            }
        }
        
        return Mesh(polygons)
    }
    
    internal func render(trunk position: Vector) throws -> Mesh {
        
        let height = trunk.height.value
        let radius = trunk.radius.value
        
        guard let stencil = Polygon(trunk.area.vertices(scale: .tile,
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
            
            let polygon = Polygon.face(vectors,
                                       //colors)
                                       colorPalette.quaternary)
            
            try polygons.append(polygon)
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
            
        case .cherryBlossom: return .init(Color("F8C4B4"),
                                          Color("FF8787"),
                                          Theme.lightTrunkPrimary,
                                          Theme.lightTrunkSecondary)
            
        case .chicle: return .init(Color("F11A7B"),
                                   Color("982176"),
                                   Theme.lightTrunkPrimary,
                                   Theme.lightTrunkSecondary)
            
        case .goldenGingko: return .init(Color("F2BE22"),
                                         Color("F29727"),
                                         Theme.darkTrunkPrimary,
                                         Theme.darkTrunkPrimary)
            
        case .jacaranda: return .init(Color("713ABE"),
                                      Color("5B0888"),
                                      Theme.lightTrunkPrimary,
                                      Theme.lightTrunkSecondary)
            
        case .linden: return .init(Color("176B87"),
                                   Color("053B50"),
                                   Theme.lightTrunkPrimary,
                                   Theme.lightTrunkSecondary)
            
        case .spruce: return .init(Color("7A9D54"),
                                   Color("557A46"),
                                   Theme.darkTrunkPrimary,
                                   Theme.darkTrunkSecondary)
            
        case .thujaOccidentalis: return .init(Color("C3EDC0"),
                                              Color("79AC78"),
                                              Theme.darkTrunkPrimary,
                                              Theme.darkTrunkPrimary)
        }
    }
}
