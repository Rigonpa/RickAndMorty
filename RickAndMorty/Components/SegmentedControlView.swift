//
//  SegmentedControlView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import SwiftUI

struct SegmentedControlView: View {
    
    @State var currentStatus: Status
    var statusValues: [Status]
    var onChange: ((Status) -> Void)? = nil
    
    var body: some View {
        Picker("", selection: $currentStatus) {
            ForEach(statusValues, id: \.self) {
                Text($0.rawValue)
                    .font(.caption)
                    .textCase(.uppercase)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: currentStatus) { newStatus in
            onChange?(newStatus)
        }
    }
}
