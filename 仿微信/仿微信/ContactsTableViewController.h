//
//  ContactsTableViewController.h
//  仿微信
//
//  Created by Alan.Turing on 16/12/24.
//  Copyright © 2016年 Alan.Turing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController
{
    NSArray* contacts;
    NSMutableArray* cts_pinyin;
    NSMutableArray* cts_pinyinSorted;
    NSMutableDictionary* dict;
    NSMutableArray* dictKeys;
}

//@property(nonatomic, retain, readwrite) NSMutableArray* secTable;

- (NSString* ) getContactsNameByIndex:(NSUInteger) index;
- (NSUInteger) parseIndex:(NSString*) nameWithIndex;

@end
