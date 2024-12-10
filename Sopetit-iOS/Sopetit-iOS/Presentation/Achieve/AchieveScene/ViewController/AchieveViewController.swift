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
    private var registerDate: String = ""
    private lazy var requestEntity: CalendarRequestEntity = CalendarRequestEntity(year: self.getDayComponents(date: "").year, month: self.getDayComponents(date: "").month)
    private var calendarEntity: CalendarEntity = CalendarEntity(success: false, message: "", data: ["": CalendarDate(memoID: 0, memoContent: "", histories: [])])
    private var selectedDateMemo: String = ""
    private var selectedDateMemoId: Int = 0
    private var fromDidChange: Bool = false
    
    // MARK: - UI Components
    
    private var achieveView = AchieveView()
    private lazy var calendarView = achieveView.achieveCalendarView
    private lazy var calendarHeaderView = achieveView.calendarHeaderView
    private lazy var goTodayButton = achieveView.calendarHeaderView.goTodayButton
    private lazy var achieveCV = achieveView.achieveCollectionView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = achieveView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCalendarAPI(entity: requestEntity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMemberProfileAPI()
        getCalendarAPI(entity: requestEntity)
        setUI()
        setAddGesture()
        setRegisterCell()
        setDelegate()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions

extension AchieveViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let today = Date()
        selectedDate = today
        calendarView.select(today)
        achieveView.calendarHeaderView.calendarHeaderRightButton.isEnabled = false
        
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
        achieveCV.delegate = self
        achieveCV.dataSource = self
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
        let nav = EditMemoBSViewController(memo: selectedDateMemo,
                                           memoId: selectedDateMemoId)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    @objc
    func addMemoButtonTapped() {
        let nav = AddMemoBSViewController(memo: "", memoId: selectedDateMemoId)
        nav.selectDate = self.selectedDate ?? Date()
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    func updateCalendarHeaderButton() {
        let calendar = Calendar.current
        let currentPage = calendarView.currentPage
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let registerDate = dateFormatter.date(from: self.registerDate) else { return }
        
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
        
        if fromDidChange {
            let components = calendar.dateComponents([.year, .month], from: currentPage)
            if let year = components.year, let month = components.month {
                getCalendarAPI(entity: CalendarRequestEntity(year: year, month: month))
                calendarHeaderView.configureHeader(year: year,
                                                   month: month)
                print("현재 페이지의 연도: \(year)")
                print("현재 페이지의 월: \(month)")
            }
        }
        fromDidChange = false
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
    
    func findValue(for key: String) -> CalendarDate {
        if let value = calendarEntity.data[key] {
            return value
        } else {
            print("Key '\(key)' not found.")
            return CalendarDate(memoID: 0, memoContent: "", histories: [])
        }
    }
    
    func hasDateKey(for key: String) -> Bool {
        if calendarEntity.data[key] != nil {
            return true
        } else {
            return false
        }
    }
    
    func setSelectDateView() {
        let today = formatDateToString(selectedDate ?? Date())
        if hasDateKey(for: today) {
            let value = findValue(for: today)
            let memo = value.memoContent
            let height = heightForContentView(numberOfSection: value.histories.count,
                                              texts: value.histories)
            selectedDateMemo = memo
            selectedDateMemoId = value.memoID
            if memo == "" { // 메모는 안썼음
                achieveView.bindIsMemo(isRecord: false, height: height, memo: memo)
            } else { // 달성도 하고 메모도 씀
                achieveView.bindIsMemo(isRecord: true, height: height, memo: memo)
            }
        } else {
            achieveView.bindIsEmptyView(isEmpty: true)
        }
        achieveCV.reloadData()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addMemo), name: Notification.Name("addMemo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(delMemo), name: Notification.Name("delMemo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(patchMemo), name: Notification.Name("patchMemo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(delDailyHistory), name: Notification.Name("delDailyHistory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(delChallengeHistory), name: Notification.Name("delChallengeHistory"), object: nil)
    }
    
    @objc func addMemo() {
        getCalendarAPI(entity: requestEntity)
    }
    
    @objc func delMemo() {
        getCalendarAPI(entity: requestEntity)
        achieveView.delMemoToast.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
            self.achieveView.delMemoToast.alpha = 0.0
        }, completion: {_ in
            self.achieveView.delMemoToast.isHidden = true
            self.achieveView.delMemoToast.alpha = 1.0
        })
    }
    
    @objc func patchMemo() {
        getCalendarAPI(entity: requestEntity)
        achieveView.editMemoToast.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
            self.achieveView.editMemoToast.alpha = 0.0
        }, completion: {_ in
            self.achieveView.editMemoToast.isHidden = true
            self.achieveView.editMemoToast.alpha = 1.0
        })
    }
    
    @objc func delDailyHistory() {
        getCalendarAPI(entity: requestEntity)
        achieveView.delDailyHistoryToast.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
            self.achieveView.delDailyHistoryToast.alpha = 0.0
        }, completion: {_ in
            self.achieveView.delDailyHistoryToast.isHidden = true
            self.achieveView.delDailyHistoryToast.alpha = 1.0
        })
    }
    
    @objc func delChallengeHistory() {
        getCalendarAPI(entity: requestEntity)
        achieveView.delChallengeHistoryToast.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
            self.achieveView.editMemoToast.alpha = 0.0
        }, completion: {_ in
            self.achieveView.delChallengeHistoryToast.isHidden = true
            self.achieveView.delChallengeHistoryToast.alpha = 1.0
        })
    }
}

