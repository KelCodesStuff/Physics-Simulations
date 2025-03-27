//
//  FluidSceneManager.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import SceneKit

class FluidSceneManager: NSObject {
    // MARK: - Properties
    
    /// The SceneKit view that displays our 3D scene
    let sceneView: SCNView
    
    /// The 3D scene containing all our objects
    let scene: SCNScene
    
    /// Array to store fluid particles
    private var fluidParticles: [SCNNode] = []
    
    /// Number of fluid particles
    private let particleCount = 200
    
    // MARK: - Physics Categories
    private let containerCategory: Int = 1
    private let particleCategory: Int = 2
    
    // MARK: - Initialization
    
    init(frame: CGRect) {
        // Create and configure the scene view
        sceneView = SCNView(frame: frame)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Initialize the 3D scene
        scene = SCNScene()
        sceneView.scene = scene
        
        super.init()
        
        setupScene()
    }
    
    // MARK: - Scene Setup
    
    private func setupScene() {
        // Setup scene view
        sceneView.backgroundColor = .darkGray
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = .multisampling4X
        
        // Setup camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 4, 12)
        cameraNode.eulerAngles = SCNVector3(-Float.pi/6, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 300
        ambientLight.light?.color = UIColor(white: 0.5, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 800
        directionalLight.position = SCNVector3(5, 5, 5)
        directionalLight.light?.castsShadow = true
        directionalLight.light?.shadowMode = .deferred
        directionalLight.light?.shadowColor = UIColor.black.withAlphaComponent(0.3)
        scene.rootNode.addChildNode(directionalLight)
        
        // Add point light for better particle illumination
        let pointLight = SCNNode()
        pointLight.light = SCNLight()
        pointLight.light?.type = .omni
        pointLight.light?.intensity = 500
        pointLight.position = SCNVector3(0, 5, 0)
        pointLight.light?.color = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        scene.rootNode.addChildNode(pointLight)
        
        // Create container for the fluid
        let containerWidth: CGFloat = 5
        let containerHeight: CGFloat = 3
        let containerLength: CGFloat = 2
        let wallThickness: CGFloat = 0.1
        
        // Create container walls
        let walls = createContainerWalls(width: containerWidth, height: containerHeight, length: containerLength, thickness: wallThickness)
        for wall in walls {
            wall.position.y += Float(containerHeight)/2 - 3.5 // Move container even lower
            scene.rootNode.addChildNode(wall)
        }
        
        // Configure physics world
        scene.physicsWorld.gravity = SCNVector3(0, -9.8, 0)
        scene.physicsWorld.contactDelegate = self
        
        // Add fluid particles
        addFluidParticles()
    }
    
    private func createContainerWalls(width: CGFloat, height: CGFloat, length: CGFloat, thickness: CGFloat) -> [SCNNode] {
        var walls: [SCNNode] = []
        
        // Create a glass-like material for the container
        let glassMaterial = SCNMaterial()
        glassMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.1)
        glassMaterial.specular.contents = UIColor.white.withAlphaComponent(0.5)
        glassMaterial.transparency = 0.9
        glassMaterial.lightingModel = .physicallyBased
        glassMaterial.metalness.contents = 0.0
        glassMaterial.roughness.contents = 0.0
        
        // Bottom wall
        let bottomWall = SCNNode(geometry: SCNBox(width: width, height: thickness, length: length, chamferRadius: 0))
        bottomWall.position = SCNVector3(0, -height, 0)
        bottomWall.geometry?.materials = [glassMaterial]
        let bottomBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: bottomWall.geometry!, options: nil))
        bottomBody.categoryBitMask = containerCategory
        bottomBody.collisionBitMask = particleCategory
        bottomBody.contactTestBitMask = particleCategory
        bottomWall.physicsBody = bottomBody
        
