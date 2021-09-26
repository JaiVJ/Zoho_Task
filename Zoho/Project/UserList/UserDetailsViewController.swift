//
//  UserDetailsViewController.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit
import Hero

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNoLbl: UILabel!
    @IBOutlet weak var viewOnMapBtn: UIButton!
    
    var dataSource: UserDetailsModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.makeCornerRadius()
        titleLbl.font = UIFont.appGiloryBoldFontWith(size: 20)
        nameLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        genderLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        ageLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        emailLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        mobileNoLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
        viewOnMapBtn.titleLabel?.font = UIFont.appGiloryMediumFontWith(size: 16)
        self.hero.isEnabled = true
        profileImageView.hero.id = dataSource.heroID
        setData()
        titleLbl.text = ZohoStrings.UserProfileDetails.title
        viewOnMapBtn.setTitle(ZohoStrings.UserProfileDetails.viewMap, for: .normal)
    }
    
    private func setData() {
        ImageLoader().imageLoad(imgView: profileImageView, url: dataSource.picture)
        nameLbl.text = dataSource.name
        genderLbl.text = dataSource.gender
        ageLbl.text = dataSource.age
        emailLbl.text = dataSource.email
        mobileNoLbl.text = dataSource.phone
    }
    
    
    @IBAction func viewOnMapAtn(_ sender: Any) {
        guard let url = URL(string:"http://maps.apple.com/?daddr=\(dataSource.latitude),\(dataSource.longitude)") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func backAtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
