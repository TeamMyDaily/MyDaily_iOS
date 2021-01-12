//
//  evaluationTabCVC.swift
//  Mydaily_iOS
//
//  Created by SHIN YOON AH on 2021/01/01.
//

import UIKit
import Moya

class EvaluationTabCVC: UICollectionViewCell {
    static let identifier = "EvaluationTabCVC"
    
    private let authProvider = MoyaProvider<ReportServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var textData: ViewReportModel?
    
    @IBOutlet weak var keywordTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    lazy var notifyLabel: UILabel = {
        let notifyLabel = UILabel()
        notifyLabel.translatesAutoresizingMaskIntoConstraints = false
        return notifyLabel
    }()
    
    lazy var createKeywordButton: UIButton = {
        let createKeywordButton = UIButton()
        createKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        return createKeywordButton
    }()
    
    var delegate: TableViewInsideCollectionViewDelegate?
    
    var weekText: String? = nil
    var dateValue = 0
    
    var totalKeywordId: [Int] = []
    var keywords: [String] = []
    var goals: [String] = []
    var rates: [String] = []
    var counts: [Int] = []
    var removeIndex: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getText()
        setTableView()
        setViewWithoutTableView()
        setNotification()
        makeUpArrayOfData()
    }
}

extension EvaluationTabCVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        var cnt = 0
        for i in counts {
            if i != 0 {
                cnt += 1
            }
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationHeaderTVC.identifier) as? EvaluationHeaderTVC else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationKeywordTVC.identifier) as? EvaluationKeywordTVC else {
            return UITableViewCell()
        }
        cell.setCellInsideData(keyword: keywords[indexPath.item] ?? "", goal: goals[indexPath.item] ?? "", index: indexPath.item, rate: rates[indexPath.item] ?? "0", count: Int(counts[indexPath.item] ?? 0))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 129
        }
        return 100
    }
}

extension EvaluationTabCVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if keywords[indexPath.row] != nil {
                guard let dvc = UIStoryboard(name: "Evaluation", bundle: nil).instantiateViewController(identifier: "EvaluationDetailVC") as? EvaluationDetailVC else {
                    return
                }
                dvc.weekText = weekText
                dvc.cellNum = totalKeywordId[indexPath.row]
                self.delegate?.cellTapedEvaluation(dvc: dvc)
            }
        }
    }
}

//MARK: UI
extension EvaluationTabCVC {
    private func setTableView() {
        keywordTableView.separatorStyle = .none
        keywordTableView.delegate = self
        keywordTableView.dataSource = self
    }
    
    private func setNoDataView() {
        noDataView.addSubview(notifyLabel)
        noDataView.addSubview(createKeywordButton)
        
        notifyLabel.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor).isActive = true
        notifyLabel.centerXAnchor.constraint(equalTo: noDataView.centerXAnchor).isActive = true
        notifyLabel.font = .myRegularSystemFont(ofSize: 12)
        notifyLabel.textColor = .mainGray
        notifyLabel.textAlignment = .center
        notifyLabel.numberOfLines = 0
    }
    
    private func setViewByDateValue() {
        if dateValue == 0 {
            notifyLabel.text = "키워드가 존재 하지 않아 목표를 생성 할 수 없어요.😢\n + 버튼을 눌러 키워드를 생성 해 보세요!"
            
            createKeywordButton.topAnchor.constraint(equalTo: notifyLabel.bottomAnchor, constant: 47).isActive = true
            createKeywordButton.centerXAnchor.constraint(equalTo:noDataView.centerXAnchor).isActive = true
            createKeywordButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            createKeywordButton.widthAnchor.constraint(equalToConstant: 114).isActive = true
            createKeywordButton.titleLabel?.font = .myMediumSystemFont(ofSize: 16)
            createKeywordButton.setTitle("키워드 생성 >", for: .normal)
            createKeywordButton.titleLabel?.textAlignment = .left
            createKeywordButton.titleLabel?.textColor = .white
            createKeywordButton.backgroundColor = .mainOrange
            createKeywordButton.layer.cornerRadius = 15
            createKeywordButton.layer.masksToBounds = true
            createKeywordButton.isHidden = false
            createKeywordButtonAddTarget()
        } else {
            notifyLabel.text = "이 주에는 키워드와 목표가 없어요.😢"
            createKeywordButton.isHidden = true
        }
    }
}

//MARK: View
extension EvaluationTabCVC {
    private func setViewWithoutTableView() {
        setNoDataView()
        setViewByDateValue()
    }
}

//MARK: Array
extension EvaluationTabCVC {
    private func makeUpArrayOfData() {
        var index = 0
        removeIndex.removeAll()
        
        for i in counts {
            if i == 0 {
                removeIndex.append(index)
            }
            index += 1
        }
        
        for i in removeIndex.reversed() {
            keywords.remove(at: i)
            goals.remove(at: i)
            rates.remove(at: i)
            counts.remove(at: i)
        }
    }
}

//MARK: Button
extension EvaluationTabCVC {
    private func createKeywordButtonAddTarget() {
        createKeywordButton.addTarget(self, action: #selector(touchUpCreateKeyword), for: .touchUpInside)
    }
    
    @objc func touchUpCreateKeyword() {
        print("create")
    }
}

//MARK: Notification
extension EvaluationTabCVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getReport), name: NSNotification.Name("reloadReport"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendBeforeWeek), name: NSNotification.Name(rawValue: "LastWeek"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendAfterWeek), name: NSNotification.Name(rawValue: "NextWeek"), object: nil)
    }
    
    @objc func getReport() {
        getText()
    }
    
    @objc func sendBeforeWeek() {
        dateValue -= 1
        setViewByDateValue()
        noDataView.setNeedsLayout()
        noDataView.layoutIfNeeded()
    }
    
    @objc func sendAfterWeek() {
        dateValue += 1
        setViewByDateValue()
        noDataView.setNeedsLayout()
        noDataView.layoutIfNeeded()
    }
}

//MARK: Network
extension EvaluationTabCVC {
    func getText(){
        let param = ViewRequest.init("1610290800000", "1610982000000")
        authProvider.request(.viewReport(param: param)) { response in
            switch response {
                case .success(let result):
                    do {
                        self.textData = try result.map(ViewReportModel.self)
                        if self.textData?.data.keywordsExist == false {
                            self.keywordTableView.isHidden = true
                            self.noDataView.isHidden = false
                        } else {
                            self.keywordTableView.isHidden = false
                            self.noDataView.isHidden = true
                            if self.textData?.data.result.count != 0 {
                                self.totalKeywordId.removeAll()
                                self.keywords.removeAll()
                                self.counts.removeAll()
                                self.goals.removeAll()
                                self.rates.removeAll()
                                for i in 0...(self.textData?.data.result.count ?? 0)-1 {
                                    self.totalKeywordId.append(self.textData?.data.result[i].totalKeywordID ?? 0)
                                    self.keywords.append(self.textData?.data.result[i].keyword ?? "")
                                    self.counts.append(self.textData?.data.result[i].taskCnt ?? 0)
                                    self.goals.append(self.textData?.data.result[i].weekGoal ?? "")
                                    self.rates.append(self.textData?.data.result[i].taskSatisAvg ?? "")
                                }
                            }
                            self.keywordTableView.reloadData()
                        }
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
}
