//
//  Simulation.swift
//  PhysicsSimulations
//
//  Created by Kelvin Reid on 3/13/25.
//

import SceneKit
import SwiftUI

// Protocol defining the requirements for a simulation
protocol Simulation {
    // The SceneKit scene that the simulation operates within
    var scene: SCNScene { get }
    // Function to set up the initial scene elements
    func setupScene()
    // Function to update the simulation based on time
    func update(time: TimeInterval)
    // Function to handle tap events at a specific point
    func handleTap(at point: CGPoint)
}

// Base class providing common simulation functionality
class BaseSimulation: Simulation {
    // The SceneKit scene instance
    let scene: SCNScene = SCNScene()

    // Initializer to set up the scene when the simulation is created
    init() {
        setupScene()
    }

    // Function to set up the scene with default camera and lighting
    func setupScene() {
        // Create and configure the camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 60) // Position the camera away from the origin
        scene.rootNode.addChildNode(cameraNode) // Add the camera to the scene

        // Create and configure the omni light node
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni // Omni light illuminates all directions
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10) // Position the light above and slightly to the side
        scene.rootNode.addChildNode(lightNode) // Add the light to the scene

        // Create and configure the ambient light node
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient // Ambient light provides uniform illumination
        ambientLightNode.light?.color = UIColor.darkGray // Set the ambient light color
        scene.rootNode.addChildNode(ambientLightNode) // Add the ambient light to the scene
    }

    // Default update function (can be overridden in subclasses)
    func update(time: TimeInterval) {
        // By default, no update logic is performed
    }

    // Default tap handler (can be overridden in subclasses)
    func handleTap(at point: CGPoint) {
        // By default, no tap handling is performed
    }
}
