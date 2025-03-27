//
//  SimulationControls.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import UIKit

protocol SimulationControlsDelegate: AnyObject {
    func windToggled()
    func simulationRestarted()
}

class SimulationControls: UIView {
    // MARK: - Properties
    
    weak var delegate: SimulationControlsDelegate?
    
    private let windSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(windSwitchChanged), for: .valueChanged)
        return toggle
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.text = "Wind"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupControls() {
        // Create wind controls container
        let windContainer = UIStackView()
        windContainer.axis = .horizontal
        windContainer.spacing = 10
        windContainer.alignment = .center
        windContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(windContainer)
        
        // Add wind controls to their container
        windContainer.addArrangedSubview(windLabel)
        windContainer.addArrangedSubview(windSwitch)
        
        // Add restart button
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(restartButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Wind controls in top left
            windContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            windContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            // Restart button centered at top
            restartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func windSwitchChanged() {
        delegate?.windToggled()
    }
    
    @objc private func restartButtonTapped() {
        delegate?.simulationRestarted()
    }
    
    // MARK: - Public Methods
    
    func setWindEnabled(_ enabled: Bool) {
        windSwitch.isOn = enabled
    }
    
    func hideWindControls() {
        windLabel.isHidden = true
        windSwitch.isHidden = true
    }
} 
