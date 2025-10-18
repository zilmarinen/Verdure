//
//  Mesh.swift
//
//  Created by Zack Brown on 14/10/2025.
//

import Alluvium
import Deltille
import Euclid
import Lattice

extension Mesh {
    
    internal enum Constant {
        
        static let height = Triangle.Scale.tile.edgeLength
        
        static let trunkHeight = height * 0.33
        static let canopyHeight = height * 0.75
    }
    
    public static func foliage(_ septomino: Triangle.Septomino,
                               _ style: CanopyStyle,
                               _ canopyColorPalette: ColorPalette,
                               _ trunkColorPalette: ColorPalette) -> Self {
        
        let canopyOffset = Vector(0.0, Constant.height - Constant.canopyHeight, 0.0)
        
        do {
            
            let footprint = Triangle.Footprint(.zero,
                                               septomino.coordinates)
            
            let edgeLoop = try footprint.edgeLoop
            
            let trunk = trunk(septomino,
                              trunkColorPalette,
                              Constant.trunkHeight).translated(by: footprint.center(.sierpinski))
            
            let canopy = canopy(edgeLoop,
                                style,
                                canopyColorPalette,
                                Constant.canopyHeight).translated(by: canopyOffset)
            
            return trunk.union(canopy)
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: Canopy

extension Mesh {
    
    internal static func canopy(_ edgeLoop: Triangle.EdgeLoop,
                                _ style: CanopyStyle,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        switch style {
            
        case .columnar: canopy(columnar: edgeLoop,
                               colorPalette,
                               height)
            
        case .conical: canopy(conical: edgeLoop,
                              colorPalette,
                              height)
            
        case .irregular: canopy(irregular: edgeLoop,
                                colorPalette,
                                height)
            
        case .spreading: canopy(spreading: edgeLoop,
                                colorPalette,
                                height)
            
        case .terraced: canopy(terraced: edgeLoop,
                               colorPalette,
                               height)
        }
    }
    
    internal static func canopy(columnar edgeLoop: Triangle.EdgeLoop,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        let scale = Triangle.Scale.sierpinski
        let radiusStep = 0.1 / 5.0
        let heightStep = 1.0 / 10.0
        let primary = colorPalette.primary
        let secondary = colorPalette.secondary
        
        let p0 = edgeLoop.path(scale,
                               height * heightStep,
                               radiusStep,
                               secondary.lerp(primary, heightStep))
        
        let p1 = edgeLoop.path(scale,
                               height * (heightStep * 5.0),
                               nil,
                               secondary.lerp(primary, heightStep * 5.0))
        
        let p2 = edgeLoop.path(scale,
                               height,
                               radiusStep * 3.0,
                               primary)
        
        return Mesh.loft([p0, p1, p2])
    }
    
    internal static func canopy(conical edgeLoop: Triangle.EdgeLoop,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        let scale = Triangle.Scale.sierpinski
        let radiusStep = 0.1 / 5.0
        let heightStep = 1.0 / 10.0
        let primary = colorPalette.primary
        let secondary = colorPalette.secondary
        
        let p0 = edgeLoop.path(scale,
                               height * heightStep,
                               radiusStep,
                               secondary.lerp(primary, heightStep))
        
        let p1 = edgeLoop.path(scale,
                               height * (heightStep * 2.0),
                               nil,
                               secondary.lerp(primary, heightStep * 2.0))
        
        let p2 = edgeLoop.path(scale,
                               height * (heightStep * 8.0),
                               radiusStep * 2.0,
                               secondary.lerp(primary, heightStep * 8.0))
        
        let p3 = edgeLoop.path(scale,
                               height,
                               radiusStep * 4.0,
                               primary)
        
        return Mesh.loft([p0, p1, p2, p3])
    }
    
    internal static func canopy(irregular edgeLoop: Triangle.EdgeLoop,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        let scale = Triangle.Scale.sierpinski
        let radiusStep = 0.1 / 5.0
        let heightStep = 1.0 / 10.0
        let primary = colorPalette.primary
        let secondary = colorPalette.secondary
        
        let p0 = edgeLoop.path(scale,
                               height * heightStep,
                               radiusStep * 3.0,
                               secondary.lerp(primary, heightStep))
        
        let p1 = edgeLoop.path(scale,
                               height * (heightStep * 3.0),
                               radiusStep,
                               secondary.lerp(primary, heightStep * 3.0))
        
        let p2 = edgeLoop.path(scale,
                               height,
                               radiusStep * 4.0,
                               primary)
        
        let p3 = edgeLoop.path(scale,
                               height * (heightStep * 2.0),
                               radiusStep,
                               secondary.lerp(primary, (heightStep * 2.0)))
        
        let p4 = edgeLoop.path(scale,
                               height * (heightStep * 4.0),
                               nil,
                               secondary.lerp(primary, heightStep * 4.0))
        
        let p5 = edgeLoop.path(scale,
                               height * (heightStep * 8.0),
                               radiusStep * 2.0,
                               secondary.lerp(primary, heightStep * 8.0))
        
        let lhs = Mesh.loft([p0, p1, p2])
        let rhs = Mesh.loft([p3, p4, p5])
        
        return lhs.union(rhs)
    }
    
    internal static func canopy(spreading edgeLoop: Triangle.EdgeLoop,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        let scale = Triangle.Scale.sierpinski
        let radiusStep = 0.1 / 5.0
        let heightStep = 1.0 / 10.0
        let primary = colorPalette.primary
        let secondary = colorPalette.secondary
        
        let p0 = edgeLoop.path(scale,
                               height * heightStep,
                               radiusStep * 2.0,
                               secondary.lerp(primary, heightStep))
        
        let p1 = edgeLoop.path(scale,
                               height * (heightStep * 2.0),
                               radiusStep,
                               secondary.lerp(primary, heightStep * 2.0))
        
        let p2 = edgeLoop.path(scale,
                               height * (heightStep * 8.0),
                               radiusStep * 3.0,
                               secondary.lerp(primary, heightStep * 8.0))
        
        let p3 = edgeLoop.path(scale,
                               height,
                               radiusStep * 4.0,
                               primary)
        
        let p4 = edgeLoop.path(scale,
                               height * heightStep,
                               radiusStep * 4.0,
                               secondary.lerp(primary, heightStep))
        
        let p5 = edgeLoop.path(scale,
                               height * (heightStep * 2.0),
                               nil,
                               secondary.lerp(primary, heightStep * 2.0))
        
        let p6 = edgeLoop.path(scale,
                               height * (heightStep * 7.0),
                               nil,
                               secondary.lerp(primary, heightStep * 7.0))
        
        let p7 = edgeLoop.path(scale,
                               height * (heightStep * 8.0),
                               radiusStep * 4.0,
                               secondary.lerp(primary, heightStep * 8.0))
        
        let lhs = Mesh.loft([p0, p1, p2, p3])
        let rhs = Mesh.loft([p4, p5, p6, p7])
        
        return lhs.union(rhs)
    }
    
    internal static func canopy(terraced edgeLoop: Triangle.EdgeLoop,
                                _ colorPalette: ColorPalette,
                                _ height: Double) -> Self {
        
        let scale = Triangle.Scale.sierpinski
        let radiusStep = 0.1 / 5.0
        let heightStep = 1.0 / 10.0
        let primary = colorPalette.primary
        let secondary = colorPalette.secondary
        
        let p0 = edgeLoop.path(scale,
                               0.0,
                               radiusStep * 1.0,
                               secondary.lerp(primary, heightStep))
        
        let p1 = edgeLoop.path(scale,
                               height * heightStep,
                               nil,
                               secondary.lerp(primary, heightStep))
        
        let p2 = edgeLoop.path(scale,
                               height * (heightStep * 4.0),
                               radiusStep * 4.0,
                               secondary.lerp(primary, (heightStep * 4.0)))
        
        let p3 = edgeLoop.path(scale,
                               height * (heightStep * 3.0),
                               radiusStep * 2.0,
                               secondary.lerp(primary, (heightStep * 3.0)))
        
        let p4 = edgeLoop.path(scale,
                               height * (heightStep * 4.0),
                               radiusStep,
                               secondary.lerp(primary, (heightStep * 4.0)))
        
        let p5 = edgeLoop.path(scale,
                               height * (heightStep * 7.0),
                               radiusStep * 3.0,
                               secondary.lerp(primary, (heightStep * 7.0)))
        
        let p6 = edgeLoop.path(scale,
                               height * (heightStep * 6.0),
                               radiusStep * 3.0,
                               secondary.lerp(primary, (heightStep * 6.0)))
        
        let p7 = edgeLoop.path(scale,
                               height * (heightStep * 7.0),
                               radiusStep * 2.0,
                               secondary.lerp(primary, heightStep * 7.0))
        
        let p8 = edgeLoop.path(scale,
                               height,
                               radiusStep * 4.0,
                               primary)
        
        let lhs = Mesh.loft([p0, p1, p2])
        let mhs = Mesh.loft([p3, p4, p5])
        let rhs = Mesh.loft([p6, p7, p8])
        
        return lhs.union(mhs.union(rhs))
    }
}

// MARK: Trunk

extension Mesh {
    
    internal static func trunk(_ septomino: Triangle.Septomino,
                               _ colorPalette: ColorPalette,
                               _ height: Double) -> Self {
        
        let tile = Hexagon.zero
        let footprint = Hexagon.Footprint(tile,
                                           [tile])
        let peak = Vector(0.0, height, 0.0)
        
        guard let edgeLoop = try? footprint.edgeLoop else { return .empty }
        
        let base = edgeLoop.path(.conway,
                                 colorPalette.secondary)
        
        let apex = edgeLoop.path(.conway,
                                 colorPalette.primary).inset(by: 0.05).translated(by: peak)
        
        return Mesh.loft([base,
                          apex])
    }
}
