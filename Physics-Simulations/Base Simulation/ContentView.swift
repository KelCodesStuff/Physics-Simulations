//
//  ContentView.swift
//  PhysicsSimulations
//
//  Created by Kelvin Reid on 3/13/25.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    // State object to manage the gravity simulation
    @StateObject var gravitySimulation = GravitySimulation()
    
    // Constant object to manage collision simulation
    let collisionSimulation = CollisionSimulation()

    var body: some View {
        // TabView to switch between gravity and collision simulations
        TabView {
            // VStack for the gravity simulation tab
            VStack {
                // HStack for the restart button and gravity display
                HStack {
                    // Button to restart the gravity simulation
                    Button("Restart") {
                        gravitySimulation.restartSimulation()
                    }
                    // Spacer to push the gravity display to the right
                    Spacer()
                    // Text to display the current gravity value
                    Text("Gravity: \(String(format: "%.1f", gravitySimulation.gravity))")
                }
                .padding()

                // SceneView to display the gravity simulation
                SceneView(scene: gravitySimulation.scene, options: [.allowsCameraControl])
                    .ignoresSafeArea()

                // Slider to control the gravity value
                Slider(value: $gravitySimulation.gravity, in: -20...0) {
                    Text("Gravity")
                }
                // Add padding to the Slider
                .padding()
            }
            // Configure the gravity simulation tab
            .tabItem {
                Label("Gravity", systemImage: "")
            }
            // Update gravity when the view appears
            .onAppear {
                gravitySimulation.updateGravity()
            }
            // Update gravity when the gravity value changes
            .onChange(of: gravitySimulation.gravity) { newValue in
                gravitySimulation.updateGravity()
            }
// TODO: Removing for now
/*
            // SceneView to display the collision simulation
            SceneView(scene: collisionSimulation.scene, options: [.allowsCameraControl])
                // Configure the collision simulation tab
                .tabItem {
                    Label("Collision", systemImage: "sparkles")
                }
*/
        }
    }
}


