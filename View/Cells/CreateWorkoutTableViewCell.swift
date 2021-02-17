//
//  CreateWorkoutTableViewCell.swift
//  Fitness
//
//  Created by Scott Colas on 2/1/21.
//

import UIKit

protocol CreateWorkoutTableViewCellDelegate: AnyObject {
    func createWorkoutTableViewCell(_ cell: CreateWorkoutTableViewCell, didUpdateField updatedModel: WorkoutFormModel)
}

class CreateWorkoutTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "CreateWorkoutTableViewCell"
    
    public weak var delegate: CreateWorkoutTableViewCellDelegate?
    private var model: WorkoutFormModel?
    
    private let formLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with model: WorkoutFormModel){
        self.model = model
        formLabel.text  = model.label
        field.placeholder = model.placeholder
        field.text = nil
    }
    override func prepareForReuse() {
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //assign frames
        formLabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        field.frame = CGRect(x: formLabel.right + 5,
                             y: 0,
                             width: contentView.width-10-formLabel.width,
                             height: contentView.height)
    }
    
    // field
    // handels when user press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else{
            return true        }
        delegate?.createWorkoutTableViewCell(self, didUpdateField: model)
        
       //get rid of keyboard when uuse press return
        textField.resignFirstResponder()
        return true
    }
}
