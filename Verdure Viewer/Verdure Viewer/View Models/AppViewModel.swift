//
//  AppViewModel.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Alluvium
import Deltille
import Euclid
import Foundation
import Lattice
import SceneKit
import SwiftUI
import Verdure

internal class AppViewModel: ObservableObject {
    
    @Published internal var canopyStyle: CanopyStyle {
        
        didSet {
            
            guard oldValue != canopyStyle else { return }
            
            updateScene()
        }
    }
    
    @Published internal var septomino: Triangle.Septomino {
        
        didSet {
            
            guard oldValue != septomino else { return }
            
            updateScene()
        }
    }
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    
    internal lazy var canopyColorPalette = ColorPalette(.init(.canopyPrimary),
                                                        .init(.canopySecondary))
    
    internal lazy var trunkColorPalette = ColorPalette(.init(.trunkPrimary),
                                                       .init(.trunkSecondary))
    
    internal let model = SCNNode()
    internal let wireframe = SCNNode()
    internal let surface = SCNNode()
    
    internal init() {
        
        canopyStyle = .allCases.randomElement() ?? .columnar
        septomino = .allCases.randomElement() ?? .antlia
        
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
        
        let mesh = Mesh.foliage(septomino,
                                canopyStyle,
                                canopyColorPalette,
                                trunkColorPalette).union(.cube(center: .init(0.0, 0.25, 0.0),
                                                               size: .init(0.25, 0.5, 0.25)).translated(by: .unitX * 2.0))
        
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
