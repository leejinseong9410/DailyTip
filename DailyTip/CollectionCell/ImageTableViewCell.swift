//
//  ImageTableViewCell.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/24.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    public let postNumber : UILabel = {
       let postNumber = UILabel()
        postNumber.textColor = .darkGray
        postNumber.textAlignment = .center
        
        postNumber.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        postNumber.translatesAutoresizingMaskIntoConstraints = false
        return postNumber
    }()
    public let postTitle : UILabel = {
       let postTitle = UILabel()
        postTitle.textColor = .black
        postTitle.layer.borderWidth = 0.8
        postTitle.layer.borderColor = UIColor.lightGray.cgColor
        postTitle.textAlignment = .center
        postTitle.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        return postTitle
    }()
    public let postWriter : UILabel = {
       let postWriter = UILabel()
        postWriter.textColor = .black
        postWriter.textAlignment = .center
      
        postWriter.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        postWriter.translatesAutoresizingMaskIntoConstraints = false
        return postWriter
    }()
    public let postDate : UILabel = {
       let postDate = UILabel()
        postDate.textColor = .lightGray
        postDate.textAlignment = .center
     
        postDate.font = UIFont.systemFont(ofSize: 9, weight: .light)
        postDate.translatesAutoresizingMaskIntoConstraints = false
        return postDate
    }()
    public let postImage : UIImageView = {
       let postImage = UIImageView()
        postImage.contentMode = .scaleToFill
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()
    public let postRecomend : UILabel = {
        let postRecomend = UILabel()
        postRecomend.textColor = .darkGray
        postRecomend.textAlignment = .left
      
        postRecomend.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        postRecomend.translatesAutoresizingMaskIntoConstraints = false
        return postRecomend
    }()
    public let postComent : UILabel = {
        let postComent = UILabel()
        postComent.textColor = .darkGray
        postComent.textAlignment = .center
   
        postComent.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        postComent.translatesAutoresizingMaskIntoConstraints = false
        return postComent
    }()
    public let postNotRecomend : UILabel = {
        let postNotRecomend = UILabel()
        postNotRecomend.textColor = .darkGray
        postNotRecomend.textAlignment = .left
       
        postNotRecomend.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        postNotRecomend.translatesAutoresizingMaskIntoConstraints = false
        return postNotRecomend
    }()
    static let identifier = "ImageTableViewCell"

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
    public func configure(){
        self.addSubview(postNumber)
        self.addSubview(postImage)
        self.addSubview(postTitle)
        self.addSubview(postComent)
        self.addSubview(postWriter)
        self.addSubview(postRecomend)
        self.addSubview(postDate)
        self.addSubview(postNotRecomend)
    
        postNumber.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        postNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postNumber.widthAnchor.constraint(equalToConstant: 15).isActive = true
        postNumber.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        postImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        postImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        postTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70).isActive = true
        postTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
        postTitle.heightAnchor.constraint(equalToConstant: 15).isActive = true
                
        postWriter.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 260).isActive = true
        postWriter.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postWriter.widthAnchor.constraint(equalToConstant: 30).isActive = true
        postWriter.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        postRecomend.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 300).isActive = true
        postRecomend.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -10).isActive = true
        postRecomend.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postRecomend.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        postDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60).isActive = true
        postDate.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 15).isActive = true
        postDate.widthAnchor.constraint(equalToConstant: 130).isActive = true
        postDate.heightAnchor.constraint(equalToConstant: 9).isActive = true
        
        postNotRecomend.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 300).isActive = true
        postNotRecomend.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 10).isActive = true
        postNotRecomend.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postNotRecomend.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
}
