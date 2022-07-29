//
//  AccordionComponent.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import SwiftUI

import SwiftUI

struct AccordionComponent<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        self.label()
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                    }
                    .padding(.bottom, 1)
                    .background(Color.white.opacity(0.01))
                }
            )
            .buttonStyle(PlainButtonStyle())
            
            VStack {
                self.content()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut)
            .transition(.slide)
        }
    }
}

struct AccordionComponent_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            AccordionComponent(
                label: {
                    Text("Hello")
                },
                content: {
                    Text("Testc ajdaksdjaksjdajdajlkaslkasjdklasjdklasjdjkasdaskdljaslkdasjdlaskdaklsdjaklsdjklasdjkladjklasdjakj")
                }
            )
            AccordionComponent(
                label: {
                    Text("Hello")
                },
                content: {
                    Text("Hello")
                }
            )
            Spacer()
        }
        .padding()
    }
}
