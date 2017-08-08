//
//  Movie.swift
//  testeDafiti
//
//  Created by Marcelo Roberto Pavani on 07/08/17.
//  Copyright © 2017 Marcelo Pavani. All rights reserved.
//

import Foundation
import UIKit

class Movie: NSObject, NSCoding {
    
    var title: String?
    var slug: String?
    var tmdb: Int?
    var imdb: Int?
    var genres: [String]?
    var rating: Double?
    var summary: String?
    var posterUrl: String?
    var bannerUrl: String?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
            let slug = aDecoder.decodeObject(forKey: "slug") as? String,
            let tmdb = aDecoder.decodeObject(forKey: "tmdb") as? Int,
            let imdb = aDecoder.decodeObject(forKey: "imdb") as? Int,
            let genres = aDecoder.decodeObject(forKey: "genres") as? [String],
            let summary = aDecoder.decodeObject(forKey: "summary") as? String,
            let posterUrl = aDecoder.decodeObject(forKey: "posterUrl") as? String,
            let bannerUrl = aDecoder.decodeObject(forKey: "bannerUrl") as? String
            else { return nil }
        
        self.title = title
        self.slug = slug
        self.tmdb = tmdb
        self.imdb = imdb
        self.genres = genres
        self.rating = aDecoder.decodeDouble(forKey: "rating")
        self.summary = summary
        self.posterUrl = posterUrl
        self.bannerUrl = bannerUrl
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(slug, forKey: "slug")
        aCoder.encode(tmdb, forKey: "tmdb")
        aCoder.encode(imdb, forKey: "imdb")
        aCoder.encode(genres, forKey: "genres")
        if rating != nil {
            aCoder.encode(rating!, forKey: "rating")
        }
        aCoder.encode(summary, forKey: "summary")
        aCoder.encode(posterUrl, forKey: "posterUrl")
        aCoder.encode(bannerUrl, forKey: "bannerUrl")
    }
    
}
