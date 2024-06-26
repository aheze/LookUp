//
//  ContactMetadata.swift
//  LookUp
//
//  Created by Andrew Zheng (github.com/aheze) on 4/19/24.
//  Copyright © 2024 Andrew Zheng. All rights reserved.
//

import Foundation

struct ContactMetadata: Codable {
    // MARK: - Properties from Contacts

    var phoneNumber: String
    var name: String?
    var email: String?
    var birthdayMonth: Int?
    var birthdayDay: Int?
    var birthdayYear: Int?

    // MARK: - User-defined properties

    // pfp
    // bio+links

    // MARK: - AI-generated properties

    // links
    // hobbies
    // people
}
