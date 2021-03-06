//
//  StatViewController.swift
//  Magic Hours
//
//  Created by Quentin Cornu on 28/10/2018.
//  Copyright © 2018 Quentin. All rights reserved.
//

import UIKit
import RealmSwift

class StatViewController: UIViewController {

    // MARK: - Private properties
    
    let statView: StatView = {
        let view = StatView()
        view.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.energySelector.addTarget(self, action: #selector(selectEnergy), for: .touchUpInside)
        view.focusSelector.addTarget(self, action: #selector(selectFocus), for: .touchUpInside)
        view.motivationSelector.addTarget(self, action: #selector(selectMotivation), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = statView

        statView.setValues(points: fetchPoints(criteria: Criteria.energy))
    }
    
    // MARK: - Actions
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectEnergy() {
        statView.setValues(points: fetchPoints(criteria: Criteria.energy))
        statView.energySelector.setColor(color: UIColor(displayP3Red: 231/255, green: 76/255, blue: 60/255, alpha: 1))
        statView.motivationSelector.setColor(color: UIColor.lightGray)
        statView.focusSelector.setColor(color: UIColor.lightGray)
    }
    
    @objc private func selectFocus() {
        statView.setValues(points: fetchPoints(criteria: Criteria.focus))
        statView.energySelector.setColor(color: UIColor.lightGray)
        statView.motivationSelector.setColor(color: UIColor.lightGray)
        statView.focusSelector.setColor(color: UIColor(displayP3Red: 41/255, green: 128/255, blue: 185/255, alpha: 1))
    }
    
    @objc private func selectMotivation() {
        statView.setValues(points: fetchPoints(criteria: Criteria.motivation))
        statView.energySelector.setColor(color: UIColor.lightGray)
        statView.motivationSelector.setColor(color: UIColor(displayP3Red: 241/255, green: 196/255, blue: 15/255, alpha: 1))
        statView.focusSelector.setColor(color: UIColor.lightGray)
    }
    
    // MARK: - Private functions
    
    private func createEmptyPointArray() -> [Point] {
        var points = [Point]()
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        for i in 0..<12 {
            points.append(Point(label: "\(currentHour-11+i)", value: 0))
        }
        
        return points
    }
    
    private func fetchPoints(criteria: Criteria) -> [Point] {
        let realm = try! Realm()
        var points = createEmptyPointArray()

        let energyPoints = realm.objects(DataPoint.self).filter("criteria = %@ AND date > %@", String(criteria.rawValue), Date(timeInterval: -60*60*12, since: Date()))
        
        for point in energyPoints {
            let hourInterval = Int(point.date.timeIntervalSinceNow/(60*60))
            let currentHour = Calendar.current.component(.hour, from: Date())
            points[points.count+hourInterval-1] = Point(label: String(currentHour+hourInterval), value: Int(point.note))
        }
        
        return points
    }

}
