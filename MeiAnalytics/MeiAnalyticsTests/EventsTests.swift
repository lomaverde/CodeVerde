//
//  EventsTests.swift
//  MeiAnalyticsTests
//
//  Created by Mei Yu on 11/2/24.
//

import Testing
@testable import MeiAnalytics

struct EventsTests {

    @Test func testImmediateEvent() async throws {
        var event1 = ImmediateEvent(type: "test1")
        event1.payload.set("string1", "Strin value 1")
        event1.payload.set("int1", 100)
        event1.payload.set("bool1", true)
        event1.log()
        
        print(event1.debugInfo())
        
        let data1 = try event1.encodedData()
        
        let decodedEvent1 = try event1.decode(data: data1)
        
        // Validate that the decoded instance matches the original
        #expect(event1.type == decodedEvent1.type)
        #expect(event1.timestamp.hasSameInterval(as: decodedEvent1.timestamp))
        #expect(event1.payload == decodedEvent1.payload)
        print(decodedEvent1.debugInfo())
    }
    
    @Test func testDurationEvent() async throws {
        var event1 = DurationEvent(type: "test1")
        event1.start()
        event1.payload.set("string1", "Strin value 1")
        event1.payload.set("int1", 100)
        event1.payload.set("bool1", true)
        
        var dummyValue = 0.00000009999
        for i in 0..<1000000 {
            dummyValue += Double(i) * dummyValue
        }
        event1.log()
        
        print(event1.debugInfo())
        
        let data1 = try event1.encodedData()
        
        let decodedEvent1 = try event1.decode(data: data1)
        
        // Validate that the decoded instance matches the original
        #expect(event1.type == decodedEvent1.type)
        #expect(event1.timestamp.hasSameInterval(as: decodedEvent1.timestamp))
        #expect(event1.payload == decodedEvent1.payload)
        print(decodedEvent1.debugInfo())
    }
}

extension Date {
    func hasSameInterval(as other: Date) -> Bool {
        Int(timeIntervalSince1970) == Int(other.timeIntervalSince1970)
    }
}
