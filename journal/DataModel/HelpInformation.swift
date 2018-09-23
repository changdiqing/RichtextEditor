//
//  HelpInformation.swift
//  journal
//
//  Created by Diqing Chang on 17.09.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct helpInfo {
    let coverImage: UIImage
    let description: String
    
    init(coverImage _coverImage: UIImage, description _description: String) {
        coverImage = _coverImage
        description = _description
    }
}

class HelpInfo {
    static let journalEditorHelp:[helpInfo] = [
        helpInfo(coverImage: UIImage(named: "cancel")!, description: "End editing without saving."),
        helpInfo(coverImage: UIImage(named: "segmentControl")!, description: "Used to switch between the three modes: Normal, Block and Image.\nNormal: Editing text with keyboard and tool bar, and insert Block and Image.\nBlock: Editing Block size, position (floating block only), background image, etc. with Block Editing Menu.\nImage: Editing Image size, alignment, border, etc. with Image Editing Menu."),
        helpInfo(coverImage: UIImage(named: "scissor")!, description: "Crop image and save as photo in the system galery"),
        helpInfo(coverImage: UIImage(named: "save-text")!, description: "Save the poster."),
        helpInfo(coverImage: UIImage(named: "info")!, description: "Show button help information."),
        helpInfo(coverImage: UIImage(named: "undo")!, description: "Undo the last operation."),
        helpInfo(coverImage: UIImage(named: "touchBlockIcon")!, description: "Inser a touch block, whose position, size, content, background, filter, border can be edited. Tapping a touch block will open its edit menu."),
        helpInfo(coverImage: UIImage(named: "typeSetting")!, description: "Edit text font size and type setting."),
        helpInfo(coverImage: UIImage(named: "pallete")!, description: "Change color in two ways. If there are text highlighted, the highlighted text's color will be changed to the selected color, if no text highlighted, the background color of othe whole poster will be changed."),
        helpInfo(coverImage: UIImage(named: "toolbarInsertImage")!, description: "Insert Image at cursor."),
        helpInfo(coverImage: UIImage(named: "clear")!, description: "Reset the attributes of selected object to default."),
        helpInfo(coverImage: UIImage(named: "fonts")!, description: "Change fonts. If there are text highlighted, the highlighted text's fonts will be changed to the selected fonts, if no text highlighted, fonts of the paragraph where the cursor is cuurrently placed will be changed."),
        helpInfo(coverImage: UIImage(named: "done")!, description: "Hide keyboard and toolbar.")
    ]
    
    static let touchblockEditMenuHelpInfo:[helpInfo] = [
        helpInfo(coverImage: UIImage(named:"cancel")!, description: "Exit touch block edit menu."),
        helpInfo(coverImage: UIImage(named:"textDirectionHorizontal")!, description: "Set text direction to horizontal."),
        helpInfo(coverImage: UIImage(named:"textDirectionVertical")!, description: "Set text direction to vertical."),
        helpInfo(coverImage: UIImage(named:"delete")!, description: "Delete this touch block."),
        helpInfo(coverImage: UIImage(named:"filter-icon-25207")!, description: "Set filter of background."),
        helpInfo(coverImage: UIImage(named:"border")!, description: "Set border of touch block."),
        helpInfo(coverImage: UIImage(named:"pallete")!, description: "Set fill effect of touch block. The fill effect can be a color or a photo.")
    ]
    
    static let imgEditMenuHelpInfo:[helpInfo] = [
        helpInfo(coverImage: UIImage(named:"cancel")!, description: "Exit image edit menu."),
        helpInfo(coverImage: UIImage(named:"photo")!, description: "Change this image."),
        helpInfo(coverImage: UIImage(named:"delete")!, description: "Delete this image."),
        helpInfo(coverImage: UIImage(named:"leftImage")!, description: "Set image to float on left of text."),
        helpInfo(coverImage: UIImage(named:"centerImage")!, description: "Set image to float on top of text."),
        helpInfo(coverImage: UIImage(named:"rightImage")!, description: "Set image to float on right of text."),
        helpInfo(coverImage: UIImage(named:"filter-icon-25207")!, description: "Set filter of image."),
        helpInfo(coverImage: UIImage(named:"border")!, description: "Set border of image.")
    ]
}