// MARK: - CollectionView

extension AchieveViewController: CalendarHistoryCellDelegate {
    
    func tapHistoryCell(cellInfo: HistoryHistory) {
        let nav = DelRoutineBSViewController(isChallenge: cellInfo.isMission,
                                             id: cellInfo.historyID,
                                             content: cellInfo.content)
        print("🍎🍎cellInfo🍎🍎🍎")
        print(cellInfo)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
}

extension AchieveViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if hasDateKey(for: formatDateToString(selectedDate ?? Date())) {
            let value = findValue(for: formatDateToString(selectedDate ?? Date()))
            return value.histories.count
        } else {
            print("emptyview")
            achieveView.bindIsEmptyView(isEmpty: true)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let value = findValue(for: formatDateToString(selectedDate ?? Date()))
        return value.histories[section].histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CalendarHistoryCell.dequeueReusableCell(collectionView: achieveCV, indexPath: indexPath)
        let value = findValue(for: formatDateToString(selectedDate ?? Date()))
        cell.bindHistoryCell(content: value.histories[indexPath.section].histories[indexPath.item].content,
                             isMission: value.histories[indexPath.section].histories[indexPath.item].isMission,
                             themeId: value.histories[indexPath.section].themeID)
        cell.cellInfo = value.histories[indexPath.section].histories[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = NewDailyRoutineHeaderView.dequeueReusableHeaderView(collectionView: achieveCV, indexPath: indexPath)
            let value = findValue(for: formatDateToString(selectedDate ?? Date()))
            headerView.setDataBind(text: value.histories[indexPath.section].themeName,
                                   image: value.histories[indexPath.section].themeID)
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension AchieveViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label: UILabel = {
            let label = UILabel()
            let value = findValue(for: formatDateToString(selectedDate ?? Date()))
            label.text = value.histories[indexPath.section].histories[indexPath.item].content.replacingOccurrences(of: "\n", with: " ")
            label.font = .fontGuide(.body2)
            return label
        }()
        
        let height = max(heightForView(text: label.text ?? "", font: label.font, width: SizeLiterals.Screen.screenWidth - 119), 24) + 32
        
        return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: height)
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.setTextWithLineHeight(text: label.text, lineHeight: 20)
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightForContentView(numberOfSection: Int, texts: [CalendarHistory]) -> Double {
        var height = Double(numberOfSection) * 20.0
        
        for k in texts {
            for i in k.histories {
                let textHeight = heightForView(text: i.content.replacingOccurrences(of: "\n", with: " "), font: .fontGuide(.body2), width: SizeLiterals.Screen.screenWidth - 119) + 32
                height += textHeight
            }
            height += 12
        }
        height += Double(16 * (texts.count - 1) + 30)
        return height
    }
}

// MARK: - CalendarHeaderDelegate

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
        setSelectDateView()
    }
}

