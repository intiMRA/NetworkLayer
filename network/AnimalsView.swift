//
//  AnimalsView.swift
//  network
//
//  Created by Inti Albuquerque on 14/08/22.
//

import SwiftUI

struct AnimalsView: View {
    @StateObject var viewModel = AnimalsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.list ?? []) {  animal in
                VStack {
                    Text(animal.name)
                    
                    AsyncImage(url: URL(string: animal.imageLink), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100, maxHeight: 100)
                },
                           placeholder: {
                    ProgressView()
                })
            }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAnimals()
            }
        }
    }
}
