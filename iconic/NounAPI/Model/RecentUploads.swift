//
//  RecentUploads.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

struct RecentUploads: Codable {
    var generatedAt: String
    var recentUploads: [Icon]
    
    private enum CodingKeys : String, CodingKey {
        case generatedAt = "generated_at"
        case recentUploads = "recent_uploads"
    }
}
