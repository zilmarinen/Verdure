//
//  AppView.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Bivouac
import SceneKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
        
        #if os(iOS)
            NavigationStack {
        
                sceneView
            }
        #else
            sceneView
        #endif
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  pointOfView: viewModel.scene.camera.pov,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting])
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
                
                Text(foliageType.id.capitalized)
                    .id(foliageType)
            }
        }
    }
}
