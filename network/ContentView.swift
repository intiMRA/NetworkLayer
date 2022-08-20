//
//  ContentView.swift
//  network
//
//  Created by Inti Albuquerque on 14/08/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Animes", destination: AnimesView())
                
                NavigationLink("Animals", destination: AnimalsView())
            }
        }
    }
}
