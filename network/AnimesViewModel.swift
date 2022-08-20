//
//  AnimesViewModel.swift
//  network
//
//  Created by Inti Albuquerque on 14/08/22.
//

import Foundation

struct AnimeInstanceModel: Decodable {
    let animeId: Int
    let animeName: String
    let animeImg: String
}

struct AnimeListModel: Decodable {
    let success: Bool
    let data: [AnimeInstanceModel]
}

@MainActor
class AnimesViewModel: ObservableObject {
    let url = "https://anime-facts-rest-api.herokuapp.com/api/v1"
    @Published var animeListModel: AnimeListModel?
    
    func fetchAnimes() async {
        do {
            self.animeListModel = try await DataFetcher.defaultDataFetcher.request(DataFetcherRequest(url: url, httpMethod: .GET))
        } catch {
            print(error)
        }
    }
}
