//
//  ApiManger.swift
//  MyTwitterApp
//
//  Created by admin on 19/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import OAuthSwift

let consumerKey      = "cSxNXDc8n8CLZB9hq4zRz4yYQ"
let consumerSecret   = "VJMprCbqBBjDvG6SpJljJHRtGp7b9euRs6Q3BBIftenxvYtYM0"
let oauthToken       = "902943648462934016-QqF1ESNAtJf8DHFWkAKYkC1gIgqY8Le"
let oauthTokenSecret = "DcDRqmAMENx0pC1MKteB6YK1JtiJthJYuyHQqpap5Rl7V"

class ApiManger {

    private let oauth: OAuth1Swift = {
        let oauth = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: consumerSecret
        )
        oauth.client.credential.oauthToken = oauthToken
        oauth.client.credential.oauthTokenSecret = oauthTokenSecret
        return oauth
    }()
    
    func fetchGetPreviousTweets(urlString: String, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> Void) {
    
        let _ = oauth.client.get(urlString, success: { (response) in
            do {
                let decoder = JSONDecoder()
                let search = try decoder.decode(Search.self, from: response.data)
                completion(search.tweets, nil)
                
            } catch let error {
                completion(nil, error)
            }
        }) { (error) in
            
            completion(nil, error)
        }
    }

}
