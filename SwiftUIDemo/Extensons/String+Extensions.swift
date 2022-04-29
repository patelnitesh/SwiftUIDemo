//
//  String+Extensions.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func convertToTimeInterval() -> TimeInterval {
        Double(self) ?? 0
    }
    
    func convertToDisplayDate() -> String {
        let dateTimeInterval = self.convertToTimeInterval()
        let date = Date(timeIntervalSince1970: dateTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY:MM:dd HH:MM:ss"

        return dateFormatter.string(from: date)
    }
}
