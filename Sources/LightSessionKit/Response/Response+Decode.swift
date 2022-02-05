//
//  Response+Decode.swift
//  
//
//  Created by Marcen, Rafael on 6/2/22.
//

import Combine

extension Response {
    
    /// Decodes the output from the upstream using a specified decoder.
    ///
    /// - Parameters:
    ///   - type: The encoded data to decode into a struct that conforms to the Decodable protocol.
    ///   - decoder: A decoder that implements the TopLevelDecoder protocol.
    /// - Returns: The decoded data.
    public func decode<Item, Coder>(_ type: Item.Type, decoder: Coder) throws -> Item? where Item : Decodable, Coder : TopLevelDecoder {
        guard let input = self.data as? Coder.Input else {
            return nil
        }
        return try decoder.decode(type, from: input)
    }
}
