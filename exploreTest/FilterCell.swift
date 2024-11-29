//
//  FilterCell.swift
//  exploreTest
//
//  Created by Siddharth Chaudhary on 29/11/24.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

}
