//
//  Mock.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import Foundation

class Mock {
    static func loadData(_ fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                debugPrint("loadData error:\(error)")
            }
        }
        return nil
    }
}
