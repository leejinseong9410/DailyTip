//
//  CategoryCollectionViewCell.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/05.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    static let buttonImageArray = [ #imageLiteral(resourceName: "icons8-car"),#imageLiteral(resourceName: "icons8-coronavirus"),#imageLiteral(resourceName: "icons8-pizza"),#imageLiteral(resourceName: "icons8-men_age_group_4"),#imageLiteral(resourceName: "icons8-t-shirt"),#imageLiteral(resourceName: "icons8-cottage"),#imageLiteral(resourceName: "icons8-barbell"),#imageLiteral(resourceName: "icons8-laptop_filled"),#imageLiteral(resourceName: "icons8-womans_hair"),#imageLiteral(resourceName: "icons8-instagram_filled"),#imageLiteral(resourceName: "icons8-standing_woman"),#imageLiteral(resourceName: "icons8-dog"),#imageLiteral(resourceName: "icons8-more")]
    
    public let categoryButton : UIButton = {
        let categoryButton = UIButton()
        categoryButton.layer.cornerRadius = 10
        categoryButton.backgroundColor = .black
        return categoryButton
    }()
    
    public func configure(widthValue : Int ){
        addSubview(categoryButton)
        var value = 0
        categoryButton.frame = CGRect(x: value, y: 0, width: 50, height: 50)
        value += 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

