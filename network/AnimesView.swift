//
//  AnimesView.swift
//  network
//
//  Created by Inti Albuquerque on 14/08/22.
//

import SwiftUI

struct AnimesView: View {
    @StateObject var viewModel = AnimesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.animeListModel?.data ?? [], id: \.animeId) { anime in
                Text(anime.animeName)
                AsyncImage(url: URL(string: anime.animeImg), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100, maxHeight: 100)
                },
                           placeholder: {
                    ProgressView()
                })
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAnimes()
            }
        }
    }
}
