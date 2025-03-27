//
//  ViewController.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sceneManager: SceneManager!
    private var controls: SimulationControls!
    private var segmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupSimulations()
    }
    
    // MARK: - Setup
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Spheres", "Fluid"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupSimulations() {
        // Setup sphere simulation
        sceneManager = SceneManager(frame: view.bounds)
        view.addSubview(sceneManager.sceneView)
        
        // Setup controls
        controls = SimulationControls(frame: view.bounds)
        controls.delegate = self
        view.addSubview(controls)
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControlChanged() {
        // This is no longer needed as we're using tab bar navigation
    }
}

// MARK: - SimulationControlsDelegate
extension ViewController: SimulationControlsDelegate {
    func windToggled() {
        sceneManager.toggleWind()
        controls.setWindEnabled(sceneManager.isWindEnabled)
    }
    
    func simulationRestarted() {
        sceneManager.addObjects()
        controls.setWindEnabled(false)
    }
}

