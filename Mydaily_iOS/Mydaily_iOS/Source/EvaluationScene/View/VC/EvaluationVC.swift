//
//  EvaluationVC.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2020/12/30.
//

import UIKit

protocol ChangeModifyButtonDelegate: class {
    func changeModifyButton(isActive: Bool)
    func showAlert(title: String, message: String)
}

class EvaluationVC: UIViewController {
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var evaluationTabButton: UIButton!
    @IBOutlet weak var retrospectiveTabButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var evaluationTabBar: UIView!
    @IBOutlet weak var retrospectiveTabBar: UIView!
    @IBOutlet weak var keywordCollectionView: UICollectionView!
    @IBOutlet weak var afterWeekButton: UIButton!
    
    lazy var currentWeekButton: UIButton = {
        let currentWeekButton = UIButton()
        currentWeekButton.translatesAutoresizingMaskIntoConstraints = false
        currentWeekButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return currentWeekButton
    }()
    
    lazy var modifyButton: UIButton = {
        let modifyButton = UIButton()
        modifyButton.translatesAutoresizingMaskIntoConstraints = false
        return modifyButton
    }()
    
    var calendar = Calendar.current
    var dateFormatter = DateFormatter()
    var checkDateFormatter = DateFormatter()
    var dateValue = 0
    var isRetrospectiveTab = false
    
    let originalButtonColor: UIColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
    let selectedButtonColor: UIColor = UIColor.init(red: 236/255, green: 104/255, blue: 74/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setWeekLabel()
        setMenuTabButton()
        setCollectionViewDelegate()
        setCurrentButton()
        setModifyButton()
    }
    
    @IBAction func touchUpEvaluationTab(_ sender: Any) {
        guard let indexPath = keywordCollectionView.indexPathsForVisibleItems.first.flatMap({_ in
                IndexPath(item: 0, section: 0)
            }), keywordCollectionView.cellForItem(at: indexPath) != nil else {
                return
        }
        keywordCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        setButtonState(enableButton: evaluationTabButton, disableButton: retrospectiveTabButton, enableTabBar: evaluationTabBar, unableTabBar: retrospectiveTabBar)
        
        modifyButton.isHidden = true
        
        isRetrospectiveTab = false
    }
    
    @IBAction func touchUpRetrospectiveTab(_ sender: Any) {
        guard let indexPath = keywordCollectionView.indexPathsForVisibleItems.first.flatMap({_ in
                IndexPath(item: 0, section: 1)
            }), keywordCollectionView.cellForItem(at: indexPath) != nil else {
                return
        }
        keywordCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        setButtonState(enableButton: retrospectiveTabButton, disableButton: evaluationTabButton, enableTabBar: retrospectiveTabBar, unableTabBar: evaluationTabBar)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retrospectiveTab"), object: modifyButton)
        
        isRetrospectiveTab = true
    }
    
    @IBAction func touchUpBeforeWeek(_ sender: Any) {
        dateValue -= 1
        guard let todayDate = calendar.date(byAdding: .weekOfMonth, value: dateValue, to: Date()) else {return}
        guard let currentDate = calendar.date(byAdding: .weekOfMonth, value: 0, to: Date()) else {return}
        let today = "\(todayDate)"
        let current = "\(currentDate)"
        dateFormatter.dateFormat = "yy년 MM월 W주"
        weekLabel.text = dateFormatter.string(from: todayDate)
        weekLabel.textColor = .black
        print(dateValue)
        if today != current {
            currentWeekButton.isHidden = false
        } else {
            currentWeekButton.isHidden = true
            weekLabel.textColor = .systemRed
        }
    }
    
    @IBAction func touchUpAfterWeek(_ sender: Any) {
        dateValue += 1
        guard let todayDate = calendar.date(byAdding: .weekOfMonth, value: dateValue, to: Date()) else {return}
        guard let currentDate = calendar.date(byAdding: .weekOfMonth, value: 0, to: Date()) else {return}
        let today = "\(todayDate)"
        let current = "\(currentDate)"
        print(dateValue)
        if isRetrospectiveTab {
            if dateValue >= 0  {
                afterWeekButton.isEnabled = false
            } else {
                afterWeekButton.isEnabled = true
            }
        } else {
            dateFormatter.dateFormat = "yy년 MM월 W주"
            weekLabel.text = dateFormatter.string(from: todayDate)
            weekLabel.textColor = .black
            
            if today != current {
                currentWeekButton.isHidden = false
            } else {
                currentWeekButton.isHidden = true
                weekLabel.textColor = .systemRed
            }
        }
    }
}

