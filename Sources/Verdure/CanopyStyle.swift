//
//  CanopyStyle.swift
//
//  Created by Zack Brown on 14/10/2025.
//

public enum CanopyStyle: String,
                         CaseIterable,
                         Hashable,
                         Identifiable,
                         Sendable {
    
    case columnar
    case conical
    case irregular
    case spreading
    case terraced
    
    public var id: String { rawValue.capitalized }
}
