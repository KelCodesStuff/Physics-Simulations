//
//  FluidViewController.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import UIKit
import SceneKit

class FluidViewController: UIViewController {
    // MARK: - Properties
    
    private var sceneManager: FluidSceneManager!
    private var controls: SimulationControls!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSimulations()
    }
    
    // MARK: - Setup
    
    private func setupSimulations() {
        // Setup fluid simulation
        sceneManager = FluidSceneManager(frame: view.bounds)
        view.addSubview(sceneManager.sceneView)
        
        // Setup controls
        controls = SimulationControls(frame: view.bounds)
        controls.delegate = self
        controls.hideWindControls() // Hide wind controls for fluid simulation
        view.addSubview(controls)
    }
}

// MARK: - SimulationControlsDelegate
extension FluidViewController: SimulationControlsDelegate {
    func windToggled() {
        // Wind control not implemented for fluid simulation
    }
    
    func simulationRestarted() {
        sceneManager.restartSimulation()
    }
} 
