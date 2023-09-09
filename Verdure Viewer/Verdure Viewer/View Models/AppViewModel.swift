//
//  AppViewModel.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

class AppViewModel: ObservableObject {
    
    enum Constant {
        
        static let cameraY = 1.5
        static let cameraZ = 1.5
    }
    
    @Published var foliageType: FoliageType = .bamboo {
        
        didSet {
            
            guard oldValue != foliageType else { return }
            
            updateScene()
        }
    }

    @Published var area: Grid.Footprint.Area = .rhombus {
        
        didSet {
            
            guard oldValue != area else { return }
            
            updateScene()
        }
    }
    
    let scene = Scene()
    
    private var footprint: Grid.Footprint { .init(origin: .zero,
                                                  area: area) }
    
    init() {
        
        updateScene()
    }
}

extension AppViewModel {
    
    private func createNode(with mesh: Mesh?) -> SCNNode? {
        
        guard let mesh else { return nil }
        
        let node = SCNNode()
        let wireframe = SCNNode()
        let material = SCNMaterial()
        
        node.geometry = SCNGeometry(mesh)
        node.geometry?.firstMaterial = material
        
        wireframe.geometry = SCNGeometry(wireframe: mesh)
        
        node.addChildNode(wireframe)
        
        return node
    }
    
    private func updateScene() {
        
        scene.clear()
        
        updateSurface()
        
        let size = 0.2
        
        let box = SCNBox(width: size,
                         height: size,
                         length: size,
                         chamferRadius: 0)
        
        guard let node = createNode(with: Mesh(box)) else { return }
        
        let position = footprint.center
        
        scene.camera.position = SCNVector3(position)
        
        node.position = SCNVector3(position.x, position.y + (size / 2.0), position.z)
        node.geometry?.firstMaterial?.diffuse.contents = NSColor.systemPink
        
        scene.rootNode.addChildNode(node)
    }
    
    private func updateSurface() {
        
        var polygons: [Euclid.Polygon] = []
        
        for coordinate in footprint.coordinates {
            
            let triangle = Grid.Triangle(coordinate)
            
            let vertices = triangle.vertices(for: .tile).map { Vertex($0, .up) }
            
            guard let polygon = Polygon(vertices) else { continue }
            
            polygons.append(polygon)
        }
        
        let mesh = Mesh(polygons)
        
        guard let node = createNode(with: mesh) else { return }
        
        scene.rootNode.addChildNode(node)
    }
}
