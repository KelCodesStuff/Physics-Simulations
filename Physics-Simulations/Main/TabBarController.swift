//
//  TabBarController.swift
//  Physics-Simulations
//
//  Created by Kelvin Reid on 3/27/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        // Sphere Simulation Tab
        let sphereVC = ViewController()
        sphereVC.tabBarItem = UITabBarItem(
            title: "Spheres",
            image: UIImage(systemName: "circle.grid.3x3.fill"),
            selectedImage: UIImage(systemName: "circle.grid.3x3.fill")
        )
        
        // Fluid Simulation Tab
        let fluidVC = FluidViewController()
        fluidVC.tabBarItem = UITabBarItem(
            title: "Fluid",
            image: UIImage(systemName: "drop.fill"),
            selectedImage: UIImage(systemName: "drop.fill")
        )
        
        // Set view controllers
        viewControllers = [sphereVC, fluidVC]
        
        // Customize tab bar appearance
        tabBar.tintColor = .white
        tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
} 
