//
//  RemoteImage.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation
import SwiftUI

struct RemoteImage: View {
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 70)
                .background(Color.gray)
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 70)
                .background(Color.gray)
                .onAppear {
                    fetchData()
                }
        }
    }
    
    fileprivate func fetchData() {
        Task {
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            self.data = data
        }
    }
}
