//
//  CallTableViewCell.swift
//  tccPortaEletronica
//
//  Created by Tauan Marinho on 03/05/2018.
//  Copyright © 2018 Tauan Marinho. All rights reserved.
//

import UIKit

class CallTableViewCell: UITableViewCell {

    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
