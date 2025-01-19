//
//  HomeView.swift
//  AIMessaging
//
//  Created by HAKAN on 27.12.2024.
//

import UIKit

class HomeHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Messaging"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        return label
    }()
    
    private let aiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ai")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame )
        
        setUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        addSubview(aiImageView)
        addSubview(titleLabel)
        

        NSLayoutConstraint.activate([
            
            
                      titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                      
                      
                      aiImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                      aiImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                      aiImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
                      aiImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
                  ])
    }
    
}


#Preview {
    HomeHeaderView()
}
