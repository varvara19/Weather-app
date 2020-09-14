//
//  HeaderTableViewCell.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/13/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit
import CoreLocation

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }
    
    static let identifier = "HeaderTableViewCell"
       
    static func nib () -> UINib {
           return UINib(nibName: "HeaderTableViewCell", bundle: nil)
       }
    func configure( with model: Current){
        
        tempLabel.text = "\(Int(model.temp - 273.15 ))°"
        weatherLabel.text = model.weather[0].main
        
       
        
    }
   
    
}

