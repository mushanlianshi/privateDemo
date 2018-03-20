//
//  LBMessageCell.m
//  LBSamples
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//
#define margin 5
#define cellHeight 70
#define kPhoneFont [UIFont boldSystemFontOfSize:13]
#define kLabelFont [UIFont systemFontOfSize:13]
#import "LBMessageCell.h"
#import "LBMessageModel.h"
@interface LBMessageCell(){
    UIImageView *selectView;
    UIImageView *iconView;
    UILabel *phoneLabel;
    UILabel *contentLabel;
    UILabel *dateLabel;
    UIImageView *arrowView;
    
    UIButton *deleteButton;
}
@end
@implementation LBMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        selectView=[[UIImageView alloc] init];
        [self.contentView addSubview:selectView];
        
        iconView=[[UIImageView alloc] init];
        iconView.clipsToBounds=YES;
        [self.contentView addSubview:iconView];
        
        phoneLabel=[[UILabel alloc] init];
        phoneLabel.font=kPhoneFont;
        [self.contentView addSubview:phoneLabel];
        
        contentLabel=[[UILabel alloc] init];
        contentLabel.textColor=[UIColor lightGrayColor];
        contentLabel.numberOfLines=2;
        contentLabel.font=kLabelFont;
        [self.contentView addSubview:contentLabel];
        
        dateLabel=[[UILabel alloc] init];
        dateLabel.font=kLabelFont;
        dateLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:dateLabel];
        
        arrowView=[[UIImageView alloc] init];
        [self.contentView addSubview:arrowView];
        
        
        //为了遮盖原来的样式的
//        UIView *backView=[[UIView alloc] init];
//        backView.backgroundColor=[UIColor whiteColor];
//        [self.contentView addSubview:backView];
//        [backView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.left.equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
//            make.top.bottom.equalTo(self.contentView);
//            make.width.mas_offset(80);
//        }];
//        
//        deleteButton=[[UIButton alloc] init];
//        [deleteButton showBorderWithRedColor];
//        deleteButton.titleLabel.text=@"删除";
//        deleteButton.titleLabel.textColor=[UIColor redColor];
//        [backView addSubview:deleteButton];
//        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.equalTo(self.contentView.mas_right);
//            make.center.equalTo(backView);
//            make.width.height.mas_equalTo(40);
//        }];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"LBLog layoutSubviews frame is %@ ",NSStringFromCGRect(self.contentView.frame));
//    CGRect rect=self.bounds;
//    rect.size.width=ScreenWidth;
//    self.bounds=rect;
    [self setModelWithRightSize:_model];
    
}
-(void)setModel:(LBMessageModel *)model{
    _model=model;
}
/**
 * 因为初始化的时候  cell还没有显示出来   还是默认的尺寸320*44 
 * 1.我们需要在layoutsubviews显示出来正确的尺寸后设置
 * 2.就是初始化的时候按屏幕的宽度来设置控件的位置  不是self.contentView.bounds.size.width
 */
-(void)setModelWithRightSize:(LBMessageModel *)model{
    CGFloat cellWidth=self.contentView.bounds.size.width;
    if (model.isSelecting) {
        selectView.image=ImageNamed(@"checkbox_off");
        if (model.isSelected) selectView.image=ImageNamed(@"checkbox_on");
        selectView.frame=CGRectMake(2*margin, (cellHeight-selectView.image.size.height)/2, selectView.image.size.width, selectView.image.size.height);
    }else{
        selectView.frame=CGRectZero;
    }
//    NSLog(@"selectView frame is %@ ",NSStringFromCGRect(selectView.frame));
    iconView.image=ImageNamed(model.icon);
    iconView.frame=CGRectMake(CGRectGetMaxX(selectView.frame)+margin, (cellHeight-iconView.image.size.height)/2, iconView.image.size.width, iconView.image.size.height);
    iconView.layer.cornerRadius=iconView.image.size.width/2;
    
    
    phoneLabel.text=model.telephone;
    CGSize phoneSize=[self getWidthWithString:model.telephone];
    phoneLabel.frame=(CGRect){{CGRectGetMaxX(iconView.frame)+2*margin,margin},{phoneSize.width+2*margin,phoneSize.height}};
    
    arrowView.image=ImageNamed(@"arrow");
    if(model.isSelecting){
        arrowView.frame=CGRectZero;
    }else{
        arrowView.frame=CGRectMake(cellWidth-arrowView.image.size.width-2*margin, margin, arrowView.image.size.width, arrowView.image.size.height);
    }
    
    dateLabel.text=model.date;
    CGFloat dateWidth=[self getWidthWithString:model.date].width;
    dateLabel.frame=(CGRect){{cellWidth-arrowView.frame.size.width-dateWidth-4*margin,margin},[self getWidthWithString:model.date]};
    
    
    contentLabel.text=model.content;
    CGFloat contentWidth=cellWidth-CGRectGetMaxX(iconView.frame);
    CGSize contentSize=[self getWidthWithString:model.content];
    //靠上显示  一行
    if (contentSize.width<contentWidth) {
        contentLabel.frame=CGRectMake(CGRectGetMaxX(iconView.frame)+2*margin, CGRectGetMaxY(phoneLabel.frame)+margin, contentWidth, contentSize.height);
    }else{
        contentLabel.frame=CGRectMake(CGRectGetMaxX(iconView.frame)+2*margin, CGRectGetMaxY(phoneLabel.frame), contentWidth-4*margin, self.contentView.bounds.size.height-CGRectGetMaxY(phoneLabel.frame)-margin);
    }
    
//    deleteButton.bounds=CGRectMake(0, 0, 40, 40);
//    deleteButton.center=CGPointMake(cellWidth+20, self.contentView.center.y);
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

-(CGSize)getWidthWithString:(NSString *)string{
   CGRect rect= [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kLabelFont} context:nil];
    return rect.size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
