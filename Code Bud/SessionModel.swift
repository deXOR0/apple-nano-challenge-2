//
//  Sessions.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 25/07/22.
//

import Foundation
import CoreData

struct SessionModel {
    var startTime: Date
    var endTime: Date
    
    static func buildDateTime(_ dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: dateString)!
    }
    
    static func formatDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func formatTimeString(_ startDate: Date, _ endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    static func getTimeDifference(_ startDate: Date, _ endDate: Date) -> (Int, Int, Int) {
        let diff = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        
        var seconds = Int(diff)
        let hours = seconds / 3600
        seconds %= 3600
        let minutes = seconds / 60
        seconds %= 60
        
        return (hours, minutes, seconds)
    }
}

extension Session {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func getRecentSessions(_ limit: Int) -> NSFetchRequest<Session> {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.startDate, ascending: false)]
        request.fetchLimit = limit
          
        return request
    }
    
    static func getTodaySessions() -> NSFetchRequest<Session> {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.startDate, ascending: false)]
        
        request.predicate = NSPredicate(format: "startDate >= %@", Calendar.current.startOfDay(for: Date.now) as CVarArg)
          
        return request
    }
}
