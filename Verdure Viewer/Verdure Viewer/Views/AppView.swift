//
//  AppView.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Deltille
import Lattice
import SceneKit
import SwiftUI
import Verdure

struct AppView: View {
    
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
        }
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  options: [.allowsCameraControl])
        .toolbar {
            
            ToolbarItemGroup {
                
                toolbar
            }
        }
        .navigationTitle("Verdure")
    }
    
    @ViewBuilder
    var toolbar: some View {
        
        Picker("Septomino",
               selection: $viewModel.septomino) {
            
            ForEach(Triangle.Septomino.allCases, id: \.self) { septomino in
                
                Text(septomino.id)
                    .id(septomino)
            }
        }
    }
}
