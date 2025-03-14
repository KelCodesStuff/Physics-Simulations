//
//  ObjectProperties.swift
//  PhysicsSimulations
//
//  Created by Kelvin Reid on 3/13/25.
//

import SceneKit
import UIKit

// Enum to represent different object types
enum ObjectType: CaseIterable {
    case glass
    case wood
    case metal
}

// Struct to hold object properties
struct ObjectProperties {
    let mass: CGFloat
    let color: UIColor
    let material: SCNMaterial

    static func properties(for type: ObjectType) -> ObjectProperties {
        switch type {
        case .glass:
            return ObjectProperties(
                mass: 0.5,
                color: UIColor.cyan.withAlphaComponent(0.5),
                material: createMaterial(reflectivity: 0.5, roughness: 0.1)
            )
        case .wood:
            return ObjectProperties(
                mass: 1.0,
                color: UIColor.brown,
                material: createMaterial(reflectivity: 0.1, roughness: 0.8)
            )
        case .metal:
            return ObjectProperties(
                mass: 2.0,
                color: UIColor.gray,
                material: createMaterial(reflectivity: 0.8, roughness: 0.2)
            )
        }
    }

    private static func createMaterial(reflectivity: CGFloat, roughness: CGFloat) -> SCNMaterial {
        let material = SCNMaterial()
        material.reflective.contents = reflectivity // Corrected line
        material.roughness.contents = roughness
        return material
    }
}
