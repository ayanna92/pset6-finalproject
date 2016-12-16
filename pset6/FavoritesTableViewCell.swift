//
//  FavoritesTableViewCell.swift
//  pset6
//
//  Created by Ayanna Colden on 10/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {


    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
