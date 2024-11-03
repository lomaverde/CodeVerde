//
//  EncodedContent.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A structure representing encoded event content with an associated timestamp.
/// This structure is useful when the content of the event needs to be enummtable
/// and encoded data is used for local storage and networking.
/// In the future, we can add more information such as retry, ID, etc.
struct EncodedContent: Codable {
    let timestamp: Date
    let debugSummary: String
    let encodedContent: Data
}
