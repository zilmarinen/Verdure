//
//  AppView.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import Dependencies
import SceneKit
import SwiftUI
import Verdure

struct AppView: View {
    
    @Dependency(\.deviceManager) var deviceManager
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
            
        #if os(iOS)
            NavigationStack {
        
                viewer
            }
        #else
            viewer
        #endif
    }
    
    var viewer: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            sceneView
            
            Text("Polygons: [\(viewModel.profile.polygonCount)] Vertices: [\(viewModel.profile.vertexCount)]")
                .foregroundColor(.black)
                .padding()
        }
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  pointOfView: viewModel.scene.camera.pov,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting],
                  technique: deviceManager.technique)
        .toolbar {
            
            ToolbarItemGroup {
                
                toolbar
            }
        }
    }
    
    @ViewBuilder
    var toolbar: some View {
        
        Picker("Foliage Type",
               selection: $viewModel.foliageType) {
            
            ForEach(FoliageType.allCases, id: \.self) { foliageType in
                
                Text(foliageType.id)
                    .id(foliageType)
            }
        }
        
        Button {
                    
            viewModel.presentExportModal()
            
        } label: {
            
          Label("Export Meshes",
                systemImage: "square.and.arrow.up")
        }
    }
}
