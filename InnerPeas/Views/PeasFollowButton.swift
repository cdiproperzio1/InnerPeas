//
//  PeasFollowButton.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/29/23.
//

import UIKit

final class PeasFollowButton: UIButton {

    enum State: String {
        case follow = "Follow"
        case unfollow = "Unfollow"
        
        var titleColor: UIColor{
            switch self {
            case .follow: return .white
            case .unfollow: return .label
            }
        }
        
        var backGroundColor: UIColor{
            switch self {
            case .follow: return .systemGreen
            case .unfollow: return .tertiarySystemBackground
            }
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(for state: State){
        setTitle(state.rawValue, for: .normal)
        backgroundColor = state.backGroundColor
        setTitleColor(state.titleColor, for: .normal)
        
        switch state{
        case .follow:
            layer.borderWidth = 0
        case .unfollow:
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.secondaryLabel.cgColor
        }
    }
}
