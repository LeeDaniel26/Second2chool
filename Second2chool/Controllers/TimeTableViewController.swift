//
//  TimeTableViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/23/24.
//

import Elliotable
import DropDown
import UIKit

class TimeTableViewController: UIViewController, ElliotableDelegate, ElliotableDataSource {
    
    private var courseList = [ElliottEvent]()
    private var daySymbol: [String] = ["Monday", "Tuesday", "Wenesday", "Thursday", "Friday", "Saturday"]
        
    private var timetableList = [String]()
    
    let course_1 = ElliottEvent(
        courseId: "CS1101",
        courseName: "자료구조",
        roomName: "K203",
        professor: "박수용",
        courseDay: .tuesday,
        startTime: "15:00",
        endTime: "17:15",
        textColor: .white,
        backgroundColor: .systemCyan)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .yellow
        return scrollView
    }()
    // (매우 중요): scrollView의 subview의 height이 지정되어있지 않으면 subview는 보이지 않는다.
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .purple
        return view
    }()
    
    private let dropdownView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        return view
    }()
    
    private let dropdownViewLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose TimeTable"
        label.sizeToFit()
        label.backgroundColor = .purple
        return label
    }()
    
    private let timetableDropDown: DropDown = {
        let dropdown = DropDown()
        return dropdown
    }()
    
    private var elliotable: Elliotable = {
        let table = Elliotable()
        table.backgroundColor = .white
        table.borderWidth = 0.5
        table.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        table.borderCornerRadius = 0
        table.textEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        table.minimumCourseStartTime = 9
        table.courseItemTextSize = 11
        table.roomNameFontSize = 8
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(elliotable)
        
        elliotable.delegate = self
        elliotable.dataSource = self
        
        courseList = [course_1]
        
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAddSchedule))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeTableManager.shared.getMultipleTimeTable { decodedData in
            guard let decodedData = decodedData else {
                return
            }
            for timetable in decodedData.data.timeTableMap {
                self.timetableList.append(timetable.key)
            }
//            self.timetableDropDown.dataSource = self.timetableList
            self.timetableDropDown.dataSource = ["Apple", "Bar", "Canada"]
        }
    }
    
    @objc private func didTapTimeTableList() {
    }

    @objc private func didTapAddSchedule() {
        let vc = AddScheduleViewController()
        vc.title = "Add Schedule"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setDropDown() {
        
    }
    
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return courseList
    }
    
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        
    }
    
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        
    }
    
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return self.daySymbol[dayPerIndex]
    }
    
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return self.daySymbol.count
    }
}

extension TimeTableViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            elliotable.widthAnchor.constraint(equalTo: view.widthAnchor),
            elliotable.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            elliotable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            elliotable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            elliotable.topAnchor.constraint(equalTo: contentView.topAnchor),
            elliotable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
