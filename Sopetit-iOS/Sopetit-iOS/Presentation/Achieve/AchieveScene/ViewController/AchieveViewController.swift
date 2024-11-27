//
//  AchieveViewController.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 5/27/24.
//

import UIKit

import SnapKit
import FSCalendar

final class AchieveViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedDate: Date?
    private var selectedMonth: Int?
    private var formatter = DateFormatter()
    
    // MARK: - UI Components
    
    private var achieveView = AchieveView()
    private lazy var calendarView = achieveView.achieveCalendarView
    private lazy var calendarHeaderView = achieveView.calendarHeaderView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = achieveView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddGesture()
        setRegisterCell()
        setDelegate()
        updateCalendarHeaderButton()
    }
}

// MARK: - Extensions

extension AchieveViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let today = Date()
        selectedDate = today
        calendarView.select(today)
    }
    
    func setAddGesture() {
        let tapStatsMenu = UITapGestureRecognizer(target: self,
                                                  action: #selector(statsMenuTapped))
        let tapCalendarMenu = UITapGestureRecognizer(target: self,
                                                     action: #selector(calendarMenuTapped))
        achieveView.achieveMenuView.statsMenuView.addGestureRecognizer(tapStatsMenu)
        achieveView.achieveMenuView.calendarMenuView.addGestureRecognizer(tapCalendarMenu)
    }
    
    func setRegisterCell() {
        calendarView.register(CalendarDateCell.self,
                              forCellReuseIdentifier: CalendarDateCell.className)
    }
    
    func setDelegate() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarHeaderView.delegate = self
    }
    
    @objc
    func statsMenuTapped() {
        achieveView.achieveMenuView.setAchieveMenuTapped(statsTapped: true)
    }
    
    @objc
    func calendarMenuTapped() {
        achieveView.achieveMenuView.setAchieveMenuTapped(statsTapped: false)
    }
    
    func updateCalendarHeaderButton() {
        let calendar = Calendar.current
        let currentPage = calendarView.currentPage
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let registerDate = dateFormatter.date(from: "2024-04-06") else { return }
        
        if currentPage <= calendar.date(from: calendar.dateComponents([.year, .month], from: registerDate))! {
            calendarHeaderView.setHeaderLeftButton(state: false)
        } else {
            calendarHeaderView.setHeaderLeftButton(state: true)
        }
        
        if currentPage >= calendar.date(from: calendar.dateComponents([.year, .month], from: today))! {
            calendarHeaderView.setHeaderRightButton(state: false)
        } else {
            calendarHeaderView.setHeaderRightButton(state: true)
        }
    }
}

extension AchieveViewController: CalendarHeaderDelegate {
    
    func tapLeftButton() {
        let calendar = Calendar.current
        let currentPage = calendarView.currentPage
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentPage) {
            calendarView.setCurrentPage(previousMonth, animated: true)
            selectedMonth = calendar.component(.month, from: previousMonth)
        }
        updateCalendarHeaderButton()
        calendarView.reloadData()
    }
    
    func tapRightButton() {
        let calendar = Calendar.current
        let currentPage = calendarView.currentPage
        if let nextMonth = calendar.date(byAdding: .month,
                                         value: 1,
                                         to: currentPage) {
            calendarView.setCurrentPage(nextMonth, animated: true)
            selectedMonth = calendar.component(.month, from: nextMonth)
        }
        updateCalendarHeaderButton()
        calendarView.reloadData()
    }
}

extension AchieveViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar,
                  cellFor date: Date,
                  at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.className,
                                                      for: date,
                                                      at: position) as? CalendarDateCell
        else { return FSCalendarCell() }
        let bindDay = Calendar.current.component(.day, from: date)
        let bindMonth = Calendar.current.component(.month, from: date)
        let bindYear = Calendar.current.component(.year, from: date)
        let dayString = String(bindDay)
        selectedMonth = bindMonth
        
        let calendar = Calendar.current
        let today = calendar.component(.day, from: Date())
        let month = calendar.component(.month, from: Date())
        
        var bindDataType: CalendarDateType = .nonSelected
        var bindIconType: CalendarIconType = .normal
        
        if bindMonth == month && bindDay > today {
            bindDataType = .future
        }
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            bindDataType = .selected
        } else {
            if bindMonth == month && bindDay == today {
                bindDataType = .today
            }
        }
        cell.configureCalendar(iconType: bindIconType,
                               dateType: bindDataType,
                               date: dayString)
        calendarHeaderView.configureHeader(year: bindYear,
                                           month: bindMonth)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, 
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        let today = Date()
        
        if date.compare(today) == .orderedDescending {
            return
        }
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            return
        }
        selectedDate = date
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titlePlaceholderColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}
