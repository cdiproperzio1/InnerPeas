//
//  ProfileHeaderCollectionReusableView.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableViewDidTapProfilePic(_header:
    ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    
    public let countContainerView = ProfileHeaderView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hello my name is Justin \nThis is my bio"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = " "
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(countContainerView)
        addSubview(imageView)
        addSubview(bioLabel)
        addSubview(locationLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapImage(){
        delegate?.profileHeaderCollectionReusableViewDidTapProfilePic(_header: self)
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
        let bioSize = bioLabel.sizeThatFits(
            bounds.size
        )
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: width-10,
            height: bioSize.height)
        
        
        locationLabel.sizeToFit()
        locationLabel.frame = CGRect(
            x: 5,
            y: bioLabel.bottom+1,
            width: width-10,
            height: locationLabel.height)
        
        
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
        locationLabel.text = nil
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        imageView.kf.setImage(with: viewModel.profilePictureUrl, completionHandler: nil)

        if let name = viewModel.name {
            bioLabel.text = "\(name)\n\(viewModel.bio ?? "This is my profile!")"
        } else {
            bioLabel.text = viewModel.bio ?? "This is my profile!"
        }

        locationLabel.text = viewModel.location ?? "This is my location"

        let containerViewModel = ProfileHeaderCountViewModel(
            followingCount: viewModel.followerCount,
            followerCount: viewModel.followingCount,
            recipeCount: viewModel.recipeCount,
            actionType: viewModel.buttonType)
        countContainerView.configure(with: containerViewModel)
    }
}
