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
}
