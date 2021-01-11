//
//  GoalTVC.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2021/01/07.
//

import UIKit

class GoalTVC: UITableViewCell {
    
    static let reuseIdentifier = "GoalTableViewCellIdentifier"
    static let nibName = "GoalTVC"

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var keywordName: UILabel!
    @IBOutlet weak var keywordDetail: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var achieveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GoalTVC {
    func setUI(){
        outterView.layer.cornerRadius = 15
        outterView.backgroundColor = .white
        outterView.layer.borderColor = UIColor.mainLightGray2.cgColor
        outterView.layer.borderWidth = 1
        
        keywordName.text = "아웃풋"
        keywordName.font = .myBlackSystemFont(ofSize: 18)
        keywordName.textColor = UIColor.mainGray
        keywordName.sizeToFit()
        
        keywordDetail.text = "목표를 세워주세요."
        keywordDetail.font = .myRegularSystemFont(ofSize: 15)
        keywordDetail.textColor = UIColor.mainGray
        keywordDetail.sizeToFit()
        
        achieveLabel.text = "미달성"
        achieveLabel.clipsToBounds = true
        achieveLabel.layer.cornerRadius = 10
        achieveLabel.backgroundColor = .mainGray
        achieveLabel.font = .myRegularSystemFont(ofSize: 12)
        achieveLabel.textColor = .white
        achieveLabel.textAlignment = .center
    }
}