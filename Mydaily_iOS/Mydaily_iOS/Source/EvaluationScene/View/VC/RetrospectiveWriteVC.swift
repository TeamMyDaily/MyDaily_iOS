//
//  RetrospectiveWriteVC.swift
//  Mydaily_iOS
//
//  Created by SHIN YOON AH on 2021/01/05.
//

import UIKit
import Moya

class RetrospectiveWriteVC: UIViewController {
    static let identifier = "RetrospectiveWriteVC"
    
    private let authProvider = MoyaProvider<ReportServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var writingData: RegistRetrospectiveModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var limitCountLabel: UILabel!
    @IBOutlet weak var countNumberLabel: UILabel!
    @IBOutlet weak var writeView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var writeTextView: UITextView = {
        let writeTextView = UITextView()
        writeTextView.translatesAutoresizingMaskIntoConstraints = false
        return writeTextView
    }()
    
    var saveContent: ((String, Int) -> ())?
    var textViewHeightConstraint: NSLayoutConstraint?
    
    var start: Date?
    var end: Date?
    var dateValue = 0
    let changeDateValue = 86400 * 7
    
    var contentSaver = ""
    var counter = 0
    var cellNum = 0
    
    var cellPlaceholders = ["이번주, 어떤 내 모습을 칭찬 해주고 싶나요?", "한 주에 아쉬움이 남은 점이 있을까요?", "다음주에는 어떻게 지내고 싶은가요?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setLabel()
        setView()
        setTextView()
        setButton()
        setData()
        setKeyboard()
    }
}

//MARK: Action
extension RetrospectiveWriteVC {
    @IBAction func touchUpSave(_ sender: Any) {
        guard let text: String = writeTextView.text else {return}
        saveContent?(text, counter)
        saveText()
        
        tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpCancel(_ sender: Any) {
        backAlert()
    }
}

//MARK: UI
extension RetrospectiveWriteVC {
    private func setTabBar() {
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = UIRectEdge.bottom
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func setLabel() {
        titleLabel.font = .myBoldSystemFont(ofSize: 20)
        titleLabel.text = "회고"
        titleLabel.textColor = .mainBlack
        
        questionLabel.font = .myBoldSystemFont(ofSize: 21)
        questionLabel.textColor = .mainBlack
        
        limitCountLabel.font = .myRegularSystemFont(ofSize: 12)
        limitCountLabel.text = "/800자"
        limitCountLabel.textColor = .mainGray
        
        countNumberLabel.font = .myRegularSystemFont(ofSize: 12)
        countNumberLabel.textColor = .mainOrange
    }
    
    private func setView() {
        writeView.backgroundColor = .mainLightGray
        writeView.layer.cornerRadius = 15
    }
    
    private func setTextView() {
        writeView.addSubview(writeTextView)
        
        writeTextView.leadingAnchor.constraint(equalTo: writeView.leadingAnchor, constant: 17).isActive = true
        writeTextView.trailingAnchor.constraint(equalTo: writeView.trailingAnchor, constant: -17).isActive = true
        writeTextView.topAnchor.constraint(equalTo: writeView.topAnchor, constant: 10).isActive = true
        textViewHeightConstraint = writeTextView.heightAnchor.constraint(equalToConstant: 477)
        textViewHeightConstraint?.isActive = true
        
        writeTextView.font = .myRegularSystemFont(ofSize: 16)
        writeTextView.textColor = .mainGray
        writeTextView.backgroundColor = UIColor.clear
        writeTextView.layer.cornerRadius = 10
        writeTextView.delegate = self
        writeTextView.isEditable = true
    }
    
    private func setButton() {
        saveButton.titleLabel?.font = .myBoldSystemFont(ofSize: 18)
        saveButton.setTitle("저장할래요", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 15
        buttonState()
    }
}

//MARK: Alert
extension RetrospectiveWriteVC {
    private func backAlert() {
        let alert = UIAlertController(title: "정말 뒤로 가시겠어요?", message: "작성 완료를 누르지 않고 뒤로 가기를 하면 현재 작성중이던 내용도 모두 사라집니다. 정말 뒤로 가시겠어요?", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.tabBarController?.tabBar.isHidden = false
            self.extendedLayoutIncludesOpaqueBars = false
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        cancelAction.setValue(UIColor.mainBlue, forKey: "titleTextColor")
        removeAction.setValue(UIColor.mainBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true)
    }
}

//MARK: Button
extension RetrospectiveWriteVC {
    private func buttonState() {
        guard let text: String = writeTextView.text else {return}
        if text != "" && text != cellPlaceholders[0] && text != cellPlaceholders[1] && text != cellPlaceholders[2] {
            saveButton.backgroundColor = .mainOrange
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .mainGray
            saveButton.isEnabled = false
        }
    }
}

//MARK: Data
extension RetrospectiveWriteVC {
    private func setData() {
        let userDefault = UserDefaults.standard
        
        if let question = userDefault.string(forKey: "title") {
            questionLabel.text = question
        }
        
        if let content = userDefault.string(forKey: "content") {
            writeTextView.text = content
            if content != cellPlaceholders[0] && content != cellPlaceholders[1] && content != cellPlaceholders[2] {
                writeTextView.textColor = .mainBlack
                contentSaver = content
            } else {
                writeTextView.textColor = .mainGray
            }
        }
        
        if let count = userDefault.string(forKey: "count") {
            countNumberLabel.text = count
            counter = Int(count) ?? 0
        }
        
        cellNum = userDefault.integer(forKey: "cellNum")
    }
}

//MARK: TextView
extension RetrospectiveWriteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if UIScreen.main.bounds.size.height <= 667 {
            textViewHeightConstraint?.constant = UIScreen.main.bounds.size.height / 2.5
        } else if UIScreen.main.bounds.size.height <= 812 {
            textViewHeightConstraint?.constant = UIScreen.main.bounds.size.height / 2.7
        } else if UIScreen.main.bounds.size.height <= 844 {
            textViewHeightConstraint?.constant = UIScreen.main.bounds.size.height / 2.5
        } else {
            textViewHeightConstraint?.constant = UIScreen.main.bounds.size.height / 2.3
        }
        
        guard let text: String = writeTextView.text else {return}
        if text == cellPlaceholders[cellNum] {
            writeTextView.text = ""
            writeTextView.textColor = .mainBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewHeightConstraint?.constant = 477
        
        guard let text: String = writeTextView.text else {return}
        if text == "" {
            writeTextView.text = cellPlaceholders[cellNum]
            writeTextView.textColor = .mainGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        buttonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        counter = newText.count
        countNumberLabel.text = "\(newText.count)"
        return numberOfChars < 800
    }
}

//MARK: Keyboard
extension RetrospectiveWriteVC {
    private func setKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissGestureKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissGestureKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Network
extension RetrospectiveWriteVC {
    func saveText() {
        guard let startDate = start?.millisecondsSince1970 else {return}
        guard let endDate = end?.millisecondsSince1970 else {return}
        let current = Date().millisecondsSince1970
        let param = RegistRetrospectiveRequest.init(startDate, endDate, current, self.cellNum + 1, self.writeTextView.text)
        print(param)
        authProvider.request(.registRetrospective(param: param)) { response in
            switch response {
                case .success(let result):
                    do {
                        self.writingData = try result.map(RegistRetrospectiveModel.self)
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
}
