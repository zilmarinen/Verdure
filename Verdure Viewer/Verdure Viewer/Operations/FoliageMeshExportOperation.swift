//
//  FoliageMeshExportOperation.swift
//
//  Created by Zack Brown on 11/07/2024.
//

import Dependencies
import Foundation
import PeakOperation
import Verdure

final class FoliageMeshExportOperation: ConcurrentOperation {
    
    @Dependency(\.foliageCache) var foliageCache
        
    private let url: URL
    
    public init(url: URL) {
        
        self.url = url
    }
    
    override func execute() {
        
        do {
            
            var files: [String : FileWrapper] = [:]
            
            for asset in foliageCache.assets {
                
                let data = try asset.value.encode()
                
                files["\(asset.key).json"] = FileWrapper(regularFileWithContents: data)
            }
            
            let wrapper = FileWrapper(directoryWithFileWrappers: files)
            
            try wrapper.write(to: url,
                              options: .atomic,
                              originalContentsURL: nil)
        }
        catch{ fatalError(error.localizedDescription) }
        
        finish()
    }
}
