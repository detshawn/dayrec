//
//  WorkoutFormVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit
import TagListView
import CoreData

class WorkoutFormVC: UIViewController, UITextViewDelegate, TagListViewDelegate {
    
    lazy var defaultTags: Array<String> = {
        return ["chest", "core", "back", "legs", "shoulders", "triceps", "biceps"]
    }()
    @IBOutlet var name: UITextView!
    @IBOutlet var contents: UITextView!
    @IBOutlet var tagSelectedListView: TagListView!
    @IBOutlet var tagAllListView: TagListView!
    
    let systemTagColor = UIColor.systemGreen
    
    override func viewDidLoad() {
        initUI()
    }
    
    func initUI() {
        self.name.delegate = self
        self.contents.delegate = self
        self.tagSelectedListView.delegate = self
        self.tagAllListView.delegate = self
        
        self.tagAllListView.addTags(defaultTags)
        
        // set the cursor at the top text
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
        
        // 앱 델리개이트 객체 읽기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let data = WorkoutData()
        data.workoutName = self.name.text
        data.workoutTags = self.tagSelectedListView.tagViews.map({$0.titleLabel?.text as! String})
        data.contents = self.contents.text
        data.regdate = Date()
        
        if appDelegate.dao.insert(data) {
            self.navigationController?.popViewController(animated: true)
        } else {
            alertMessage(message: "저장에 실패했습니다")
        }
    }
}
