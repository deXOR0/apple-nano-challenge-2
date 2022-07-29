//
//  SessionComponent.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 25/07/22.
//

import Foundation
import SwiftUI

struct SessionHomeComponent: View {
    
    var session: Session
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 219, height: 79)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 2)
                .padding(4)
            HStack(spacing: 9) {
                ZStack {
                    Circle().fill(Color.primaryColor).frame(width: 58, height: 58)
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .resizable()
                        .frame(width: 38, height: 28)
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    Text(SessionModel.formatDateString(session.startDate!)).font(.system(size: 12))
                    Text(SessionModel.formatTimeString(session.startDate!, session.endDate!)).font(.system(size: 12))
                    HStack(spacing: 4) {
                        let (hour, minute, second) = SessionModel.getTimeDifference(session.startDate!, session.endDate!)
                        if hour > 0 {
                            Text(String(hour)).bold().font(.system(size: 12))
                            Text("hours").font(.system(size: 12))
                        }
                        if minute > 0 {
                            Text(String(minute)).bold().font(.system(size: 12))
                            Text("minutes").font(.system(size: 12))
                        }
                        if hour <= 0{
                            Text(String(second)).bold().font(.system(size: 12))
                            Text("seconds").font(.system(size: 12))
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("Session Home Component")
        }
    }
}
