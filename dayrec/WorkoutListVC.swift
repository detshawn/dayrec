//
//  WorkoutListVC.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/08.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit
import CoreData
import TagListView

class WorkoutListVC: UITableViewController {
    // 앱 델리게이트 참조 정보를 가져옴
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        self.initUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func initUI() {
        // navigation bar UI
        self.navigationItem.leftBarButtonItem = self.editButtonItem // edit button
    }
    
    @objc func editing(_ sender: Any) {
        self.tableView.setEditing(true, animated: true)
        
        // 셀을 스와이프했을 때 해당 셀만 편집 모드가 되도록 설정
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    //  뷰가 화면에 출력되면 호출
    override func viewWillAppear(_ animated: Bool) {
        // load the data from CoreData
        self.appDelegate.workoutList = self.appDelegate.dao.fetch()
        
        // reload the table data
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.workoutList.count
    }

    // 개별 행을 구성하는 메서드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // workoutList 배열에서 주어진 행에 맞는 데이터를 꺼냄
        let row = self.appDelegate.workoutList[indexPath.row]
                
        // 이미지 속성이 비어 있고 없고에 따라 프로토타입 셀 식별자를 변경
        let cellId = "workoutCell"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달 받음
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkoutCell

        // 내용 구성
        cell.workoutName?.text = row.workoutName
        cell.workoutTags?.removeAllTags() // is it the best way?..
        cell.workoutTags?.addTags(row.workoutTags!)
        
        // Date 타입의 날짜를 포멧에 맞게 변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.regdate?.text = formatter.string(from: row.regdate!)

        return cell
    }
    
    // 테이블 행을 선택하면 호출되는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // workoutList 에서 선택된 행에 맞는 데이터를 꺼냄
        let row = self.appDelegate.workoutList[indexPath.row]
        
        // 상세 화면 인스턴스 생성
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutRead") as? WorkoutReadVC else {
            return
        }
        
        // 값을 전달한 다음 상세 화면으로 이동
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: - delete a cell
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.workoutList[indexPath.row]
        
        if self.appDelegate.dao.delete(data.objectID!) {
            // 코어 데이터에서 삭제되면 배열 목록과 테이블 뷰의 행도 삭제
            self.appDelegate.workoutList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
