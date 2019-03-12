//
//  Models.swift
//  MyTwitterApp
//
//  Created by admin on 19/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation
import CoreLocation

struct Search: Decodable {
    
    let tweets: [Tweet]
    
    private enum CodingKeys: String, CodingKey {
        case tweets = "statuses"
    }
}

struct Tweet: Decodable, Equatable {
    
    let tweetText: String
    let user: User
    var coordinate: CLLocationCoordinate2D?
    
    private enum CodingKeys: String, CodingKey {
        case tweetText = "text"
        case user
        case coordinates
    }
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = nil
        if let coords = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .coordinates) {
            let coordinates = try coords.decode([Double].self, forKey: .coordinates)
            coordinate = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        }
        user = try container.decode(User.self, forKey: .user)
        tweetText = try container.decode(String.self, forKey: .tweetText)
    }
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.tweetText == rhs.tweetText && lhs.user == rhs.user
    }
}

struct User: Decodable, Equatable {

    var name: String
    let profilePicUrl: String
    let screenName: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case profilePicUrl = "profile_image_url_https"
        case screenName = "screen_name"
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.screenName == rhs.screenName
    }
}
