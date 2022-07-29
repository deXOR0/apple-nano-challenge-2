//
//  TodayTotalSession.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 29/07/22.
//

import SwiftUI

struct TodayTotalSessionComponent: View {
    
    var sessions: FetchedResults<Session>
    @State var totalDuration: Int = 0
    @State var totalUnit: String = "hours"
    
    var body: some View {
        HStack {
            Text(String(self.totalDuration)).bold().font(.system(size: 48))
            Text("\(self.totalUnit) of coding").padding(.top)
        }
        .onAppear {
            print("Today Total Session")
            getSessionTotal()
        }
    }
    
    func getSessionTotal() {
        var totalHours: Int = 0
        var totalMinutes: Int = 0
        var totalSeconds: Int = 0
        sessions
            .filter {
                $0.startDate! > Calendar.current.startOfDay(for: Date.now)
            }
            .forEach { session in
                let (hours, minutes, seconds) = SessionModel.getTimeDifference(session.startDate!, session.endDate!)
                totalHours += hours
                totalMinutes += minutes
                totalSeconds += seconds
        }
        
        if totalHours > 0 {
            self.totalDuration = totalHours
            self.totalUnit = "hours"
        }
        else if totalMinutes > 0 {
            self.totalDuration = totalMinutes
            self.totalUnit = "minutes"
        }
        else if totalSeconds > 0 {
            self.totalDuration = totalSeconds
            self.totalUnit = "seconds"
        }
        else {
            self.totalDuration = 0
            self.totalUnit = "hours"
        }
        
    }
}
