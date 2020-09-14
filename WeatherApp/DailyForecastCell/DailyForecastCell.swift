//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/8/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit

class DailyForecastCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }
    static let identifier = "DailyForecastCell"
    
    static func nib () -> UINib {
        return UINib(nibName: "DailyForecastCell", bundle: nil)
    }
    
    func configure(with model: Daily){
        
       
            
        self.maxTempLabel.textAlignment = .center
        self.minTempLabel.textAlignment = .center
        
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.minTempLabel.text = "\(Int(model.temp.min - 273.15 ))°"
        self.maxTempLabel.text = "\(Int(model.temp.max - 273.15 ))°"
        
        self.icon.image = UIImage(named: model.weather[0].icon)
        self.icon.contentMode = .scaleAspectFit
        
    }
    
    func configureCurrent (with model: Daily){
        self.maxTempLabel.textAlignment = .center
        self.minTempLabel.textAlignment = .center
        self.maxTempLabel.text = "\(Int(model.temp.max - 273.15))°"
        self.minTempLabel.text = "\(Int(model.temp.min - 273.15))°"
        self.icon.image = UIImage(named: model.weather[0].icon)
        self.dayLabel.text = "Today"
        
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }

}


