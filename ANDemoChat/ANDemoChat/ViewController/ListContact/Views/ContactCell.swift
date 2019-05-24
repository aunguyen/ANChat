//
//  ContactCell.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
	
	@IBOutlet weak private var imgView: UIImageView!
	@IBOutlet weak private var lblName: UILabel!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var onlineMark: UIView!
	var contact: UserObj?{
		didSet{
			lblName.text = contact?.username ?? ""
			imgView.setImage(string: contact?.username, color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), circular: true, textAttributes: nil)
			onlineMark.isHidden = !(contact?.online ?? false)
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
