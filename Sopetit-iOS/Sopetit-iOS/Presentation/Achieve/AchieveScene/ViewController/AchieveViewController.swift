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
    private lazy var goTodayButton = achieveView.calendarHeaderView.goTodayButton
    
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
        
        let inital = extractDayAndWeekday(selectDate: today)
        achieveView.bindSelectDate(date: inital.extractedDay,
                                   week: inital.extractedWeekday)
    }
    
    func setAddGesture() {
        let tapStatsMenu = UITapGestureRecognizer(target: self,
                                                  action: #selector(statsMenuTapped))
        let tapCalendarMenu = UITapGestureRecognizer(target: self,
                                                     action: #selector(calendarMenuTapped))
        let tapMemo =  UITapGestureRecognizer(target: self,
                                              action: #selector(memoTapped))
        let tapBear =  UITapGestureRecognizer(target: self,
                                              action: #selector(memoTapped))
        achieveView.achieveMenuView.statsMenuView.addGestureRecognizer(tapStatsMenu)
        achieveView.achieveMenuView.calendarMenuView.addGestureRecognizer(tapCalendarMenu)
        achieveView.memoLabel.addGestureRecognizer(tapMemo)
        achieveView.bearFaceImage.addGestureRecognizer(tapBear)
        
        achieveView.addMemoButton.addTarget(self,
                                            action: #selector(addMemoButtonTapped),
                                            for: .touchUpInside)
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
    
    @objc
    func memoTapped() {
        let nav = EditMemoBSViewController(memo: "아아아\n아라라라ㅏ라라아랄ㅇ라ㅏㅇ아아아\ndkdk")
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    @objc
    func addMemoButtonTapped() {
        let nav = AddMemoBSViewController(memo: "")
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
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
    
    func getDayComponents(date: String) -> (year: Int, month: Int, day: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let getDate = dateFormatter.date(from: date) ?? Date()
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: getDate)
        let month = calendar.component(.month, from: getDate)
        let day = calendar.component(.day, from: getDate)
        return (year, month, day)
    }
    
    func extractDayAndWeekday(selectDate: Date) -> (extractedDay: String,
                                                    extractedWeekday: String) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "E"
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        
        let selectDay = dayFormatter.string(from: selectDate)
        let selectWeekday = weekdayFormatter.string(from: selectDate)
        return (selectDay, selectWeekday)
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
    
    func tapTodayButton() {
        let today = Date()
        calendarView.select(today)
        calendarView.setCurrentPage(today, animated: true)
        selectedDate = today
        calendarView.reloadData()
        updateCalendarHeaderButton()
        goTodayButton.isHidden = true
        let inital = extractDayAndWeekday(selectDate: today)
        achieveView.bindSelectDate(date: inital.extractedDay,
                                   week: inital.extractedWeekday)
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
        
        let day = getDayComponents(date: "").day
        let month = getDayComponents(date: "").month
        let year = getDayComponents(date: "").year
        
        let registerDay = getDayComponents(date: "2024-04-06").day
        let registerMonth = getDayComponents(date: "2024-04-06").month
        let registerYear = getDayComponents(date: "2024-04-06").year
        
        var bindDataType: CalendarDateType = .nonSelected
        var bindIconType: CalendarIconType = .normal
        
        if bindYear == year {
            if bindMonth == month {
                if bindDay > day {
                    bindDataType = .future
                }
            } else if bindMonth > month {
                bindDataType = .future
            }
        } else if bindYear > year {
            bindDataType = .future
        }
        
        if bindYear == registerYear {
            if bindMonth == registerMonth {
                if bindDay < registerDay {
                    bindDataType = .future
                }
            } else if bindMonth < registerMonth {
                bindDataType = .future
            }
        } else if bindYear < registerYear {
            bindDataType = .future
        }
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            bindDataType = .selected
        } else {
            if bindYear == year && bindMonth == month && bindDay == day {
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
        let selectDateFormmatter = DateFormatter()
        selectDateFormmatter.dateFormat = "yyyy-MM-dd"
        selectDateFormmatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let today = selectDateFormmatter.string(from: Date())
        let selectDate = selectDateFormmatter.string(from: date)
        
        if selectDate > today {
            return
        }
        
        let dateString = "2024-04-06"
        let registerDate = selectDateFormmatter.date(from: dateString) ?? Date()
        if date.compare(registerDate) == .orderedAscending {
            return
        }
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            return
        }
        
        if selectDate < today && selectDate >= dateString {
            goTodayButton.isHidden = false
        } else {
            goTodayButton.isHidden = true
        }
        
        achieveView.bindSelectDate(date: extractDayAndWeekday(selectDate: date).extractedDay,
                                   week: extractDayAndWeekday(selectDate: date).extractedWeekday)
        selectedDate = date
        print(selectDate)
        calendar.reloadData()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let dateString = "2024-04-06"
        let registerDate = formatter.date(from: dateString) ?? Date()
        return registerDate
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateCalendarHeaderButton()
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