// MARK: - FSCalendar

extension AchieveViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar,
                  cellFor date: Date,
                  at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.className, for: date, at: position) as? CalendarDateCell
        else { return FSCalendarCell() }
        
        let bindDay = Calendar.current.component(.day, from: date)
        let bindMonth = Calendar.current.component(.month, from: date)
        let bindYear = Calendar.current.component(.year, from: date)
        let dayString = String(bindDay)
        selectedMonth = bindMonth
        
        let day = getDayComponents(date: "").day
        let month = getDayComponents(date: "").month
        let year = getDayComponents(date: "").year
        
        let registerDay = getDayComponents(date: self.registerDate).day
        let registerMonth = getDayComponents(date: self.registerDate).month
        let registerYear = getDayComponents(date: self.registerDate).year
        
        var bindDataType: CalendarDateType = .nonSelected
        
        if bindYear == year {
            if bindMonth == month {
                if bindDay > day {
                    bindDataType = .future
                } else if bindDay < day {
                    bindDataType = .nonSelected
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
        
        var bindIconType: CalendarIconType = .normal
        
        let bindDateString = formatDateToString(date)
        if hasDateKey(for: bindDateString) { // 달성한 루틴이 있음
            let memo = findValue(for: bindDateString).memoContent
            if memo == "" { // 메모는 안썼음
                bindIconType = .achieveRoutine
            } else { // 달성도 하고 메모도 씀
                bindIconType = .hasRecord
            }
        } else { // 달성한 루틴이 없음
            bindIconType = .normal
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
        
        let registerDate = selectDateFormmatter.date(from: self.registerDate) ?? Date()
        if date.compare(registerDate) == .orderedAscending {
            return
        }
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            return
        }
        
        if selectDate < today && selectDate >= self.registerDate {
            goTodayButton.isHidden = false
        } else {
            goTodayButton.isHidden = true
        }
        
        achieveView.bindSelectDate(date: extractDayAndWeekday(selectDate: date).extractedDay,
                                   week: extractDayAndWeekday(selectDate: date).extractedWeekday)
        selectedDate = date
        setSelectDateView()
        print(selectDate)
        calendar.reloadData()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let registerDate = formatter.date(from: self.registerDate) ?? Date()
        return registerDate
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        fromDidChange = true
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

// MARK: - Networks

extension AchieveViewController {
    
    func getMemberProfileAPI() {
        AchieveService.shared.getMemberProfileAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<MemberProfileEntity> {
                    if let memberProfilData = data.data {
                        let date = memberProfilData.createdAt.split(separator: "T").first ?? ""
                        self.registerDate = String(date)
                        self.calendarView.reloadData()
                    }
                }
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getMemberProfileAPI()
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
    
    func getCalendarAPI(entity: CalendarRequestEntity) {
        AchieveService.shared.getCalendar(requestEntity: entity) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? CalendarEntity {
                    print("💭💭💭💭💭")
                    dump(data)
                    print("💭💭💭💭💭")
                    self.calendarEntity = data
                    self.setSelectDateView()
                    self.calendarView.reloadData()
                }
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getCalendarAPI(entity: entity)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            case .requestErr, .serverErr:
                self.makeServerErrorAlert()
            default:
                break
            }
        }
    }
}
