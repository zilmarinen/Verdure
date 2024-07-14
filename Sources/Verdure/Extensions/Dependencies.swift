//
//  Dependencies.swift
//
//  Created by Zack Brown on 09/07/2024.
//

import Dependencies

extension DependencyValues {
    
    public var foliageCache: FoliageCache {
        
        get { self[FoliageCache.self] }
        set { self[FoliageCache.self] = newValue }
    }
}

