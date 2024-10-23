//
//  AppViewModel.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Deltille
import Dependencies
import Euclid
import Foundation
import SceneKit
import Verdure

class AppViewModel: ObservableObject {
    
    @Dependency(\.foliageCache) var foliageCache
    
    @Published var foliageType: FoliageType = .linden {
        
        didSet {
            
            guard oldValue != foliageType else { return }
            
            updateScene()
        }
    }
    
    @Published var profile: Mesh.Profile = .init(polygonCount: 0,
                                                 vertexCount: 0)
    
    let scene = ModelViewScene()
    
    private let operationQueue = OperationQueue()
    
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
                
            case .success(let meshes): foliageCache.merge(meshes)
            case .failure(let error): fatalError(error.localizedDescription)
            }
            
            self.updateScene()
        }
    }
    
    private func updateScene() {
        
        self.scene.clear()
        
        scene.render(surface: foliageType.footprint.coordinates)
                
        guard let mesh = foliageCache.mesh(for: foliageType) else { return }
        
        let geometry = SCNGeometry(mesh)
                
        geometry.program = Program(function: .geometry)
        
        scene.model.geometry = geometry
        
        self.updateProfile(for: mesh)
    }
    
    private func updateProfile(for mesh: Mesh) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.profile = mesh.profile
        }
    }
}

extension AppViewModel {
 
    func presentExportModal() {
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.isExtensionHidden = true
        panel.showsHiddenFiles = false
        panel.showsTagField = false
        
        panel.begin { [weak self] response in
            
            switch response {
                
            case .OK:
                
                guard let self,
                      let url = panel.urls.first else { return }
                
                let operation = AssetCacheExportOperation(foliageCache,
                                                          url)
                
                operation.enqueue(on: self.operationQueue)
                
            default: break
            }
        }
    }
}
