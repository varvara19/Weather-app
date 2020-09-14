//
//  DailyInfoTableViewCell.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/11/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit

class DailyInfoTableViewCell: UITableViewCell {

    @IBOutlet var dailyInfo: UILabel!
     override func awakeFromNib() {
           super.awakeFromNib()
          
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
      
       }
    
    static let identifier = "DailyInfoTableViewCell"
       
       static func nib () -> UINib {
           return UINib(nibName: "DailyInfoTableViewCell", bundle: nil)
       }
    func configure( with model: Current){
        let sunriseTime = getTime(Date(timeIntervalSince1970: Double(model.sunrise)))
        let sunsetTime = getTime(Date(timeIntervalSince1970: Double(model.sunset)))
        self.dailyInfo.text = "Today: Now \(model.weather[0].description). Sunrise time:  \(sunriseTime). Sunset time:  \(sunsetTime)."
    }
    
    public func getTime(_ date: Date?) -> String{
           guard let inputDate = date else {
               return ""
           }
           let formetter = DateFormatter()
           formetter.timeStyle = DateFormatter.Style.short
           formetter.timeZone = .current
           return formetter.string(from: inputDate)
       }
}
