//
//  Icon.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

struct Icon: Codable {
    var attribution: String
    var attributionPreviewUrl: String?
    var dateUploaded: String
    var id: String
    var isActive: String
    var isExplicit: String
    var licenseDescription: String
    var nounjiFree: String
    var permalink: String
    var previewUrl: String
    var previewUrl42: String
    var previewUrl84: String
    var sponsor: Sponsor
    var sponsorCampaignLink: String?
    var sponsorId: String
    var term: String
    var termId: Int
    var termSlug: String
    var updatedAt: String
    var uploader: Uploader
    var uploaderId: String
    var year: Int
    
    private enum CodingKeys : String, CodingKey {
        case attribution
        case attributionPreviewUrl = "attribution_preview_url"
        case dateUploaded = "date_uploaded"
        case id
        case isActive = "is_active"
        case isExplicit = "is_explicit"
        case licenseDescription = "license_description"
        case nounjiFree = "nounji_free"
        case permalink
        case previewUrl = "preview_url"
        case previewUrl42 = "preview_url_42"
        case previewUrl84 = "preview_url_84"
        case sponsor
        case sponsorCampaignLink = "sponsor_campaign_link"
        case sponsorId = "sponsor_id"
        case term
        case termId = "term_id"
        case termSlug = "term_slug"
        case updatedAt = "updated_at"
        case uploader
        case uploaderId = "uploader_id"
        case year
    }
}

struct Uploader: Codable {
    var location: String
    var name: String
    var permalink: String
    var username: String
}

struct Sponsor: Codable {
    
}

/*
 {
 "attribution": "Stool by John Winowiecki from Noun Project",
 "attribution_preview_url": "https://static.thenounproject.com/attribution/2621601-600.png",
 "date_uploaded": "2019-06-14",
 "id": "2621601",
 "is_active": "1",
 "is_explicit": "0",
 "license_description": "creative-commons-attribution",
 "nounji_free": "0",
 "permalink": "/term/stool/2621601",
 "preview_url": "https://static.thenounproject.com/png/2621601-200.png",
 "preview_url_42": "https://static.thenounproject.com/png/2621601-42.png",
 "preview_url_84": "https://static.thenounproject.com/png/2621601-84.png",
 "sponsor": {},
 "sponsor_campaign_link": null,
 "sponsor_id": "",
 "term": "Stool",
 "term_id": 2390,
 "term_slug": "stool",
 "updated_at": "2019-06-18 16:53:45",
 "uploader": {
     "location": "",
     "name": "John Winowiecki",
     "permalink": "/winowiecki",
     "username": "winowiecki"
 },
 "uploader_id": "82578",
 "year": 2019
 }
 */
