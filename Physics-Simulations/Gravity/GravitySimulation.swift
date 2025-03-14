//
//  GravitySimulation.swift
//  PhysicsSimulations
//
//  Created by Kelvin Reid on 3/13/25.
//

import SceneKit
import SwiftUI

class GravitySimulation: BaseSimulation, ObservableObject {
    private var timer: Timer?
    @Published var gravity: Float = -9.8 // Default gravity value

    override func setupScene() {
        super.setupScene()

        // Create the ground plane
        let planeGeometry = SCNPlane(width: 60, height: 60)
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3(x: 0, y: -5, z: 0)
        planeNode.eulerAngles = SCNVector3(x: -Float.pi / 2, y: 0, z: 0) // Rotate to lie flat

        // Apply a brown material to the plane
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.brown
        planeNode.geometry?.materials = [planeMaterial]

        // Add a static physics body to the plane
        let planePhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        planeNode.physicsBody = planePhysicsBody

        scene.rootNode.addChildNode(planeNode)

        updateGravity() // Apply the initial gravity

        // Timer to add random shapes every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.addRandomShape()
        }
    }

    private func addRandomShape() {
        // Randomly select a shape type (sphere, box, pyramid)
        let shapeType = Int.random(in: 0...2)
        let shapeNode: SCNNode
        let material = SCNMaterial()

        // Generate a random color for the shape
        func randomColor() -> UIColor {
            return UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        }

        // Create the shape based on the random type
        switch shapeType {
        case 0:
            let sphereGeometry = SCNSphere(radius: 1.0)
            shapeNode = SCNNode(geometry: sphereGeometry)
            material.diffuse.contents = randomColor()
        case 1:
            let boxGeometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.1)
            shapeNode = SCNNode(geometry: boxGeometry)
            material.diffuse.contents = randomColor()
        case 2:
            let pyramidGeometry = SCNPyramid(width: 2.0, height: 2.0, length: 2.0)
            shapeNode = SCNNode(geometry: pyramidGeometry)
            material.diffuse.contents = randomColor()
        default:
            return
        }

        // Apply the random color material to the shape
        shapeNode.geometry?.materials = [material]

        // Position the shape randomly above the plane
        let randomX = Float.random(in: -25...25)
        let randomZ = Float.random(in: -25...25)
        shapeNode.position = SCNVector3(x: randomX, y: 10, z: randomZ)

        // Add a dynamic physics body to the shape
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: shapeNode.geometry!, options: nil))
        shapeNode.physicsBody = physicsBody

        scene.rootNode.addChildNode(shapeNode)
    }

    func restartSimulation() {
        // Invalidate the timer and remove all dynamic nodes
        timer?.invalidate()
        scene.rootNode.childNodes.forEach { node in
            if node.physicsBody != nil {
                node.removeFromParentNode()
            }
        }
        gravity = -9.8 // Reset gravity
        updateGravity()
        setupScene() // Re-setup the scene
    }

    override func update(time: TimeInterval) {
        // Remove shapes that fall below a certain Y-level
        scene.rootNode.childNodes.forEach { node in
            if node.physicsBody != nil && node.position.y < -30 {
                node.removeFromParentNode()
            }
        }
    }

    func updateGravity() {
        // Apply the current gravity value to the physics world
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: gravity, z: 0)
    }
}
