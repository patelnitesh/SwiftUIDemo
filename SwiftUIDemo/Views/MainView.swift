//
//  MainView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            PublicFeedView()
                .tabItem {
                    Label("Public Feed", systemImage: "list.dash")
                }
            SearchView()
                .tabItem {
                    Label("Search",systemImage: "magnifyingglass.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
