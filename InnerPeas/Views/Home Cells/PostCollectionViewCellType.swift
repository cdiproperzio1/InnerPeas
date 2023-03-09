//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit
import Kingfisher

final class PostCollectionViewCellType: UICollectionViewCell {
    static let identifier = "PostCollectionViewCellType"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with viewModel:PostCollectionViewCell){
        imageView.kf.setImage(with: viewModel.postUrl)
        
    }
    
}
