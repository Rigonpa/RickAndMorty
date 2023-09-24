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
    var isList: Bool
    var color: Color? = nil
    
    var body: some View {
        if let data = data, let image = UIImage(data: data) {
            if isList {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 72)
                    .background(Color.gray)
                    .cornerRadius(8)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 260, alignment: .top)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(color ?? .white, lineWidth: 4)
                    )
                    .cornerRadius(32)
            }
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 72)
                .foregroundColor(Color.gray.opacity(0.4))
                .cornerRadius(8)
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
