//
//  Post.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
