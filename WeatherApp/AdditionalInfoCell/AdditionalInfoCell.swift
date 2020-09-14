//
//  AdditionalInfoCell.swift
//  WeatherApp
//
//  Created by Sunrise Sunrise on 9/11/20.
//  Copyright © 2020 Sunrise Sunrise. All rights reserved.
//

import UIKit

class AdditionalInfoCell: UITableViewCell{
   
  static let identifier = "AdditionalInfoCell"
 
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    

       static func nib () -> UINib {
              return UINib(nibName: "AdditionalInfoCell", bundle: nil)
          }
    override func awakeFromNib() {
           super.awakeFromNib()
          
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

      
       }
}

