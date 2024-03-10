//
//  TimeTableDatabase.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/3/24.
//

import Foundation

struct SingleTimeTableDatabase: Codable {
    let status: String
    let data: SingleTimeTableData
}

struct MultipleTimeTableDatabase: Codable {
    let status: String
    let data: MultipleTimeTableData
}

struct SingleTimeTableData: Codable {
    let id: Int
    let title: String
    let isMain: Bool
    let isPublic: Bool
    let year: Int
    let season: String   // "SPRING"
    let schedules: [CourseDatabase]
}

struct MultipleTimeTableData: Codable {
    let timeTableMap: [String: [SingleTimeTableData]]
}

struct CourseDatabase: Codable {
    let title: String
    let memo: String
    let alphabetGrade: String
    let credit : CGFloat
    let isMajor: Bool
    let majorDepartment: String
    let professor: String
    let location: String
    let courseId : Int
    let dayOfWeekTimePairs: [DayOfWeekTimeParis]
}

struct DayOfWeekTimeParis: Codable {
    let dayOfWeek: String
    let startTime: String  // 00:00:00
    let endTime: String
}


