//
//  PostPageTableViewCell.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/28.
//

import UIKit

class PostPageTableViewCell: UITableViewCell {

    static let identifier = "PostPageTableViewCell"
    public let comentUserId : UILabel = {
       let userID = UILabel()
        userID.textColor = .black
        userID.textAlignment = .left
        userID.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        userID.translatesAutoresizingMaskIntoConstraints = false
        return userID
    }()
    public let coment : UILabel = {
       let coment = UILabel()
        coment.textColor = .blue
        coment.textAlignment = .left
        coment.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        coment.translatesAutoresizingMaskIntoConstraints = false
        return coment
        
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        self.addSubview(comentUserId)
        comentUserId.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        comentUserId.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -10).isActive = true
        comentUserId.widthAnchor.constraint(equalToConstant: 180).isActive = true
        comentUserId.heightAnchor.constraint(equalToConstant: 13).isActive = true
        self.addSubview(coment)
        coment.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
        coment.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        coment.widthAnchor.constraint(equalToConstant: 200).isActive = true
        coment.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
