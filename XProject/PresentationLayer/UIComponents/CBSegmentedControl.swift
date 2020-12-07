//
//  CBSegmentedControl.swift
//  XProject
//
//  Created by Максим Локтев on 29.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Segmentio

class CBSegmentedControl {
    
    var horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions {
        SegmentioHorizontalSeparatorOptions(type: .bottom,
                                            height: 1,
                                            color: UIColor.clear)
    }
    
    var verticalSeparatorOptions: SegmentioVerticalSeparatorOptions {
        SegmentioVerticalSeparatorOptions(ratio: 0.5,
                                          color: UIColor.clear)
    }
    
    var indicatorOptions: SegmentioIndicatorOptions {
        SegmentioIndicatorOptions(type: .bottom,
                                  ratio: 0.85,
                                  height: 3,
                                  color: UIColor.darkSkyBlue)
    }
    
    var states: SegmentioStates {
        SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: UIColor.clear,
                titleFont: UIFont.systemFont(ofSize: 19, weight: .regular),
                titleTextColor: UIColor.black
            ),
            selectedState: SegmentioState(
                backgroundColor: UIColor.clear,
                titleFont: UIFont.boldSystemFont(ofSize: 19),
                titleTextColor: UIColor.black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.clear,
                titleFont: UIFont.boldSystemFont(ofSize: 19),
                titleTextColor: UIColor.black
            )
        )
    }
    
    var options: SegmentioOptions {
        SegmentioOptions(backgroundColor: .white,
                         segmentPosition: .fixed(maxVisibleItems: 2),
                         scrollEnabled: false,
                         indicatorOptions: self.indicatorOptions,
                         horizontalSeparatorOptions: self.horizontalSeparatorOptions,
                         verticalSeparatorOptions: self.verticalSeparatorOptions,
                         imageContentMode: .center,
                         labelTextAlignment: .center,
                         labelTextNumberOfLines: 0,
                         segmentStates: self.states)
    }
}
