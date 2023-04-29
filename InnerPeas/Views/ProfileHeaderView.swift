//
//  ProfileHeaderView.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject{
    func ProfileHeaderViewDelegateDidTapFollowers(_ containerView: ProfileHeaderView)
    func ProfileHeaderViewDelegateDidTapFollowing(_ containerView: ProfileHeaderView)
    func ProfileHeaderViewDelegateDidTapRecipe(_ containerView: ProfileHeaderView)
    func ProfileHeaderViewDelegateDidTapEditProfile(_ containerView: ProfileHeaderView)
    func ProfileHeaderViewDelegateDidTapFollow(_ containerView: ProfileHeaderView)
    func ProfileHeaderViewDelegateDidTapUnFollow(_ containerView: ProfileHeaderView)

}

class ProfileHeaderView: UIView {

    weak var delegate: ProfileHeaderViewDelegate?
    private var action = ProfileButtonType.edit
    
    private let followingButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let followersButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let recipeButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followingButton)
        addSubview(followersButton)
        addSubview(recipeButton)
        addSubview(actionButton)
        addActions()
    }
    
    private func addActions() {
        followersButton.addTarget(self, action: #selector(didTapFollwers), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        recipeButton.addTarget(self, action: #selector(didTapRecipe), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc func didTapFollwers() {
        delegate?.ProfileHeaderViewDelegateDidTapFollowers(self)
    }
    @objc func didTapFollowing() {
        delegate?.ProfileHeaderViewDelegateDidTapFollowing(self)
    }
    @objc func didTapRecipe() {
        delegate?.ProfileHeaderViewDelegateDidTapRecipe(self)
    }
    @objc func didTapActionButton() {
        switch action {
        case .edit:
            delegate?.ProfileHeaderViewDelegateDidTapEditProfile(self)
        case .follow(let isFollowing):
            if isFollowing {
                delegate?.ProfileHeaderViewDelegateDidTapUnFollow(self)
            }
            else{
                delegate?.ProfileHeaderViewDelegateDidTapFollow(self)
            }
        }
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth: CGFloat = (width-15)/3
        followingButton.frame = CGRect(
            x: 5,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        followersButton.frame = CGRect(
            x: followingButton.right+5,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        recipeButton.frame = CGRect(
            x: followersButton.right+5,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        actionButton.frame = CGRect(
            x: 5,
            y: height-42,
            width: width-10,
            height: 40)
        
    }
    
    func configure(with viewModel: ProfileHeaderCountViewModel){
        followersButton.setTitle("Following\n\(viewModel.followerCount)", for: .normal)
        followingButton.setTitle("Followers\n\(viewModel.followingCount)", for: .normal)
        recipeButton.setTitle("Recipes\n\(viewModel.recipeCount)", for: .normal)
        
        self.action = viewModel.actionType
        
        switch viewModel.actionType {
        case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            actionButton.layer.borderWidth = 0.5
            
        case .follow(let isFollowing):
            actionButton.backgroundColor = isFollowing ? .systemBackground: .systemGreen
            actionButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
            actionButton.setTitleColor(isFollowing ? .label : .white, for: .normal)
            
            if isFollowing {
                actionButton.layer.borderWidth = 0.5
                actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            }
            else{
                actionButton.layer.borderWidth = 0
            }
        }

    }
}
