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
- **Dynamic Labels**: Mass labels that automatically face the camera

### Wind Particle System
- **Visual Wind Effect**: Particle system showing wind direction and intensity
- **Synchronized Physics**: Wind particles appear before force application
- **Customizable Properties**:
  - Particle color and transparency
  - Birth rate (500 particles when active)
  - Particle velocity (12.0 units)
  - Spread angle (15 degrees)
- **Smooth Transitions**: 
  - Particles fade in when wind is enabled
  - Clean shutdown when wind is disabled or scene is reset

### Fluid Simulation
- **Particle-based Fluid**: 200 particles simulating fluid behavior
- **Realistic Water Properties**:
  - Zero-bounce particles for authentic liquid behavior
  - Optimized friction and damping for fluid-like movement
  - Particle collision and interaction
- **Real-time Physics**: Accurate gravity and collision detection

### Scene Features
- **Lighting System**:
  - Ambient light for overall scene illumination
  - Directional light for shadows and depth
- **Ground Plane**: Static physics body with collision detection

## Technical Details

### Physics Properties
- **Gravity**: -9.8 m/s² in Y direction
- **Wind Force**: 5 units in positive X direction
- **Ground**: Static physics body with gray material
- **Spheres**: Dynamic physics bodies with varying properties
  - Configurable mass
  - Adjustable restitution (bounce)
  - Friction coefficient: 0.5

## Requirements
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+
- SceneKit framework

## Installation
1. Clone the repository
2. Open `Physics-Simulations.xcodeproj` in Xcode
3. Build and run the project

## Future Enhancements
- Add more physics forces (magnetism, custom forces)
- Implement object creation through user interaction
- Add particle system customization through UI
- Include different wind patterns
- Add temperature effects on particle behavior
- Implement wind strength controls

## License
This project is available under the MIT License. See the LICENSE file for more info. 