//
//  AnnotationViews.swift
//  MyTwitterApp
//
//  Created by admin on 20/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import MapKit

internal final class ClusterAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            if let clusterAnnotation = newValue as? MKClusterAnnotation {
                markerTintColor = .blue
                glyphText = "\(clusterAnnotation.memberAnnotations.count)"
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TweetAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if let tweetAnnotation = newValue as? TweetAnnotation {
                clusteringIdentifier = "tweet"
                displayPriority = .defaultHigh
                markerTintColor = .blue
                canShowCallout = true
                let callOutView = Bundle.main.loadNibNamed("CalloutView", owner: self, options: nil)?.first! as! CalloutView
                callOutView.userName.text = tweetAnnotation.userName
                callOutView.screenName.text = "@\(tweetAnnotation.screenName!)"
                callOutView.tweet.text = tweetAnnotation.tweet
                detailCalloutAccessoryView = callOutView
            }
        }
    }
}

class TweetAnnotation: MKPointAnnotation {
    
    var screenName: String?
    var userName: String?
    var tweet: String?
}
