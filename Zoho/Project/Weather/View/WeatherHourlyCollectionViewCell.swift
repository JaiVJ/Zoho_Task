//
//  WeatherHourlyCollectionViewCell.swift
//  Zoho
//
//  Created by Jai on 26/09/21.
//

import UIKit

class WeatherHourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        timeLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        temperatureLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
    }
    
    class var identifier: String
    {
        return String(describing: self)
    }
    
    class var nib: UINib
    {
        return UINib(nibName: identifier, bundle: nil)
    }
  

}
