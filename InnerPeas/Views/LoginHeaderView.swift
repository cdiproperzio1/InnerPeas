//
//  SiginInHeaderView.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import UIKit

class LoginHeaderView: UIView {
    
    //add images once decided one
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "buff squirrel")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set image size
        imageView.frame = CGRect(x: 30, y: 30, width: width - 40, height: height - 40)
    }
    
}
