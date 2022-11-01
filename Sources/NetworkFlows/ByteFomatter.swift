//
//  ByteFomatter.swift
//  
//
//  Created by Jinyu Meng on 2022/07/30.
//

import Foundation

/// Number format to return.
public enum NumberStyle {
    case auto /// The default format for ByteCountFormatter. But without using "Zero".
    case consistent /// Same as auto but with zeroPadsFractionDigits enabled.
}

/// Unit format to return.
public enum UnitStyle {
    case full /// "MB", "KB", "KB/s"
    case short /// "M", "K", "K/s"
}

/// The internal formatter which NetworkFlow will use.
public class ByteFomatter {
    static let shared = ByteFomatter()
    
    /// Number format to use in results.
    public static var numberStyle = NumberStyle.auto
    /// Unit format to use in results.
    public static var unitStyle = UnitStyle.full
    
    func humanReadableNumber(_ byteCount: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowsNonnumericFormatting = false
        formatter.includesUnit = false
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        switch ByteFomatter.numberStyle {
        case .auto:
            return String(formatter.string(fromByteCount: byteCount))
        case .consistent:
            formatter.zeroPadsFractionDigits = true
            return String(formatter.string(fromByteCount: byteCount))
        }
    }
    
    func humanReadableNumberUnit(_ byteCount: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowsNonnumericFormatting = false
        formatter.includesCount = false
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        switch ByteFomatter.unitStyle {
        case .full:
            return String(formatter.string(fromByteCount: byteCount))
        case .short:
            return String(formatter.string(fromByteCount: byteCount).dropLast())
        }
    }
}
