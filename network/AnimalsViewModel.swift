//
//  AnimalsViewModel.swift
//  network
//
//  Created by Inti Albuquerque on 14/08/22.
//

import Foundation
//https://zoo-animal-api.herokuapp.com/animals/rand/10

struct AnimalModel: Codable, Identifiable {
    let name: String
    let latinName: String
    let animalType: String
    let activeTime: String
    let lengthMin: String
    let lengthMax: String
    let weightMin: String
    let weightMax: String
    let lifespan: String
    let habitat: String
    let diet: String
    let geoRange: String
    let imageLink: String
    let id: Int
}

@MainActor
class AnimalsViewModel: ObservableObject {
    let url = "https://zoo-animal-api.herokuapp.com/animals/rand/10"
    @Published var list: [AnimalModel]?
    
    func fetchAnimals() async {
        do {
            let request = DataFetcherRequest(url: url, httpMethod: .GET)
            list = try await DataFetcher.defaultDataFetcher.request(request)
        } catch {
            print(error)
        }
    }
}
