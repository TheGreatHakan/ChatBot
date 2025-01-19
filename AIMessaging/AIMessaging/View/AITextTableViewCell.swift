//
//  AITextTableViewCell.swift
//  AIMessaging
//
//  Created by HAKAN on 28.12.2024.
//

import UIKit

class AITextTableViewCell: UITableViewCell {

    static let id = "id"
    
    private let iconView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .small)
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ai", in: nil, with: config)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let messageContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBlue
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 20
        label.text = "Hakan"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        setUI()
        
    }
    
 
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configure(with message: String ) { //need a model
        messageTextLabel.text = message
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageTextLabel.text = nil
    }
    
    private func setUI() {
        addSubview(messageContainer)
        messageContainer.addSubview(messageTextLabel)
//        messageContainer.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            
                   messageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                   messageContainer.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 10),
                   messageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                   messageContainer.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
                   
                   
                 
                   messageTextLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
                   messageTextLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 12),
                   messageTextLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: 10),
                   messageTextLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -8)
               ])
    }
}


//#Preview {
//    let cell = AITextTableViewCell()
//    cell.configure(with: "Hakan")
//    return cell
//    
//}
