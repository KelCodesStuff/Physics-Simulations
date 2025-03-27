//
//  SceneManager.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import SceneKit

class SceneManager: NSObject {
    // MARK: - Properties
    
    /// The SceneKit view that displays our 3D scene
    let sceneView: SCNView
    
    /// The 3D scene containing all our objects
    let scene: SCNScene
    
    /// The force vector applied when wind is enabled (2 units in positive X direction)
    private var windForce: SCNVector3 = SCNVector3(x: 2, y: 0, z: 0)
    
    /// Tracks whether wind force is currently being applied
    private(set) var isWindEnabled = false
    
    // MARK: - Initialization
    
    override init() {
        // Create and configure the scene view
        sceneView = SCNView(frame: .zero)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Initialize the 3D scene
        scene = SCNScene()
        sceneView.scene = scene
        
        super.init()
        
        setupScene()
    }
    
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
        // Set up the camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        cameraNode.eulerAngles = SCNVector3(x: -Float.pi/6, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // Add ambient light for overall scene illumination
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light for shadows and depth
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.position = SCNVector3(x: 5, y: 5, z: 5)
        scene.rootNode.addChildNode(directionalLight)
        
        // Create and configure the ground plane
        let groundGeometry = SCNFloor()
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.gray
        groundGeometry.materials = [groundMaterial]
        
        let groundNode = SCNNode(geometry: groundGeometry)
        groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        scene.rootNode.addChildNode(groundNode)
        
        // Configure physics world with gravity
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -9.8, z: 0)
        
        // Enable default lighting for better visual quality
        sceneView.autoenablesDefaultLighting = true
        
        // Show physics shapes for debugging
        sceneView.debugOptions = [.showPhysicsShapes]
        
        // Start the physics simulation
        sceneView.isPlaying = true
        
        // Set up collision detection
        scene.physicsWorld.contactDelegate = self
        
        // Add initial objects
        addObjects()
    }
    
    // MARK: - Object Management
    
    func addObjects() {
        // Remove all existing dynamic objects
        scene.rootNode.childNodes.forEach { node in
            if node.physicsBody?.type == .dynamic {
                node.removeFromParentNode()
            }
        }
        
        // Add three spheres with different properties
        // Red sphere: Light (1.0), high bounce (0.9)
        addObject(at: SCNVector3(x: -2, y: 5, z: 0), color: .red, mass: 1.0, restitution: 0.9)
        // Blue sphere: Medium (2.0), medium bounce (0.7)
        addObject(at: SCNVector3(x: 0, y: 5, z: 0), color: .blue, mass: 2.0, restitution: 0.7)
        // Green sphere: Heavy (3.0), less bounce (0.5)
        addObject(at: SCNVector3(x: 2, y: 5, z: 0), color: .green, mass: 5.0, restitution: 0.3)
    }
    
    private func addObject(at position: SCNVector3, color: UIColor, mass: CGFloat, restitution: CGFloat) {
        // Create the sphere geometry
        let geometry = SCNSphere(radius: 0.5)
        let material = SCNMaterial()
        material.diffuse.contents = color
        geometry.materials = [material]
        
        // Create and position the sphere node
        let node = SCNNode(geometry: geometry)
        node.position = position
        
        // Configure the physics body
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.mass = mass
        physicsBody.restitution = restitution
        physicsBody.friction = 0.5
        physicsBody.angularVelocityFactor = SCNVector3(x: 1, y: 1, z: 1)
        node.physicsBody = physicsBody
        
        // Create and configure the mass label
        let labelNode = SCNNode()
        let textGeometry = SCNText(string: "Mass: \(mass)", extrusionDepth: 0.05)
        textGeometry.font = UIFont.systemFont(ofSize: 0.2)
        
        labelNode.geometry = textGeometry
        labelNode.position = SCNVector3(x: -0.3, y: 0.6, z: 0)
        labelNode.eulerAngles = SCNVector3(x: 0, y: Float.pi, z: 0)
        
        // Make the label always face the camera
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = .Y
        labelNode.constraints = [billboardConstraint]
        
        // Add the label as a child of the sphere
        node.addChildNode(labelNode)
        scene.rootNode.addChildNode(node)
    }
    
    // MARK: - Wind Control
    
    func toggleWind() {
        isWindEnabled.toggle()
        
        if isWindEnabled {
            // Apply wind force to all dynamic objects
            scene.rootNode.childNodes.forEach { node in
                if let physicsBody = node.physicsBody, physicsBody.type == .dynamic {
                    physicsBody.applyForce(windForce, asImpulse: false)
                }
            }
        }
    }
}

// MARK: - SCNPhysicsContactDelegate
extension SceneManager: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Log collision information for debugging
        print("Collision detected between \(contact.nodeA.name ?? "unknown") and \(contact.nodeB.name ?? "unknown")")
    }
} 
