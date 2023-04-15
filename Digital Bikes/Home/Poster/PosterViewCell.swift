//
//  PosterViewCell.swift
//  Digital Bikes
//
//  Created by PSE on 15.04.23.
//

import UIKit

class PosterViewCell: UICollectionViewCell {

    @IBOutlet weak var picture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        picture.layer.cornerRadius = 10
    }

}
