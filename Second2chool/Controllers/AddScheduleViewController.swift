//
//  AddScheduleViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/3/24.
//

import DropDown
import UIKit

class AddScheduleViewController: UIViewController {

    struct Constants {  // cornerRadius와 같은 view 속성값 수정을 쉽게 하기 위함
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let courseIdField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "courseID"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let courseNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "course name"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let roomNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "room name"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let professorField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "professor"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let courseDayField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.placeholder = "course day"
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let courseDaysDropDown: DropDown = {
        let dropdown = DropDown()
        dropdown.textColor = UIColor.black // 아이템 텍스트 색상
        dropdown.selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        dropdown.backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        dropdown.selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        dropdown.setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        return dropdown
    }()
    
    private let courseSecondDayField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.placeholder = "course day"
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let startTimeField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "start time"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let endTimeField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "end time"
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
        
    private let backgroundColorField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()

    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 10.0
        
        button.backgroundColor = .link
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(courseIdField)
        view.addSubview(courseNameField)
        view.addSubview(roomNameField)
        view.addSubview(professorField)
        view.addSubview(courseDayField)
        view.addSubview(startTimeField)
        view.addSubview(endTimeField)
        view.addSubview(createButton)
        
        createButton.addTarget(self,
                               action: #selector(didTapCreate),
                               for: .touchUpInside)
    }
    
    @objc private func didTapCreate() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.didReceiveMemoryWarning()
        
        courseIdField.frame = CGRect(
            x: 25,
            y: view.safeAreaInsets.top,
            width: view.width - 50,
            height: 52.0)
        courseNameField.frame = CGRect(
            x: 25,
            y: courseIdField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        roomNameField.frame = CGRect(
            x: 25,
            y: courseNameField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        professorField.frame = CGRect(
            x: 25,
            y: roomNameField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        courseDayField.frame = CGRect(
            x: 25,
            y: professorField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        courseSecondDayField.frame = CGRect(
            x: 25,
            y: courseDayField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        startTimeField.frame = CGRect(
            x: 25,
            y: courseSecondDayField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        endTimeField.frame = CGRect(
            x: 25,
            y: startTimeField.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        createButton.frame = CGRect(
            x: 25,
            y: endTimeField.bottom + 20,
            width: view.width - 50,
            height: 52.0)
    }
    
}
