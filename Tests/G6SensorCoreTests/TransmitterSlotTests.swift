//
//  TransmitterSlotTests.swift
//  G6SensorKitTests
//
//  Copyright © 2026 Nightscout Foundation. MIT License.
//

import XCTest
@testable import G6SensorCore

class TransmitterSlotTests: XCTestCase {

    func testAuthRequestEndsWithSlot() {
        for slot in TransmitterSlot.allCases {
            let data = AuthRequestTxMessage(slot: slot).data
            XCTAssertEqual(data.count, 10)
            XCTAssertEqual(data.first, 0x01)
            XCTAssertEqual(data.last, slot.rawValue)
        }
    }

    func testDefaultAuthRequestUsesPhoneAppSlot() {
        XCTAssertEqual(AuthRequestTxMessage().data.last, 0x02)
    }

    func testAvailableSlots() {
        XCTAssertEqual(TransmitterSlot.available(isAnubis: false), [.phoneApp, .receiverOrPump])
        XCTAssertEqual(TransmitterSlot.available(isAnubis: true), [.phoneApp, .receiverOrPump, .anubisExtra])
    }

    func testAnubisSlotFallsBackOnStockTransmitter() {
        XCTAssertEqual(TransmitterSlot.anubisExtra.resolved(isAnubis: false), .phoneApp)
        XCTAssertEqual(TransmitterSlot.anubisExtra.resolved(isAnubis: true), .anubisExtra)
        XCTAssertEqual(TransmitterSlot.receiverOrPump.resolved(isAnubis: false), .receiverOrPump)
    }
}
