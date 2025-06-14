//
//  SavedMusicCell.swift
//  MyMusicApp
//
//  Created by 하다현 on 6/14/25.
//

import UIKit

class SavedMusicCell: UITableViewCell {

    @IBOutlet weak var mainImageVIew: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveDateLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
