//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit
import Kingfisher

protocol PosterCollectionViewCellTypeDelegate: AnyObject {
    func PosterCollectionViewCellTypeDidTapUsername(_cell: PosterCollectionViewCellType)
    func PosterCollectionViewCellTypeDidTapMoreButton(_cell: PosterCollectionViewCellType)
    
}
final class PosterCollectionViewCellType: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCellType"
    
    weak var delegate: PosterCollectionViewCellTypeDelegate?
    
    private var isMade = false
    private var isFav = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "ellipsis",
            withConfiguration: UIImage.SymbolConfiguration(pointSize:20)
        )
        button.setImage(image, for: .normal)
       return button
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapUsername))
        usernameLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc func didTapMoreButton() {
        delegate?.PosterCollectionViewCellTypeDidTapMoreButton(_cell: self)
        
    }

    
    @objc func didTapUsername(){
        delegate?.PosterCollectionViewCellTypeDidTapUsername(_cell: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 4
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        
        imageView.frame = CGRect(
            x: imagePadding,
            y: imagePadding,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(
            x: imageView.right+10,
            y: 0,
            width: usernameLabel.width,
            height: contentView.height
        )
        
        moreButton.frame = CGRect(x: contentView.width - 60,
                                  y: (contentView.height-50)/2,
                                  width: 50,
                                  height: 50)
        


    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        imageView.image = nil
    }
    
    func configure(with viewModel:PosterCollectionViewCell){
        usernameLabel.text = viewModel.username
        imageView.kf.setImage(with: viewModel.profilePictureURL)
        
    }
    
}
