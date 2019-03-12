//
//  ViewModel.swift
//  MyTwitterApp
//
//  Created by admin on 19/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation
import CoreLocation

protocol ViewModelDelegate: class {
    func showAnnotationForTweet(_ tweet: Tweet)
}

class ViewModel {

    private var apiManager: ApiManger!
    private var tweets = [Tweet]()
    private var currentLatitude: CLLocationDegrees?
    private var currentLongitude: CLLocationDegrees?
    weak var delegate: ViewModelDelegate?
    
    init() {
        self.apiManager = ApiManger()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
            if self.currentLatitude != nil && self.currentLongitude != nil {
                self.fetchIntialTweet()
            }
        })
    }
    
    func setLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        currentLatitude = lat
        currentLongitude = lon
        fetchIntialTweet()
    }
    
    
    private func fetchIntialTweet() {
        let searchUrl = "https://api.twitter.com/1.1/search/tweets.json?q=a&count=50&result_type=recent&geocode=\(currentLatitude!),\(currentLongitude!),5km"
        self.apiManager.fetchGetPreviousTweets(urlString: searchUrl) { (tweets, error) in
            if error == nil {
                self.updateData(tweets!)
            }
        }
    }
    
    private func updateData(_ tweets: [Tweet]) {
        
        for newTweet in tweets {
            if !self.tweets.contains(newTweet) {
                self.tweets.append(newTweet)
                self.delegate?.showAnnotationForTweet(newTweet)
            }
        }
    }

}
