//
//  HomeView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 25/07/22.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var sessionStartSheet = false
    @State var sessionSummarySheet = false
    
    @State var selectedStartDate: Date = Date.now
    @State var selectedEndDate: Date = Date.now
    @State var selectedCodingDuration: Int = 0
    @State var selectedBreakCount: Int = 0
    @State var selectedBreakDuration: String = ""
    @State var selectedJournal: String = ""
    
    @FetchRequest(fetchRequest: Session.getRecentSessions(5))
    var recentSessions: FetchedResults<Session>
    
    @FetchRequest(fetchRequest: Session.getTodaySessions())
    var todaySessions: FetchedResults<Session>
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("Hi, User!").bold().font(.system(size: 16))
                }
                Text("Today, you have spent").padding([.top], 47)
                TodayTotalSessionComponent(sessions: todaySessions)
                HStack {
                    Text("Recent coding sessions")
                    Spacer()
                    Button {
                        print("See all")
                    } label : {
                        Text("See all")
                            .foregroundColor(Color.primaryColor)
                    }
                }
                .padding([.top], 27)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recentSessions) { session in
                            SessionHomeComponent(session: session)
                                .onTapGesture {
                                    gotoSessionSummaryView(session: session)
                                }
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        sessionStartSheet.toggle()
                    } label : {
                        Text("START")
                            .italic()
                            .bold()
                            .font(.system(size: 48))
                    }
                    .font(.largeTitle)
                    .padding()
                    .frame(width: 219, height: 219)
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .sheet(isPresented: $sessionStartSheet) {
                        SessionStartView()
                    }
                    .sheet(isPresented: $sessionSummarySheet) {
                        SessionSummaryView(startDate: self.selectedStartDate, endDate: self.selectedEndDate, codingDuration: self.selectedCodingDuration, breakCount: self.selectedBreakCount, breakDuration: self.selectedBreakDuration, journal: self.selectedJournal)
                    }
                    Spacer()
                }
                Spacer()
                
            }
            .padding([.leading, .trailing], 13)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .onAppear {
            NotificationHandler.requestAuthorization()
        }
    }
    
    func gotoSessionSummaryView(session: Session) {
        if let startDate = session.startDate {
            self.selectedStartDate = startDate
        }
        if let endDate = session.endDate {
            self.selectedEndDate = endDate
        }
        self.selectedCodingDuration = Int(session.codingDuration)
        self.selectedBreakCount = Int(session.breakCount)
        self.selectedBreakDuration = String(session.breakDuration)
        if let journal = session.journal {
            self.selectedJournal = journal
        }
                
        self.sessionSummarySheet = true
    }
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
