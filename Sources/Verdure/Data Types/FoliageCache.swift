//
//  FoliageCache.swift
//
//  Created by Zack Brown on 15/10/2023.
//

import Bivouac
import Dependencies
import Euclid

public final class FoliageCache: AssetCache,
                                 DependencyKey {
    
    static public var liveValue = FoliageCache([:])
    
    public func mesh(for foliageType: FoliageType) -> Mesh? { mesh(foliageType.id) }
}
