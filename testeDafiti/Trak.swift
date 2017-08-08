//
//  TraktWrapper.swift
//  testeDafiti
//
//  Created by Marcelo Roberto Pavani on 07/08/17.
//  Copyright © 2017 Marcelo Pavani. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct Trakt{
    
    //let fanart = FanartWrapper()
    
    let clientID = "ec1e191bd9d54bf405407b571f01e61d8c3d390b2cd4aea2f438789a8e5a0624"
    var headers: [String: String] {
        return ["traskt-api-version": "2","trakt-api-key": clientID]
    }
    
    func requestTrendingMovies(_ completion: @escaping (([Movie]) -> Void)) {
        let requestUrlString = "https://api.trakt.tv/movies/trending?page=1&limit=500&extended=full,images"
        let requestUrl = try! requestUrlString.asURL()
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            guard response.result.isSuccess else { print("Error while fetching tags: \(String(describing: response.result.error))"); return }
            guard let responseValue = response.result.value as? [[String: AnyObject]] else { print("Invalid tag info!"); return }
            
            let json = JSON(responseValue)
            let movies = self.parseMovieJson(json)
            
            completion(movies)
        }
    }
    
    func parseMovieJson(_ json: JSON) -> [Movie] {
        var movies = [Movie]()
        for (_,movieSubJson):(String, JSON) in json {
            let newMovie = Movie()
            
            newMovie.title = movieSubJson["movie"]["title"].stringValue
            newMovie.slug = movieSubJson["movie"]["ids"]["slug"].stringValue
            newMovie.tmdb = movieSubJson["movie"]["ids"]["tmdb"].intValue
            newMovie.imdb = movieSubJson["movie"]["ids"]["imdb"].intValue
            newMovie.rating = movieSubJson["movie"]["rating"].doubleValue
            newMovie.summary = movieSubJson["movie"]["overview"].stringValue
            
            newMovie.genres = [String]()
            for (_, genreSubJson):(String, JSON) in movieSubJson["movie"]["genres"] {
                newMovie.genres?.append(genreSubJson.stringValue)
            }
            movies.append(newMovie)
        }
        return movies
    }
}
