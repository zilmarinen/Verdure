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
            
            let trunk = try foliageType.render(trunk: origin - foliageType.trunk.center(at: .tile))
            let canopy = try foliageType.render(canopy: (origin - foliageType.area.center(at: .tile)) + Vector(0.0, foliageType.trunkHeight.value, 0.0))

            output = .success(trunk.union(canopy))
        }
        catch {

            output = .failure(error)
        }

        finish()
    }
}
