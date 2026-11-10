//
//  TransmitterSlot.swift
//  G6SensorKit
//
//  Copyright © 2026 Nightscout Foundation. MIT License.
//
//  The slot values follow xDrip+ (`endByteStd` 0x02, `endByteAlt` 0x01) and
//  xDrip4iOS (0x03 on Anubis transmitters). No code copied.
//

import Foundation

/// The display slot requested in the last byte of the authentication request.
///
/// A G6 transmitter keeps one connection per slot, so two devices can read it
/// at the same time when each authenticates on its own slot. Stock
/// transmitters have the phone app and receiver-or-pump slots; Anubis
/// firmware adds a third.
public enum TransmitterSlot: UInt8, CaseIterable {
    /// The slot the Dexcom phone app uses. The default.
    case phoneApp = 0x02

    /// The slot a Dexcom receiver or a pump reading the transmitter uses.
    case receiverOrPump = 0x01

    /// A third slot only Anubis firmware accepts.
    case anubisExtra = 0x03

    public static let `default`: TransmitterSlot = .phoneApp

    /// The slots a transmitter accepts, default first.
    public static func available(isAnubis: Bool) -> [TransmitterSlot] {
        isAnubis ? [.phoneApp, .receiverOrPump, .anubisExtra] : [.phoneApp, .receiverOrPump]
    }

    /// The slot to authenticate on: a stored Anubis slot falls back to the
    /// default on a transmitter not (yet) known to be Anubis.
    public func resolved(isAnubis: Bool) -> TransmitterSlot {
        Self.available(isAnubis: isAnubis).contains(self) ? self : .default
    }
}
