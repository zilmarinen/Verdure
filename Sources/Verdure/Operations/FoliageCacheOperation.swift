//
//  FoliageCacheOperation.swift
//
//  Created by Zack Brown on 15/10/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation

public class FoliageCacheOperation: ConcurrentOperation,
                                   ProducesResult {
    
    public var output: Result<FoliageCache, Error> = Result { throw ResultError.noResult }

    public override func execute() {
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: name ?? String(describing: self),
                                  attributes: .concurrent)
        
        var errors: [Error] = []
        var meshes: [FoliageType : Mesh] = [:]
        
        for foliageType in FoliageType.allCases {
            
            let operation = FoliageMeshOperation(foliageType: foliageType)
            
            group.enter()
                                
            operation.enqueue(on: internalQueue) { result in
                
                queue.async(flags: .barrier) {
                    
                    switch result {
                        
                    case .success(let mesh): meshes[foliageType] = mesh
                    case .failure(let error): errors.append(error)
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        self.output = errors.isEmpty ? .success(.init(meshes: meshes)) : .failure(MeshError.errors(errors))

        finish()
    }
}
