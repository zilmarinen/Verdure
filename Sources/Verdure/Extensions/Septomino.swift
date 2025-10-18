//
//  Septomino.swift
//
//  Created by Zack Brown on 27/07/2024.
//

import Alluvium
import Deltille
import Euclid
import Lattice

extension Triangle.Septomino {
    
    private func canopy(_ colorPalette: ColorPalette,
                        _ height: Double) -> Mesh {
        
        let tiles = coordinates.map { Triangle($0) }
        
        let footprint = Footprint(.zero,
                                  tiles)
        
        guard let edgeLoop = try? footprint.edgeLoop else { return .empty }
        
        let points = edgeLoop.tiles.map { PathPoint($0.position(.sierpinski),
                                                    texcoord: nil,
                                                    color: colorPalette.primary,
                                                    isCurved: false) }
        
        guard let first = points.first else { return .empty }
        
        let path = Path(points + [first])
        let lowerPath = path.inset(by: 0.05)
        let middlePath = path.translated(by: .init(0.0, height / 4.0, 0.0))
        let upperPath = path.inset(by: 0.1).translated(by: .init(0.0, height, 0.0))
        
        //return Mesh.fill(path)
        return Mesh.loft([lowerPath,
                          middlePath,
                          upperPath])
        
//        let volume = Volume(vertices: edgeLoop.map { $0.position(.sierpinski) },
//                            displacement: height)
//        
//        return volume.mesh(primaryColor)
    }
}
