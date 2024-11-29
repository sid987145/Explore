//
//  ContentCell.swift
//  exploreTest
//
//  Created by Siddharth Chaudhary on 29/11/24.
//
import UIKit

class ContentCell: UICollectionViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentImage.image = UIImage(named: "placeholder")
        contentImage.layer.cornerRadius = 8
        contentImage.layer.masksToBounds = true
    }
    
    func configureCell(with journey: Journey) {
        titleLabel.text = journey.title
        let detailText = "\(journey.promoText ?? "") .  \(journey.description ?? "")"
        detailLabel.text = detailText
        
        if let thumbImageURL = URL(string: journey.coverImage ?? "") {
            loadImage(from: thumbImageURL)
        }
    }
    
    private func loadImage(from url: URL) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            contentImage.image = cachedImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let downloadedImage = UIImage(data: data) {
                self?.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self?.contentImage.image = downloadedImage
                }
            }
        }
        task.resume()
    }
}
