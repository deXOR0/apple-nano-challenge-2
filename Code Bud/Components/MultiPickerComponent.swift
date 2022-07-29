//
//  MultiPickerComponent.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import SwiftUI

struct MultiPickerComponent: View  {

    typealias Label = String
    typealias Entry = String

    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: self.data[column].1[row])
                            .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
    }
}
