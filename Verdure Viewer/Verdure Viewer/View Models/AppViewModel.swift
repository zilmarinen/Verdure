//
//  AppViewModel.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Deltille
import Euclid
import Foundation
import SceneKit
import Verdure

class AppViewModel: ObservableObject {
    
    @Published var foliageType: FoliageType = .cherryBlossom {
        
        didSet {
            
            guard oldValue != foliageType else { return }
            
            updateScene()
        }
    }
    
    @Published var profile: Mesh.Profile = .init(polygonCount: 0,
                                                 vertexCount: 0)
    
    let scene = Scene()
    
    private let operationQueue = OperationQueue()
    
    private var cache: FoliageCache?
    
    init() {
        
        generateCache()
    }
}

extension AppViewModel {
    
    private func generateCache() {
            
        let operation = FoliageCacheOperation()
        
        operation.enqueue(on: operationQueue) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            case .success(let cache): self.cache = cache
            case .failure(let error): fatalError(error.localizedDescription)
            }
            
            self.updateScene()
        }
    }
    
    private func createNode(with mesh: Mesh?) -> SCNNode? {
        
        guard let mesh else { return nil }
        
        let node = SCNNode()
        
        node.geometry = SCNGeometry(mesh)
        
        return node
    }
    
    private func updateScene() {
        
        self.scene.clear()
                
        self.updateSurface()
        
        guard let cache,
              let mesh = cache.mesh(for: foliageType),
              let node = self.createNode(with: mesh) else { return }
        
        self.scene.rootNode.addChildNode(node)
        
        node.geometry?.program = Program(function: .geometry)
        
        self.updateProfile(for: mesh)
    }
    
    private func updateSurface() {
        
        var polygons: [Euclid.Polygon] = []
        
        for coordinate in foliageType.area.coordinates {
            
            let triangle = Grid.Triangle(coordinate)
            
            let vertices = triangle.corners(for: .tile).map { Vertex($0,
                                                                     .up,
                                                                     nil,
                                                                     .gray) }
            
            guard let polygon = Polygon(vertices) else { continue }
            
            polygons.append(polygon)
        }
        
        let mesh = Mesh(polygons)
        
        guard let node = createNode(with: mesh) else { return }
        
        node.geometry?.program = Program(function: .geometry)
        
        scene.rootNode.addChildNode(node)
    }
    
    private func updateProfile(for mesh: Mesh) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.profile = mesh.profile
        }
    }
}
