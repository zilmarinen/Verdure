//
//  FoliageMeshOperation.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation

public class FoliageMeshOperation: ConcurrentOperation,
                                   ProducesResult {
    
    public var output: Result<Mesh, Error> = Result { throw ResultError.noResult }
    
    private let foliageType: FoliageType
    
    public init(foliageType: FoliageType) {
        
        self.foliageType = foliageType
    }
    
    public override func execute() {
        
        do {
            
            let origin = foliageType.area.center(at: .tile)
            let trunkOrigin = foliageType.trunk.area.center(at: .tile)
            let canopyOrigin = foliageType.area.center(at: .tile)
            let canopyElevation = Vector(0.0, foliageType.trunk.height.value, 0.0)
            
            let trunk = try foliageType.render(trunk: origin - trunkOrigin)
            let canopy = try foliageType.render(canopy: (origin - canopyOrigin) + canopyElevation)

            output = .success(trunk.union(canopy))
        }
        catch {

            output = .failure(error)
        }

        finish()
    }
}
