//
//  Message.swift
//  AIMessaging
//
//  Created by HAKAN on 29.12.2024.
//

import Foundation

public class Message {
    let content: String
    let isFromUser: Bool
    
    init(content: String, isFromUser: Bool) {
        self.content = content
        self.isFromUser = isFromUser
    }
}
