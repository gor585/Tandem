//
//  EventCell.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 22.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    var event: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setEvent(event: Event) {
        self.event = event
        iconImageView.image = UIImage(named: event.category)
        titleLabel.text = event.title
        startLabel.text = event.start
        endLabel.text = event.end
    }
}
