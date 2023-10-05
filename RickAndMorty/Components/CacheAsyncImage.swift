//
//  RemoteImage.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation
import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    
    @State var data: Data?
    
    private let urlString: String
    private let content: (Image) -> Content
    
    private let url: URL
    
    init(
        urlString: String,
        content: @escaping (Image) -> Content
    ) {
        self.urlString = urlString
        self.content = content
        
        self.url = URL(string: urlString) ?? URL(string: "https://rickandmortyapi.com/api/character/avatar/19.jpeg")!
    }
    
    var body: some View {
        VStack {
            if let image = ImageCache[url] {
                content(image)
            } else {
                if let data = data, let uiimage = UIImage(data: data) {
                    let image = Image(uiImage: uiimage)
                    cacheAndShowIt(image: image)
                } else {
                    content(Image("placeholder"))
                }
            }
        }.onAppear {
            fetchData()
        }
    }
    
    func cacheAndShowIt(image: Image) -> some View {
        ImageCache[url] = image

        return content(image)
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

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
