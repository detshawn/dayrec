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
        
        // 앱 델리개이트 객체 읽기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        // 관리 객체 생성, 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(self.name.text, forKey: "workoutName")
        let workoutTags: [String] = self.tagSelectedListView.tagViews.map({$0.titleLabel?.text as! String})
        let workoutTagsAsString: String = workoutTags.description
        object.setValue(workoutTagsAsString, forKey: "workoutTags")
        object.setValue(self.contents.text, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // 영구 저장소에 커밋되고 나면 list 프로퍼티에 추가
        do {
            try context.save()
//            appDelegate.workoutList.append(object)
            appDelegate.workoutList.insert(object, at: 0) // in order to put it in the first row of TableView
            // 작성폼 화면을 종료하고 이전 화면으로 돌아감
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            context.rollback()
            alertMessage(message: "저장에 실패했습니다")
            return
        }
    }
}
