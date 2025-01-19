//
//  UserTextTableViewCell.swift
//  AIMessaging
//
//  Created by HAKAN on 28.12.2024.
//

import UIKit

class UserTextTableViewCell: UITableViewCell {
    
    static let id = "ids"
    
    private let messageContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBlue
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        
        label.text = "Hakan"
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
   
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        addSubview(messageContainer)
        messageContainer.addSubview(messageTextLabel)
        
        NSLayoutConstraint.activate([
                   messageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                   messageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                   messageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                   messageContainer.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
                   
                   messageTextLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
                   messageTextLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 12),
                   messageTextLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -12),
                   messageTextLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -8)
               ])
    }
    
    
    func configure(with message: String ) { //need a model
        messageTextLabel.text = message
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageTextLabel.text = nil
    }
}
