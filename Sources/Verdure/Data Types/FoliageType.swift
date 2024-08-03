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
    
    internal var canopyType: CanopyType {
        
        switch self {
            
        case .bristlecone: return .rounded
        case .camphor: return .stacked
        case .cherryBlossom: return .rounded
        case .goldenGingko: return .rounded
        case .jacaranda: return .stacked
        case .linden: return .tapered
        case .manilkara: return .rounded
        case .neem: return .stacked
        case .sequoia: return .tapered
        case .spruce: return .tapered
        case .thujaOccidentalis: return .stacked
        }
    }
    
    internal var trunkType: TrunkType {
        
        switch self {
            
        case .bristlecone: return .medium
        case .camphor: return .medium
        case .cherryBlossom: return .small
        case .goldenGingko: return .medium
        case .jacaranda: return .small
        case .linden: return .small
        case .manilkara: return .small
        case .neem: return .small
        case .sequoia: return .small
        case .spruce: return .small
        case .thujaOccidentalis: return .large
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
            
        case .camphor: return .init("6482AD",
                                    "7FA1C3",
                                    "543310",
                                    "74512D")
            
        case .cherryBlossom: return .init("FF4E88",
                                          "FF8C9E",
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
          
        case .linden: return .init("21694B",
                                   "32A47B",
                                   "837067",
                                   "B29C91")
            
        case .manilkara: return .init("BDA928",
                                      "473F2D",
                                      "543310",
                                      "74512D")
            
        case .neem: return .init("BDA928",
                                 "473F2D",
                                 "543310",
                                 "74512D")
            
        case .sequoia: return .init("DFD3C3",
                                    "F8EDE3",
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
