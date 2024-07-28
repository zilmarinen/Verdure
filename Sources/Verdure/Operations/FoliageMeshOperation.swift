//
//  FoliageMeshOperation.swift
//
//  Created by Zack Brown on 21/09/2023.
//

import Bivouac
import Deltille
import Euclid
import Foundation
import PeakOperation

public class FoliageMeshOperation: ConcurrentOperation,
                                   ProducesResult {
    
    public var output: Result<Mesh, Error> = Result { throw ResultError.noResult }
    
    private let foliageType: FoliageType
    
    public init(foliageType: FoliageType) {
        
        self.foliageType = foliageType
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let trunk = try foliageType.trunk.mesh(foliageType.colorPalette)
            let canopy = try foliageType.canopy.mesh(foliageType.colorPalette)
            
            let origin = foliageType.footprint.center(.tile)
            let trunkOffset = origin - foliageType.trunk.canopy.footprint.center(.tile)
            let canopyOffset = Vector(0.0, trunk.bounds.size.y, 0.0)
            
            let mesh = trunk.translated(by: trunkOffset).merge(canopy.translated(by: canopyOffset))
            
            output = .success(mesh)
        }
        catch {

            output = .failure(error)
        }

        finish()
    }
}
