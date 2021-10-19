//
//  Top10ViewCell.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/04.
//

import UIKit

class Top10ViewCell: UITableViewCell {

    static let identifier = "Top10ViewCell"
    
    public let boardCategory : UILabel = {
       let boardCategory = UILabel()
        boardCategory.textColor = .black
        boardCategory.textAlignment = .center
        boardCategory.font = UIFont.systemFont(ofSize: 10,weight: .bold)
        boardCategory.translatesAutoresizingMaskIntoConstraints = false
        return boardCategory
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        self.addSubview(boardCategory)
        boardCategory.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        boardCategory.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        boardCategory.widthAnchor.constraint(equalToConstant: 10).isActive = true
        boardCategory.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
}
