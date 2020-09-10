//
//  WorkoutReadVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit

class WorkoutReadVC: UIViewController {
    
    var param: WorkoutData?

    @IBOutlet var subject: UILabel!
    @IBOutlet var contents: UILabel!
    
    override func viewDidLoad() {
        self.subject.text = param?.workoutName
        self.contents.text = param?.contents

        // 날짜 포멧 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분에 작성"
        let dateString = formatter.string(from: (param?.regdate)!)

        // 내비게이션 타이틀에 날짜 표시
        self.navigationItem.title = dateString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