        // Back wall
        let backWall = SCNNode(geometry: SCNBox(width: width, height: height, length: thickness, chamferRadius: 0))
        backWall.position = SCNVector3(0, -height/2, -length/2)
        backWall.geometry?.materials = [glassMaterial]
        let backBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: backWall.geometry!, options: nil))
        backBody.categoryBitMask = containerCategory
        backBody.collisionBitMask = particleCategory
        backBody.contactTestBitMask = particleCategory
        backWall.physicsBody = backBody
        
        // Front wall
        let frontWall = SCNNode(geometry: SCNBox(width: width, height: height, length: thickness, chamferRadius: 0))
        frontWall.position = SCNVector3(0, -height/2, length/2)
        frontWall.geometry?.materials = [glassMaterial]
        let frontBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: frontWall.geometry!, options: nil))
        frontBody.categoryBitMask = containerCategory
        frontBody.collisionBitMask = particleCategory
        frontBody.contactTestBitMask = particleCategory
        frontWall.physicsBody = frontBody
        
        // Left wall
        let leftWall = SCNNode(geometry: SCNBox(width: thickness, height: height, length: length, chamferRadius: 0))
        leftWall.position = SCNVector3(-width/2, -height/2, 0)
        leftWall.geometry?.materials = [glassMaterial]
        let leftBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: leftWall.geometry!, options: nil))
        leftBody.categoryBitMask = containerCategory
        leftBody.collisionBitMask = particleCategory
        leftBody.contactTestBitMask = particleCategory
        leftWall.physicsBody = leftBody
        
        // Right wall
        let rightWall = SCNNode(geometry: SCNBox(width: thickness, height: height, length: length, chamferRadius: 0))
        rightWall.position = SCNVector3(width/2, -height/2, 0)
        rightWall.geometry?.materials = [glassMaterial]
        let rightBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: rightWall.geometry!, options: nil))
        rightBody.categoryBitMask = containerCategory
        rightBody.collisionBitMask = particleCategory
        rightBody.contactTestBitMask = particleCategory
        rightWall.physicsBody = rightBody
        
        // Configure physics properties for all walls
        for wall in [bottomWall, backWall, frontWall, leftWall, rightWall] {
            wall.physicsBody?.isAffectedByGravity = false
            wall.physicsBody?.friction = 0.5      // Moderate friction
            wall.physicsBody?.restitution = 0.0   // No bounce
            wall.physicsBody?.damping = 0.3       // Light damping
        }
        
        walls = [bottomWall, backWall, frontWall, leftWall, rightWall]
        return walls
    }
    
    // MARK: - Fluid Management
    
    private func addFluidParticles() {
        let particleRadius: CGFloat = 0.1
        let spacing: CGFloat = 0.2
        
        // Create a more appealing material for the particles
        let particleMaterial = SCNMaterial()
        particleMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 0.8)
        particleMaterial.specular.contents = UIColor.white
        particleMaterial.emission.contents = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 0.3)
        particleMaterial.lightingModel = .physicallyBased
        particleMaterial.metalness.contents = 0.0
        particleMaterial.roughness.contents = 0.1
        
        for i in 0..<particleCount {
            let geometry = SCNSphere(radius: particleRadius)
            geometry.materials = [particleMaterial]
            
            let node = SCNNode(geometry: geometry)
            
            // Calculate position in a grid
            let row = i / 10
            let col = i % 10
            let x = Float(col) * Float(spacing) - 1.0
            let y = Float(row) * Float(spacing) + 4.0
            node.position = SCNVector3(x, y, 0)
            
            // Add physics body with more realistic water-like properties
            let shape = SCNPhysicsShape(geometry: geometry, options: [SCNPhysicsShape.Option.collisionMargin: 0.001])
            let body = SCNPhysicsBody(type: .dynamic, shape: shape)
            body.mass = 0.1                     // Slightly heavier to help with falling
            body.restitution = 0.0             // No bounce
            body.friction = 0.3                 // Lower friction to allow movement
            body.damping = 0.3                 // Lower damping to allow movement
            body.angularDamping = 0.7          // Moderate angular damping
            body.velocityFactor = SCNVector3(1, 0.7, 1)  // Allow more vertical movement
            body.angularVelocityFactor = SCNVector3(0.2, 0.2, 0.2)  // Some rotation allowed
            body.allowsResting = true
            body.isAffectedByGravity = true
            body.categoryBitMask = particleCategory
            body.collisionBitMask = containerCategory | particleCategory
            body.contactTestBitMask = containerCategory | particleCategory
            node.physicsBody = body
            
            scene.rootNode.addChildNode(node)
            fluidParticles.append(node)
        }
    }
    
    func restartSimulation() {
        // Remove existing particles
        for particle in fluidParticles {
            particle.removeFromParentNode()
        }
        fluidParticles.removeAll()
        
        // Add new particles
        addFluidParticles()
    }
}

// MARK: - SCNPhysicsContactDelegate
extension FluidSceneManager: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Handle particle collisions if needed
    }
} 
