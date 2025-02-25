//
//  WorkoutReadVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit
import TagListView

class WorkoutReadVC: UIViewController {
    
    var param: WorkoutData?

    @IBOutlet var subject: UILabel!
    @IBOutlet var contents: UILabel!
    @IBOutlet var workoutTags: TagListView!
    
    override func viewDidLoad() {
        initUI()
    }
    
    func initUI() {
        self.subject.text = param?.workoutName
        self.contents.text = param?.contents
        self.workoutTags.addTags((param?.workoutTags)!)

        // 날짜 포멧 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분에 작성"
        let dateString = formatter.string(from: (param?.regdate)!)

        // 내비게이션 타이틀에 날짜 표시
        self.navigationItem.title = dateString

        // set the button in the top-right corner
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(btnOnClick(_:)))
    }

    @objc func btnOnClick(_ sender: Any) {
        if let btn = sender as? UIBarButtonItem {
            // 상세 화면 인스턴스 생성
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutForm") as? WorkoutFormVC else {
                return
            }
            
            // 값을 전달한 다음 상세 화면으로 이동
            vc.param = self.param
            vc.status = .edit
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
