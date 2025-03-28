//
//  WindParticleManager.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/28/25.
//

import SceneKit

class WindParticleManager {
    // MARK: - Properties
    private var windEmitterNode: SCNNode?
    private var windParticleSystem: SCNParticleSystem?
    
    // MARK: - Initialization
    init(scene: SCNScene) {
        setupWindParticleSystem(in: scene)
    }
    
    // MARK: - Setup
    private func setupWindParticleSystem(in scene: SCNScene) {
        // Create emitter node
        let emitterNode = SCNNode()
        // Position the emitter further left and slightly higher than the spheres
        emitterNode.position = SCNVector3(x: -8, y: 3, z: 0)
        
        // Load wind scene
        if let windScene = SCNScene(named: "WindParticles.scn") {
            print("Successfully loaded scene")
            
            if let particleNode = windScene.rootNode.childNode(withName: "WindParticles", recursively: true) {
                print("Found particle node")
                
                if let particleSystem = particleNode.particleSystems?.first {
                    print("Found particle system")
                    
                    // Configure emission direction to flow right (positive X)
                    emitterNode.eulerAngles = SCNVector3(0, 0, 0)  // Reset any rotation
                    
                    // Add particle system to emitter
                    emitterNode.addParticleSystem(particleSystem)
                    
                    // Add emitter to scene
                    scene.rootNode.addChildNode(emitterNode)
                    
                    // Store references
                    windParticleSystem = particleSystem
                    windEmitterNode = emitterNode
                    
                    // Initialize with no particles
                    particleSystem.birthRate = 0
                    
                    // Print debug information
                    print("Wind particle system initialized at position: \(emitterNode.position)")
                } else {
                    print("No particle system found in node")
                }
            } else {
                print("No node named 'WindParticles' found in scene")
            }
        } else {
            print("Failed to load scene file")
            
            // Print available resources for debugging
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let items = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    print("Available resources:")
                    items.forEach { print($0) }
                } catch {
                    print("Error listing resources: \(error)")
                }
            }
        }
    }
    
    // MARK: - Control Methods
    func startWindParticles() {
        windParticleSystem?.birthRate = 500
    }
    
    func stopWindParticles() {
        windParticleSystem?.birthRate = 0
    }
    
    func cleanup() {
        windEmitterNode?.removeFromParentNode()
        windEmitterNode = nil
        windParticleSystem = nil
    }
} 
