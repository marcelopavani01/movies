//
//  Fanart.swift
//  testeDafiti
//
//  Created by Marcelo Roberto Pavani on 07/08/17.
//  Copyright © 2017 Marcelo Pavani. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct Fanart {

    let apiKey = "79c425a2ff360315d863a24ff64dee1a"
    
    func requestThumbUrl(for movie: Movie, completion: @escaping ((URL) -> Void)) {
        let requestUrl = "http://webservice.fanart.tv/v3/movies/\(movie.tmdb!)?api_key=\(apiKey)"
        Alamofire.request(requestUrl).validate().responseJSON { (response) in
            
            let json = JSON(response.result.value ?? [])
            let banners = json["moviethumb"]
            let firstBanner = banners[0]
            let firstBannerUrlString = firstBanner["url"].stringValue
            if let firstBannerUrl = try? firstBannerUrlString.asURL() {
                completion(firstBannerUrl)
            }
        }
    }
}
