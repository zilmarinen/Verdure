//
//  FoliageType.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Deltille

public enum FoliageType: String,
                         CaseIterable,
                         Identifiable {

    case bristlecone
    case camphor
    case cherryBlossom = "Cherry Blossom"
    case goldenGingko = "Golden Gingko"
    case jacaranda
    case linden
    case manilkara
    case neem
    case sequoia
    case spruce
    case thujaOccidentalis = "Thuja Occidentalis"
    
    public var id: String { rawValue.capitalized }
    
    internal var canopy: Grid.Triangle.Canopy {
        
        switch self {
            
        case .bristlecone: return .conway
        case .camphor: return .ammann
        case .cherryBlossom: return .truchet
        case .goldenGingko: return .penrose
        case .jacaranda: return .wang
        case .linden: return .snub
        case .manilkara: return .pinwheel
        case .neem: return .escher
        case .sequoia: return .floret
        case .spruce: return .perlin
        case .thujaOccidentalis: return .voronoi
        }
    }
    
    internal var trunk: Trunk {
        
        switch self {
        
        case .bristlecone: return .one
        case .camphor: return .two
        case .cherryBlossom: return .one
        case .goldenGingko: return .three
        case .jacaranda: return .one
        case .linden: return .two
        case .manilkara: return .two
        case .neem: return .three
        case .sequoia: return .two
        case .spruce: return .three
        case .thujaOccidentalis: return .one
        }
    }
    
    public var footprint: Grid.Triangle.Footprint { canopy.footprint }
}

extension FoliageType {
    
    public var colorPalette: ColorPalette {
        
        switch self {
            
        case .bristlecone: return .init("BDA928",
                                        "473F2D",
                                        "543310",
                                        "74512D")
            
        case .camphor: return .init("63424B",
                                    "3A243B",
                                    "543310",
                                    "74512D")
            
        case .cherryBlossom: return .init("63424B",
                                          "3A243B",
                                          "543310",
                                          "74512D")
            
        case .goldenGingko: return .init("8B7D3A",
                                         "534A32",
                                         "543310",
                                         "74512D")
            
        case .jacaranda: return .init("FFA631",
                                      "CB7E1F",
                                      "543310",
                                      "74512D")
          
        case .linden: return .init("6B9362",
                                   "2A603B",
                                   "543310",
                                   "74512D")
            
        case .manilkara: return .init("BDA928",
                                      "473F2D",
                                      "543310",
                                      "74512D")
            
        case .neem: return .init("BDA928",
                                 "473F2D",
                                 "543310",
                                 "74512D")
            
        case .sequoia: return .init("63424B",
                                    "3A243B",
                                    "543310",
                                    "74512D")
             
        case .spruce: return .init("F08F90",
                                   "F2666C",
                                   "543310",
                                   "74512D")
            
        case .thujaOccidentalis: return .init("C2DBDF",
                                              "71A2A6",
                                              "543310",
                                              "74512D")
        }
    }
}
