//
//  JourneyResponse.swift
//  exploreTest
//
//  Created by Siddharth Chaudhary on 29/11/24.
//

import Foundation

struct JourneyResponse: Codable {
    let status: Bool?
    let data: [Journey]?
    let totalPages: Int?
    let premiumStatus: Int?
    let problemFilter: [ProblemFilter]?

    enum CodingKeys: String, CodingKey {
        case status
        case data
        case totalPages = "total_pages"
        case premiumStatus = "premium_status"
        case problemFilter = "problem_filter"
    }

    init(status: Bool? = nil, data: [Journey]? = nil, totalPages: Int? = nil, premiumStatus: Int? = nil, problemFilter: [ProblemFilter]? = nil) {
        self.status = status
        self.data = data
        self.totalPages = totalPages
        self.premiumStatus = premiumStatus
        self.problemFilter = problemFilter
    }
}

struct Journey: Codable {
    let id: Int?
    let title: String?
    let juLabel: String?
    let promoText: String?
    let description: String?
    let juType: String?
    let juPremium: String?
    let numDays: Int?
    let thumbImage: String?
    let coverImage: String?
    let juLink: String?
    let problems: [String]?
    let techniques: [String]?
    let days: [Day]?
    let details: String?
    let sessions: String?
    let mins: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, problems, techniques, days, details, sessions, mins
        case juLabel = "ju_label"
        case promoText = "promo_text"
        case juType = "ju_type"
        case juPremium = "ju_premium"
        case numDays = "num_days"
        case thumbImage = "thumb_image"
        case coverImage = "cover_image"
        case juLink = "ju_link"
    }

    init(id: Int? = nil, title: String? = nil, juLabel: String? = nil, promoText: String? = nil, description: String? = nil, juType: String? = nil, juPremium: String? = nil, numDays: Int? = nil, thumbImage: String? = nil, coverImage: String? = nil, juLink: String? = nil, problems: [String]? = nil, techniques: [String]? = nil, days: [Day]? = nil, details: String? = nil, sessions: String? = nil, mins: String? = nil) {
        self.id = id
        self.title = title
        self.juLabel = juLabel
        self.promoText = promoText
        self.description = description
        self.juType = juType
        self.juPremium = juPremium
        self.numDays = numDays
        self.thumbImage = thumbImage
        self.coverImage = coverImage
        self.juLink = juLink
        self.problems = problems
        self.techniques = techniques
        self.days = days
        self.details = details
        self.sessions = sessions
        self.mins = mins
    }
}

struct Day: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let numSteps: Int?
    let dayCompleted: String?
    let completedSteps: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case numSteps = "num_steps"
        case dayCompleted = "day_completed"
        case completedSteps = "completed_steps"
    }

    init(id: Int? = nil, title: String? = nil, description: String? = nil, numSteps: Int? = nil, dayCompleted: String? = nil, completedSteps: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.numSteps = numSteps
        self.dayCompleted = dayCompleted
        self.completedSteps = completedSteps
    }
}

struct ProblemFilter: Codable, Equatable {
    let title: String?
    let id: Int?

    init(title: String? = nil, id: Int? = nil) {
        self.title = title
        self.id = id
    }
}
