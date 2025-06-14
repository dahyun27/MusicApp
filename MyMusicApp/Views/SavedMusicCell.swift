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
    
    
    var musicSaved: MusicSaved? {
        didSet {
            configureUIWithData()
        }
    }
    
    // 뷰컨트롤러에 있는 클로저 저장할 예정
    var saveButtonPressed:((SavedMusicCell) -> ()) = { (sender) in }
    var updateButtonPressed: ((SavedMusicCell, String?) -> ()) = { (sender, text) in }
    
    // 셀이 재사용 되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageVIew.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUpdateButton()
    }

    private func setupUpdateButton() {
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 5
        updateButton.layer.borderWidth = 0
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUIWithData() {
        guard let musicSaved = musicSaved else { return }
        loadImage(with: musicSaved.imageUrl)
        songNameLabel.text = musicSaved.songName
        artistNameLabel.text = musicSaved.artistName
        albumNameLabel.text = musicSaved.albumName
        releaseDateLabel.text = musicSaved.releaseDate
        saveDateLabel.text = "Saved: \(musicSaved.savedDateString ?? "")"
        commentMessageLabel.text = musicSaved.myMessage
        
        setButtonStatus()
    }
    
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageVIew.image = UIImage(data: data)
            }
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButtonPressed(self)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self, musicSaved?.myMessage)
    }
    
    
    func setButtonStatus() {
        saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        saveButton.tintColor = .red
    }
}
