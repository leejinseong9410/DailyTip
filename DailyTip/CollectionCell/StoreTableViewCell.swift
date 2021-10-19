//
//  StoreTableViewCell.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/11.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    static let indentifier = "StoreTableViewCell"
    
    public let titleTxt : UILabel = {
       let title = UILabel()
        title.textColor = .black
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
        title.layer.borderColor = UIColor.lightGray.cgColor
        title.layer.borderWidth = 1
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    public let priceTxt : UILabel = {
       let price = UILabel()
        price.textColor = .black
        price.textAlignment = .center
        price.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
        price.layer.borderColor = UIColor.lightGray.cgColor
        price.layer.borderWidth = 1
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        confi()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func confi(){
        self.addSubview(titleTxt)
        titleTxt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        titleTxt.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleTxt.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleTxt.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.addSubview(priceTxt)
        priceTxt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100).isActive = true
        priceTxt.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        priceTxt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        priceTxt.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
