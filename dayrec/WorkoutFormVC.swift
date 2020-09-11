//
//  WorkoutFormVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit
import TagListView

class WorkoutFormVC: UIViewController, UITextViewDelegate, TagListViewDelegate {
    
    @IBOutlet var name: UITextView!
    @IBOutlet var contents: UITextView!
    @IBOutlet var tagSelectedListView: TagListView!
    @IBOutlet var tagAllListView: TagListView!
    
    let systemTagColor = UIColor.systemGreen
    
    override func viewDidLoad() {
        self.name.delegate = self
        self.contents.delegate = self
        self.tagSelectedListView.delegate = self
        self.tagAllListView.delegate = self
        
        self.tagAllListView.addTags(["chest", "core", "back", "legs", "shoulders", "triceps", "biceps"])
        
        self.name.becomeFirstResponder()
    }
    
    // MARK:- UITextViewDelegate
    // 텍스트 뷰의 내용이 변경될 때마다 호출됨
    func textViewDidChange(_ textView: UITextView) {
        if textView === self.name {
            // 내비게이션 타이틀에 표시
            self.navigationItem.title = textView.text
        } else {
            // handle other text views
            return
        }
    }
    
    // MARK:- TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        if sender === self.tagSelectedListView {
            print("Tag removed: \(title), \(sender)")
            self.tagSelectedListView.removeTag(title)
            self.tagAllListView.addTag(title)
        } else if sender === self.tagAllListView {
            print("Tag added: \(title), \(sender)")
            self.tagSelectedListView.addTag(title)
            self.tagAllListView.removeTag(title)
        } else {
            return
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
    
    private func alertMessage(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Save button
    @IBAction func save(_ sender: Any) {
        // 내용을 입력하지 않은경우 경고
        guard self.name.text?.isEmpty == false else {
            alertMessage(message: "운동 이름을 입력해주세요")
            return
        }

        guard self.contents.text?.isEmpty == false else {
            alertMessage(message: "내용을 입력해주세요")
            return
        }
        
        // MemoData 객체를 생성하고 데이터를 담음
        let data = WorkoutData()
        
        data.workoutName = self.name.text     // 제목
        data.workoutTags = self.tagSelectedListView.tagViews.map({$0.titleLabel?.text as! String})  // 태그
        data.contents = self.contents.text    // 내용
        data.regdate = Date()                 // 작성 시각
        
        // 앱 델리개이트 객체를 읽어온 다음 memolist 배열에 MemoData 객체를 추가
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.workoutList.append(data)
        
        // 작성폼 화면을 종료하고 이전 화면으로 돌아감
        self.navigationController?.popViewController(animated: true)
    }
}
