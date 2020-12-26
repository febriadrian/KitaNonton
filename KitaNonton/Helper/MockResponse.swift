//
//  MockResponse.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

func getMockResponse<T: Decodable>(mock: MockRawJSON) -> T? {
    guard let data = mock.rawValue.data(using: .utf8), let response = try? jsonDecoder().decode(T.self, from: data) else {
        return nil
    }
    return response
}

enum MockRawJSON: String {
    case errorResponse = "{\"status_message\":\"The resource you requested could not be found.\",\"status_code\":34}"
    
    case getReviewsSuccessResponse = "{\"id\":529203,\"results\":[{\"author\":\"SWITCH.\",\"content\":\"content sample\",\"id\":\"5fd2b373f92532003daae946\",\"created_at\":\"2020-12-10T23:46:59.538Z\",\"author_details\":{\"username\":\"maketheSWITCH\",\"avatar_path\":\"/klZ9hebmc8biG1RC4WmzNFnciJN.jpg\",\"name\":\"SWITCH.\",\"rating\":6},\"updated_at\":\"2020-12-19T18:43:35.679Z\",\"url\":\"https://www.themoviedb.org/review/5fd2b373f92532003daae946\"}],\"total_pages\":1,\"total_results\":1,\"page\":1}"
    
    case getMoviesSuccessResponse = "{\"results\":[{\"genre_ids\":[12,14,10751,16],\"adult\":false,\"backdrop_path\":\"/cjaOSjsjV6cl3uXdJqimktT880L.jpg\",\"id\":529203,\"original_title\":\"The Croods:A New Age\",\"vote_average\":8,\"popularity\":2847.0799999999999,\"poster_path\":\"/tK1zy5BsCt1J4OzoDicXmr0UTFH.jpg\",\"overview\":\"After leaving their cave, the Croods...\",\"title\":\"The Croods:A New Age\",\"original_language\":\"en\",\"vote_count\":603,\"release_date\":\"2020-11-25\",\"video\":false},{\"genre_ids\":[878],\"adult\":false,\"backdrop_path\":\"/zbD96UExL9hl8TNihhs16vTBPEn.jpg\",\"id\":733317,\"original_title\":\"Monsters of Man\",\"vote_average\":7.5999999999999996,\"popularity\":2583.2040000000002,\"poster_path\":\"/1f3qspv64L5FXrRy0MF8X92ieuw.jpg\",\"overview\":\"A robotics company vying to wi...\",\"title\":\"Monsters of Man\",\"original_language\":\"en\",\"vote_count\":76,\"release_date\":\"2020-11-19\",\"video\":false}],\"total_pages\":500,\"total_results\":10000,\"page\":1}"
    
    case getMovieDetailSuccessResponse = "{\"runtime\":131,\"status\":\"Released\",\"backdrop_path\":\"/zbD96UExL9hl8TNihhs16vTBPEn.jpg\",\"overview\":\"A robotics company vying to win a lucrat...\",\"title\":\"Monsters of Man\",\"vote_count\":77,\"tagline\":\"\",\"belongs_to_collection\":null,\"original_title\":\"Monsters of Man\",\"original_language\":\"en\",\"poster_path\":\"/1f3qspv64L5FXrRy0MF8X92ieuw.jpg\",\"production_countries\":[{\"name\":\"Australia\",\"iso_3166_1\":\"AU\"}],\"revenue\":0,\"homepage\":\"https://www.monstersofman.movie/\",\"video\":false,\"imdb_id\":\"tt6456326\",\"id\":733317,\"release_date\":\"2020-11-19\",\"budget\":1900000,\"popularity\":2583.2040000000002,\"genres\":[{\"id\":878,\"name\":\"Science Fiction\"}],\"production_companies\":[{\"logo_path\":null,\"id\":145307,\"origin_country\":\"\",\"name\":\"MRT Films Pty Ltd\"},{\"logo_path\":null,\"id\":145308,\"origin_country\":\"\",\"name\":\"11:11 Entertainment\"}],\"videos\":{\"results\":[{\"site\":\"YouTube\",\"id\":\"5f37f5d811c066003637cdc3\",\"size\":1080,\"iso_639_1\":\"en\",\"key\":\"Ada9SU8tShA\",\"iso_3166_1\":\"US\",\"name\":\"MONSTERS OF MAN OFFICIAL TRAILER\",\"type\":\"Trailer\"}]},\"vote_average\":7.5999999999999996}"
}
