//
//  AppViewModel.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Deltille
import Euclid
import Foundation
import Lattice
import SceneKit
import SwiftUI

internal class AppViewModel: ObservableObject {
    
    @Published internal var septomino: Triangle.Septomino = .antlia {
        
        didSet {
            
            guard oldValue != septomino else { return }
            
            updateScene()
        }
    }
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    
    internal let canopyPrimaryColor: NSColor = .canopyPrimary
    internal let canopySecondaryColor: NSColor = .canopySecondary
    internal let trunkColor: NSColor = .trunk
    
    internal let model = SCNNode()
    internal let wireframe = SCNNode()
    internal let surface = SCNNode()
    
    internal init() {
        
        updateScene()
        
        scene.rootNode.addChildNode(model)
        scene.rootNode.addChildNode(surface)
        
        model.addChildNode(wireframe)
    }
}

extension AppViewModel {
    
    private func updateScene() {
        
        updateFoliage()
        
        updateSurface()
    }
    
    private func updateFoliage() {
        
        let mesh = septomino.foliage(.init(canopyPrimaryColor),
                                     .init(canopySecondaryColor),
                                     .init(trunkColor))
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh([])
        
        for tile in Triangle.zero.perimeter {
            
            let color: NSColor = tile.isPointy ? gridColor : gridAlternateColor
            
            mesh = mesh.merge(tile.mesh(.tile,
                                        .init(color)))
        }
        
        surface.geometry = .init(mesh)
    }
}
