//
//  RemindTimerAddViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RemindTimerAddViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dateformatter = DateFormatter()
    private var categoryID: Int?
    private var selectedIndex: Set<Int> = [] {
        didSet {
            repeatButtonLabel.text = selectedIndex.fetchDaysString()
            repeatButtonLabel.textColor = .toasterPrimary
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var verticalStackView: UIStackView = createStackView(forAxis: .vertical, forSpacing: 18)
    
    private lazy var labelStackView: UIStackView = createStackView(forAxis: .vertical, forSpacing: 8, forAlignment: .leading)
    private let mainLabel: UILabel = UILabel()
    
    private lazy var subLabelStackView: UIStackView = createStackView(forAxis: .horizontal, forSpacing: 2)
    private let subLabel: UILabel = UILabel()
    private let timerView: UIView = UIView()
    private let timerLabel: UILabel = UILabel()
    
    private lazy var pickerStackView: UIStackView = createStackView(forAxis: .vertical, forSpacing: 0)
    private let firstDividingView: UIView = UIView()
    private let datePickerView: UIDatePicker = UIDatePicker()
    private let secondDividingView: UIView = UIView()
    
    private lazy var repeatStackView: UIStackView = createStackView(forAxis: .vertical, forSpacing: 12)
    private let repeatLabel: UILabel = UILabel()
    private let setupRepeatButton: UIButton = UIButton()
    private let repeatButtonLabel: UILabel = UILabel()
    private let repeatButtonImageView: UIImageView = UIImageView(image: ImageLiterals.Clip.rightarrow)
    
    private let completeButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
}

// MARK: - Extension

extension RemindTimerAddViewController {
    func configureView(forModel: RemindClipModel?) {
        if let model = forModel {
            mainLabel.text = "\(model.title)을"
            mainLabel.asFont(targetString: model.title,
                             font: .suitSemiBold(size: 18))
            categoryID = forModel?.id
        }
    }
}

// MARK: - Private Extension

private extension RemindTimerAddViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        
        dateformatter.do {
            $0.dateFormat = "a hh시 mm분"
            $0.locale = Locale(identifier: "ko_KR")
        }
        
        mainLabel.do {
            $0.font = .suitMedium(size: 18)
            $0.textColor = .toasterBlack
        }
        
        timerView.do {
            $0.makeRounded(radius: 4)
            $0.backgroundColor = .toaster100
        }
        
        timerLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .toasterPrimary
            $0.text = dateformatter.string(from: Date())
        }
        
        subLabel.do {
            $0.text = "에 리마인드 해드릴게요"
            $0.font = .suitMedium(size: 18)
            $0.textColor = .toasterBlack
        }
        
        [firstDividingView, secondDividingView].forEach {
            $0.do {
                $0.backgroundColor = .gray50
            }
        }
        
        datePickerView.do {
            $0.datePickerMode = .time
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
            $0.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
        }
        
        repeatLabel.do {
            $0.text = "반복 주기를 정해주세요"
            $0.font = .suitMedium(size: 18)
            $0.textColor = .toasterBlack
        }
        
        setupRepeatButton.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .toasterWhite
            $0.titleLabel?.font = .suitSemiBold(size: 16)
            $0.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
        }
        
        repeatButtonLabel.do {
            $0.text = "반복"
            $0.font = .suitBold(size: 16)
            $0.textColor = .black850
        }
        
        completeButton.do {
            $0.makeRounded(radius: 12)
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitSemiBold(size: 16)
            $0.backgroundColor = .toasterBlack
            $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(verticalStackView, completeButton)
        
        verticalStackView.addArrangedSubviews(labelStackView, pickerStackView, repeatStackView)
        
        labelStackView.addArrangedSubviews(mainLabel, subLabelStackView)
        pickerStackView.addArrangedSubviews(firstDividingView, datePickerView, secondDividingView)
        repeatStackView.addArrangedSubviews(repeatLabel, setupRepeatButton)
        subLabelStackView.addArrangedSubviews(timerView, subLabel)
        setupRepeatButton.addSubviews(repeatButtonLabel, repeatButtonImageView)
        timerView.addSubview(timerLabel)
    }
    
    func setupLayout() {
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        setupRepeatButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.bottom.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        timerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(134)
        }
        
        timerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [labelStackView, pickerStackView, repeatStackView].forEach {
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
        
        [firstDividingView, secondDividingView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(4)
            }
        }
        
        repeatButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }
        
        repeatButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string("타이머 설정"),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.close),
                                                                rightButtonAction: closeButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func createStackView(forAxis: NSLayoutConstraint.Axis,
                         forSpacing: CGFloat,
                         forAlignment: UIStackView.Alignment = .fill) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = forAxis
        stackView.spacing = forSpacing
        stackView.alignment = forAlignment
        return stackView
    }
    
    func closeButtonTapped() {
        showPopup(forMainText: "타이머 만들기를 취소할까요?",
                  forSubText: "지금까지 진행한 타이머 설정이\n사라져요",
                  forLeftButtonTitle: "닫기",
                  forRightButtonTitle: "취소",
                  forRightButtonHandler: makeTimerCancle)
    }
    
    func makeTimerCancle() {
        dismiss(animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setSelectedIndex(contains: Int,
                          deleteFirst: Int,
                          deleteSecond: Int) {
        if selectedIndex.contains(contains) {
            for i in deleteFirst...deleteSecond {
                self.selectedIndex.insert(i)
            }
            selectedIndex.remove(contains)
        }
    }
    
    @objc func pickerValueChanged() {
        let date = dateformatter.string(from: datePickerView.date)
        timerLabel.text = date
    }
    
    @objc func repeatButtonTapped() {
        let repeatView = TimerRepeatBottomSheetView()
        repeatView.setupDelegate(forDelegate: self)
        repeatView.setupSelectedIndex(forIndexList: selectedIndex)
        let exampleBottom = ToasterBottomSheetViewController(bottomType: .gray, bottomTitle: "반복설정", height: 622, insertView: repeatView)
        exampleBottom.modalPresentationStyle = .overFullScreen
        self.present(exampleBottom, animated: false)
    }
    
    @objc func completeButtonTapped() {
        // TODO: - API 호출
    }
}

// MARK: - TimerRepeatBottomSheetDelegate

extension RemindTimerAddViewController: TimerRepeatBottomSheetDelegate {
    func nextButtonTapped(selectedList: Set<Int>) {
        selectedIndex = selectedList
        print(selectedIndex)
        setSelectedIndex(contains: 8, deleteFirst: 1, deleteSecond: 7)
        setSelectedIndex(contains: 9, deleteFirst: 1, deleteSecond: 5)
        setSelectedIndex(contains: 10, deleteFirst: 6, deleteSecond: 7)
        print("🔥", selectedIndex)

        
        dismiss(animated: false)
    }
}
