# Physics Simulations

An iOS app demonstrating physics simulations using Swift, SceneKit and UIKit. This project showcases various physics concepts through interactive 3D simulations.

## Features

### Sphere Physics Simulation
- **Gravity Simulation**: Three spheres with different masses falling under gravity
- **Collision Physics**: Objects interact with each other and the ground
- **Wind Force**: Toggle wind effect to see how objects react to external forces
- **Mass and Bounce Properties**: Each sphere has unique physical properties:
  - Red Sphere: Light (1.0 mass), High bounce (0.9)
  - Blue Sphere: Medium (2.0 mass), Medium bounce (0.7)
  - Green Sphere: Heavy (5.0 mass), Low bounce (0.3)

### Fluid Simulation
- **Particle-based Fluid**: 200 particles simulating fluid behavior
- **Realistic Water Properties**:
  - Zero-bounce particles for authentic liquid behavior
  - Optimized friction and damping for fluid-like movement
  - Particle collision and interaction
- **Real-time Physics**: Accurate gravity and collision detection

## Technical Details

### Physics Properties

#### Sphere Simulation
- Gravity: -9.8 m/s² in Y direction
- Wind Force: 2 units in positive X direction
- Ground: Static physics body with gray material
- Spheres: Dynamic physics bodies with varying properties

#### Fluid Simulation
- Particle Count: 200 water particles
- Container: Glass-like material with transparency
- Particle Physics: Optimized for fluid behavior
  - Zero restitution (no bounce)
  - Controlled friction and damping
  - Particle-to-particle interaction

## Requirements
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation
1. Clone the repository
2. Open `Physics-Simulations.xcodeproj` in Xcode
3. Build and run the project

## Usage
1. Launch the app
2. Use the tab bar to switch between simulations:
   - "Spheres" tab: Experiment with different mass spheres and wind effects
   - "Fluid" tab: Observe particle-based fluid simulation
3. Use the restart button to reset each simulation
4. In the sphere simulation, toggle wind effects using the wind switch

## Future Enhancements
- Add more physics forces (magnetism, custom forces)
- Implement object creation through user interaction
- Add more fluid simulation parameters
- Include different container shapes
- Add temperature effects on fluid behavior
- Implement fluid viscosity controls

## License
This project is available under the MIT License. See the LICENSE file for more info. 
