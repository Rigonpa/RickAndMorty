//
//  ExampleView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 26/9/23.
//

import SwiftUI

struct ExampleView: View {
    
    @StateObject private var vm: ExampleViewModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: ExampleViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView(isPremium: true)
    }
}
