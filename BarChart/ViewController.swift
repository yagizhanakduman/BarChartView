//
//  ViewController.swift
//  BarChart
//
//  Created by YAGIZHAN AKDUMAN
//

import UIKit

class ViewController: UIViewController {
    
    /// Colors
    let redColor = UIColor(red: 240/255, green: 95/255, blue: 109/255, alpha: 1.0)
    let greenColor = UIColor(red: 40/255, green: 167/255, blue: 69/255, alpha: 1.0)
    let blueColor = UIColor(red: 0/255, green: 160/255, blue: 223/255, alpha: 1.0)
    let yellowColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupBarCharView()
    }
    
    func setupButton() {
        /// Create the button
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reload Bar Chart", for: .normal)
        button.backgroundColor = blueColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        /// Activate constraints
        NSLayoutConstraint.activate([
            /// Button constraints (relative to screen, not to squareView)
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
    }
    
    func setupBarCharView() {
        /// Create bar chart view with data
        let barChartView = BarChartView(usageData: [
            BarChartView.UsageData(color: redColor, value: 4),
            BarChartView.UsageData(color: greenColor, value: 1),
            BarChartView.UsageData(color: blueColor, value: 3),
            BarChartView.UsageData(color: yellowColor, value: 2)
        ], totalValue: 15)
        /// Setup bar chart view
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView)
        /// Activate constraints
        NSLayoutConstraint.activate([
            /// Width & Height
            barChartView.widthAnchor.constraint(equalToConstant: 250),
            barChartView.heightAnchor.constraint(equalToConstant: 25),
            /// Center horizontally and vertically
            barChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        /// Remove bar chart view before adding new one to refresh
        view.subviews.forEach { subview in
            (subview as? BarChartView)?.removeFromSuperview()
        }
        /// Add new one
        setupBarCharView()
    }
    
}
