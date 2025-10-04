//
//  Septomino.swift
//
//  Created by Zack Brown on 27/07/2024.
//

import Deltille
import Euclid
import Lattice

extension Triangle.Septomino {
    
    public func foliage(_ canopyPrimaryColor: Color,
                        _ canopySecondaryColor: Color,
                        _ trunkColor: Color) -> Mesh {
        
        let furthest = furthest
        let scale = Triangle.Scale.tile
        let trunkHeight = scale.edgeLength
        
        let trunk = trunk(trunkColor,
                          trunkHeight)
        let canopy = canopy(canopyPrimaryColor,
                            canopySecondaryColor,
                            .init(0.0, trunkHeight, 0.0),
                            furthest)
        
        return trunk.union(canopy)
    }
}

extension Triangle.Septomino {
    
    typealias Furthest = (triangle: Int,
                          vertex: Int)
    
    private var furthest: Furthest {
        
        var furthestTriangle = 0
        var furthestVertex = 0
        
        for coordinate in coordinates {
            
            let triangle = Triangle(coordinate)
            
            let distance = triangle.distance(.zero)
            
            if distance > furthestTriangle {
                
                furthestTriangle = distance
            }
            
            for vertex in triangle.vertices {
                
                let distance = vertex.distance(.zero)
                
                if distance > furthestVertex {
                    
                    furthestVertex = distance
                }
            }
        }
        
        return (furthestTriangle,
                furthestVertex)
    }
    
    private func canopy(_ primaryColor: Color,
                        _ secondaryColor: Color,
                        _ origin: Vector,
                        _ furthest: Furthest) -> Mesh {
        
        var mesh = Mesh.empty
        
        for coordinate in coordinates {
            
            let triangle = Triangle(coordinate)
            
            let leaf = leaf(triangle,
                            primaryColor,
                            secondaryColor,
                            0.25,
                            furthest)
            
            mesh = mesh.union(leaf.translated(by: origin))
        }
        
        return mesh
    }
    
    private func leaf(_ triangle: Triangle,
                      _ primaryColor: Color,
                      _ secondaryColor: Color,
                      _ height: Double,
                      _ furthest: Furthest) -> Mesh {
        
        let step = 1.0 / Double(furthest.vertex)
        
        let colors = triangle.vertices.map {
            
            let distance = $0.distance(.zero)
            
            return primaryColor.lerp(secondaryColor,
                                     step * Double(distance))
        }
        
        let volume = Volume(vertices: triangle.vertices.position(.sierpinski),
                            displacement: height)
        
        return volume.mesh(colors)
    }
    
    private func trunk(_ color: Color,
                       _ height: Double) -> Mesh {
        
        let hexagon = Hexagon.zero
        let stencil = hexagon.stencil(.conway)
        let trunk = Volume(stencil: stencil,
                           vertices: [.v0, .v1, .v2, .v3, .v4, .v5],
                           displacement: height)
        
        return trunk.mesh(color)
    }
}
