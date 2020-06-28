//
//  Post.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation

public struct Post: Codable {
    public let body: String
    public let title: String
    public let uuid: String
    public let userId: String
    public let creationDate: String
    
    private enum CodingKeys: String, CodingKey {
        case body
        case title
        case uuid
        case userId
        case creationDate
    }
    
    public init(body: String,
                title: String,
                uuid: String,
                userId: String,
                creationDate: String) {
        self.body = body
        self.title = title
        self.uuid = uuid
        self.userId = userId
        self.creationDate = creationDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        body = try container.decode(String.self, forKey: .body)
        title = try container.decode(String.self, forKey: .title)
         
        if let creationDate = try container.decodeIfPresent(Int.self, forKey: .creationDate) {
            self.creationDate = "\(creationDate)"
        } else {
            creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        }
        
        if let uuid = try container.decodeIfPresent(Int.self, forKey: .uuid) {
            self.uuid = "\(uuid)"
        } else {
            uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? ""
        }
        
        if let userId = try container.decodeIfPresent(Int.self, forKey: .userId) {
            self.userId = "\(userId)"
        } else {
            userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        }
    }
}

extension Post: Equatable & Hashable {
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.userId == rhs.userId &&
            lhs.title == rhs.title &&
            lhs.body == rhs.body &&
            lhs.creationDate == rhs.creationDate
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(uuid)
     }
}
