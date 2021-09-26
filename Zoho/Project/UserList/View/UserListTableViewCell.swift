//
//  UserListTableViewCell.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileNameLbl.font = UIFont.appGiloryMediumFontWith(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(modal: UserDetailsModal) {
        ImageLoader().imageLoad(imgView: profileImageView, url: modal.picture)
        profileNameLbl.text = modal.name
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
