//
//  WorkoutData.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import Foundation

class WorkoutData {
    var workoutIdx: Int?        // 데이터 식별값
    var workoutName: String?           // 운동 종류
    var workoutTags: Array<String>?    // 운동 부위
    var regdate: Date?          // 작성일
    var contents: String?       // 메모 내용
}