extension EvaluationVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EvaluationTabCVC.identifier, for: indexPath) as? EvaluationTabCVC else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RetrospectiveTabCVC.identifier, for: indexPath) as? RetrospectiveTabCVC else {
            return UICollectionViewCell()
        }
        cell.buttonDelegate = self
        cell.delegate = self
        return cell
    }
}

extension EvaluationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension EvaluationVC {
    private func setNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setWeekLabel() {
        dateValue = 0
        let todayDate = Calendar.current.date(byAdding: .weekOfMonth, value: dateValue, to: Date())!
        dateFormatter.dateFormat = "yy년 MM월 w주"
        dateFormatter.locale = Locale(identifier: "ko")
        weekLabel.text = dateFormatter.string(from: todayDate)
        
        weekLabel.font = .boldSystemFont(ofSize: 12)
        weekLabel.textAlignment = .center
        weekLabel.textColor = .systemRed
    }
    
    private func setMenuTabButton() {
        evaluationTabButton.setTitleColor(selectedButtonColor, for: .normal)
        evaluationTabButton.setTitle("리포트", for: .normal)
        evaluationTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        retrospectiveTabButton.setTitleColor(originalButtonColor, for: .normal)
        retrospectiveTabButton.setTitle("회고", for: .normal)
        retrospectiveTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        retrospectiveTabBar.isHidden = true
    }
    
    private func setCurrentButton() {
        view.addSubview(currentWeekButton)
        currentWeekButton.addTarget(self, action: #selector(backToCurrentWeek), for: .touchUpInside)
        currentWeekButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentWeekButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        currentWeekButton.widthAnchor.constraint(equalToConstant: 81).isActive = true
        currentWeekButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        currentWeekButton.setTitle("이번주", for: .normal)
        currentWeekButton.titleLabel?.textAlignment = .left
        currentWeekButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        currentWeekButton.titleLabel?.textColor = .white
        currentWeekButton.layer.cornerRadius = 15
        currentWeekButton.layer.masksToBounds = true
        currentWeekButton.isHidden = true
    }
    
    private func setButtonState(enableButton: UIButton, disableButton: UIButton, enableTabBar: UIView, unableTabBar: UIView) {
        enableButton.setTitleColor(selectedButtonColor, for: .normal)
        disableButton.setTitleColor(originalButtonColor, for: .normal)
        enableTabBar.isHidden = false
        unableTabBar.isHidden = true
    }
    
    private func setModifyButton() {
        view.addSubview(modifyButton)
        modifyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        modifyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        modifyButton.setTitle("수정", for: .normal)
        modifyButton.setTitleColor(.blue, for: .normal)
        modifyButton.titleLabel?.font = .systemFont(ofSize: 16)
        modifyButton.isHidden = true
        modifyButton.addTarget(self, action: #selector(touchUpModify), for: .touchUpInside)
    }
    
    private func setCollectionViewDelegate() {
        keywordCollectionView.delegate = self
        keywordCollectionView.dataSource = self
    }
    
    @objc func backToCurrentWeek() {
        setWeekLabel()
        currentWeekButton.isHidden = true
    }
    
    @objc func touchUpModify() {
        modifyButton.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("modifyButton"), object: nil)
    }
}

extension EvaluationVC: TableViewInsideCollectionViewDelegate {
    func cellTapedEvaluation(dvc: EvaluationDetailVC) {
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    func cellTapedRetrospective(dvc: RetrospectiveWriteVC) {
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension EvaluationVC: ChangeModifyButtonDelegate {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "다음에하기", style: .default)
        let okAction = UIAlertAction(title: "재설정하기", style: .default)
        noAction.setValue(UIColor.lightGray, forKey: "titleTextColor")
        okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alert.addAction(noAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func changeModifyButton(isActive: Bool) {
        modifyButton.isHidden = isActive
    }
}
