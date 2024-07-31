//
//  TabBarController.swift
//  CryptoC
//
//  Created by Daniil Kim on 30.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ViewController()
        let vc2 = TrackerViewController()
        let vc3 = GraphsViewController()
        
        vc1.title = "Browse Currency"
        vc2.title = "Track Your Expenses"
        vc3.title = "Your Expenses Graphs"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Currency Converter", image: UIImage(systemName: "circle.lefthalf.filled"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Track Expenses", image: UIImage(systemName: "square.and.pencil"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Expenses Graphs", image: UIImage(systemName: "chart.pie"), tag: 3)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        
        setViewControllers([nav1, nav2, nav3], animated: false)
        
        
    }
    
}
