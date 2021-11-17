//
//  SliderTableViewCell.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func valueChanged(_ sender: Any) {
        valueUpdated?(slider.value)
        updateDisplayLabel()
    }
    
    func updateDisplayLabel() {
        var stringValue = ""
        if isRounded {
            stringValue = String(describing: Int(slider.value))
        } else {
            let value = rounded(value: Double(slider.value), places: 4)
            stringValue = String(describing: value)
        }
        displayLabel.text = stringValue

    }
    
    private var isRounded = false
    
    var valueUpdated: ((Float) -> (Void))?
    
    func setupSlider(title: String, min: Float, max: Float, value: Float, IsRounded: Bool) {
        nameLabel.text = title
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        self.isRounded = IsRounded
        updateDisplayLabel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func rounded(value: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
}
