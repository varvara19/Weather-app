//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/11/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit


class WeatherCollectionViewCell: UICollectionViewCell {
static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    func configure( with model: Hourly){
       
       self.timeLabel.text = getTime(Date(timeIntervalSince1970: Double(model.dt)))
    
        self.tempLabel.text = "\(Int(model.temp - 273.15))°"
        self.icon.contentMode = .scaleAspectFit
        self.icon.image = UIImage(named: model.weather[0].icon)
    }
    
    public func getTime(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formetter = DateFormatter()
        formetter.dateFormat = "HH"
       
        formetter.timeZone = .current
        return formetter.string(from: inputDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

   
    
}
