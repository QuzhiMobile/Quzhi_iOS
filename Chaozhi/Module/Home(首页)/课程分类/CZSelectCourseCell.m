//
//  CZSelectCourseCell.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/7.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSelectCourseCell.h"

@interface CZSelectCourseCell ()
{
    UIButton *_selectBtn;
    UILabel *_titleLab;
}
@end

@implementation CZSelectCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(15), 0, WIDTH-autoScaleW(80), self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLab];
        
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-autoScaleW(35), (self.height-autoScaleW(20))/2.0, autoScaleW(20), autoScaleW(20))];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choose_active"] forState:UIControlStateSelected];
        [self addSubview:_selectBtn];
    }
    return self;
}

- (void)setContentWithModel:(CourseItem *)model {
    
    _titleLab.text = model.name;
    
    BOOL selectStatus = model.selectStatus;
    if (selectStatus == YES) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}

@end
