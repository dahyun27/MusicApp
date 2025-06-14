//
//  MusicCell.swift
//  MyMusicApp
//
//  Created by 하다현 on 6/13/25.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var music: Music? {
        didSet {
            configureUIWithData()
        }
    }
    
    var saveButtonPressed: ((MusicCell, Bool) -> ()) = {(sender, pressed) in }
    
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.contentMode = .scaleToFill
        saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        saveButton.tintColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUIWithData() {
        guard let music = music else { return }
        loadImage(with: music.imageUrl)
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        albumNameLabel.text = music.albumName
        releaseDateLabel.text = music.releaseDateString
        
    }
    
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let isSaved = music?.isSaved else { return }
        
        saveButtonPressed(self, isSaved)
        setButtonStatus()
    }
    
    
    func setButtonStatus () {
        guard let isSaved = self.music?.isSaved else { return }
        
        if !isSaved {
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
            saveButton.tintColor = .gray
        } else {
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            saveButton.tintColor = .red
        }
    }
}
