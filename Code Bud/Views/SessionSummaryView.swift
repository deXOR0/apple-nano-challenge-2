//
//  SessionSummaryView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 28/07/22.
//

import SwiftUI

struct SessionSummaryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    var startDate: Date
    var endDate: Date
    var codingDuration: Int
    var breakCount: Int
    var breakDuration: String
    @State var journal: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack(spacing: 34) {
                    
                    VStack {
                        Text(formatDate(startDate))
                            .font(.system(size: 14))
                        Text(getTotalDuration())
                            .font(.system(size: 50))
                            .bold()
                    }
                    
                    CapsuleComponent(title: "Coding duration", value: getCodingDuration())
                    CapsuleComponent(title: "Breaks", value: "\(breakCount) times")
                    CapsuleComponent(title: "Break duration", value: "\(breakDuration) min")
                    
                    VStack {
                        HStack {
                            Text("Journal")
                            Spacer()
                        }
                        TextEditor(text: $journal)
                            .padding()
                            .frame(height: 213)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                            )
                    }
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: 35, leading: 24, bottom: 35, trailing: 24))
            }
            .navigationTitle("Session Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.primaryColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveSessionData()
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                    } label: {
                        Text("Save")
                            .foregroundColor(Color.primaryColor)
                    }
                }
            }
        }
    }
    
    func saveSessionData() {
        let session = Session(context: viewContext)
        session.startDate = self.startDate
        session.endDate = self.endDate
        session.breakCount = Int16(self.breakCount)
        session.breakDuration = Int64(self.breakCount)
        session.codingDuration = Int64(self.codingDuration)
        
        try? viewContext.save()
    }
    
    func getCodingDuration() -> String {
        var secondsLeft = self.codingDuration
        let hours = secondsLeft / 3600
        secondsLeft %= 3600
        let minutes = secondsLeft / 60
        secondsLeft %= 60
        let seconds = secondsLeft
        
        return formatTime([hours, minutes, seconds].map {String($0)})
    }
    
    func getTotalDuration() -> String {
        let diff = self.endDate.timeIntervalSince1970 - self.startDate.timeIntervalSince1970
        
        var secondsLeft = Int(diff)
        let hours = secondsLeft / 3600
        secondsLeft %= 3600
        let minutes = secondsLeft / 60
        secondsLeft %= 60
        let seconds = secondsLeft
        
        return formatTime([hours, minutes, seconds].map {String($0)})
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy - HH.mm"
        return dateFormatter.string(from: date)
    }
    
    func formatTime(_ time: [String]) -> String {
        let hour = String(format: "%02d", Int(time[0])!)
        let minute = String(format: "%02d", Int(time[1])!)
        let second = String(format: "%02d", Int(time[2])!)
        
        return "\(hour):\(minute):\(second)"
    }
    
}

struct SessionSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SessionSummaryView(startDate: Date.now, endDate: Date.now, codingDuration: 3600, breakCount: 5, breakDuration: "5", journal: "")
    }
}
