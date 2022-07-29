//
//  CapsuleComponent.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 28/07/22.
//

import SwiftUI

struct CapsuleComponent: View {
    
    let title: String
    let value: String
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 352, height: 40)
                .foregroundColor(Color.white)
                .shadow(color: .black, radius: 2, x: 0, y: 2)
            HStack {
                Text(title)
                    .font(.system(size: 18))
                Spacer()
                Text(value)
                    .font(.system(size: 18))
                    .bold()
            }
            .padding()
        }
    }
}

struct CapsuleComponent_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleComponent(title: "Coding Duration", value: "04:00:00")
    }
}
