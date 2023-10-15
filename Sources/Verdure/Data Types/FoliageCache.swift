//
//  FoliageCache.swift
//
//  Created by Zack Brown on 15/10/2023.
//

import Bivouac
import Euclid
import Foundation

public struct FoliageCache {
    
    public let meshes: [FoliageType : Mesh]
    
    public func mesh(for foliageType: FoliageType) -> Mesh? { meshes[foliageType] }
}
