//
//  SettingsTableViewController.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderTableViewCell
            
            cell.setupSlider(title: "Population size",min: 2, max: 100, value: Float(Global.data.populationSize), IsRounded: true)
            cell.valueUpdated = { value in
                Global.data.populationSize = Int(value)
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderTableViewCell
            
            cell.setupSlider(title: "Mutation rate",min: 0, max: 5, value: Float(Global.data.mutationRate), IsRounded: false, suffix: "%")
            cell.valueUpdated = { value in
                Global.data.mutationRate = Double(value)
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderTableViewCell
            
            cell.setupSlider(title: "Delay between movements",min: 0, max: 0.3, value: Float(Global.data.simDelay), IsRounded: false, suffix: "s")
            cell.valueUpdated = { value in
                Global.data.simDelay = Double(value)
            }

            return cell
        }
        let cell = UITableViewCell()
        return cell

    }
    

    

}
