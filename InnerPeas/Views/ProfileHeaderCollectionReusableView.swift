//
//  ProfileHeaderCollectionReusableView.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    public let countContainerView = ProfileHeaderView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hello my name is Justin \nThis is my bio"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .systemBlue
        //countContainerView.backgroundColor = .systemRed
        addSubview(countContainerView)
        addSubview(imageView)
        addSubview(bioLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/3.5
        imageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageSize/2
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3,
            width: width-imageView.right-10
            , height: imageSize
        )
        bioLabel.sizeToFit()
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: width-10,
            height: bioLabel.height)
        
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        imageView.kf.setImage(with: viewModel.profilePictureUrl, completionHandler: nil)
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "This is my profile!"
        
        bioLabel.text = text
        
        let containerViewModel = ProfileHeaderCountViewModel(
            followingCount: viewModel.followerCount,
            followerCount: viewModel.followingCount,
            recipeCount: viewModel.recipeCount,
            actionType: viewModel.buttonType)
        countContainerView.configure(with: containerViewModel)
    }
}
