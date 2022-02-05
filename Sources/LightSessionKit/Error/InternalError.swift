//
//  InternalError.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

/// Error for internal purposes.
///
/// There errors are either programmatic issues or unknown failures which can not be explained to the user.
///
/// The error still contains a message for debugging purposes.
class InternalError: Error, CustomStringConvertible {

    /// The message describing the failure.
    let message: String

    /// Initializes the `InternalError`.
    ///
    /// - parameter message: The message describing the failure.
    init(_ message: String) {
        self.message = message
    }

    var description: String {
        return "InternalError: \(message)"
    }
}
