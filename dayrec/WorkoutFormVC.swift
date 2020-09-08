//
//  WorkoutFormVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit

class WorkoutFormVC: UIViewController, UITextViewDelegate {
    var subject: String!  // 메모 제목

    @IBOutlet var contents: UITextView!
    
    override func viewDidLoad() {
        self.contents.delegate = self
    }
    
    // MARK:- UITextViewDelegate
    // 텍스트 뷰의 내용이 변경될 때마다 호출됨
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 15자리까지 읽어 subject 변수에 저장
        let contents = textView.text as NSString
        let length = (contents.length > 15) ? 15 : contents.length
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        // 내비게이션 타이틀에 표시
        self.navigationItem.title = subject
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Save button
    @IBAction func save(_ sender: Any) {
        // 내용을 입력하지 않은경우 경고
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // MemoData 객체를 생성하고 데이터를 담음
        let data = WorkoutData()
        
        data.workoutName = self.subject                       // 제목
        data.contents = self.contents.text    // 내용
        data.partTag = ""      // 태그
        data.regdate = Date()                        // 작성 시각
        
        // 앱 델리개이트 객체를 읽어온 다음 memolist 배열에 MemoData 객체를 추가
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.workoutList.append(data)
        
        // 작성폼 화면을 종료하고 이전 화면으로 돌아감
        self.navigationController?.popViewController(animated: true)
    }
}
