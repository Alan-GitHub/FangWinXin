//
//  ContactsTableViewController.m
//  仿微信
//
//  Created by Alan.Turing on 16/12/24.
//  Copyright © 2016年 Alan.Turing. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController
//@synthesize contacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    contacts = [[NSArray alloc] initWithObjects:@"严禄", @"杨辉", @"晓伟", @"志武", @"振宇", @"刘蓉", @"凯蓉",@"李跃鹏", @"吴书超", @"博士", @"官攀", @"董强", @"拉长", @"肖程飞", nil];
    
    //SLog(@"temp ref=%d", [temp retainCount]);
    //NSLog(@"contacts ref=%d", [contacts retainCount]);
    
    cts_pinyin = [[NSMutableArray alloc] init];
    cts_pinyinSorted = [[NSMutableArray alloc] init];
    dict = [[NSMutableDictionary alloc] init];
    dictKeys = [[NSMutableArray alloc] init];
    //self.secTable = [[NSMutableArray alloc] init];
    
    NSLog(@"cts_pinyin=%d", [cts_pinyin retainCount]);

    [self transformToPinyin];
    [self saveToDict];
}

- (void) saveToDict
{
    NSInteger i;
    char tagChar = 'a' - 1;
    char firstChar;
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    
    for(i = 0; i < cts_pinyinSorted.count; i++)
    {
        
        firstChar = [[cts_pinyinSorted objectAtIndex:i] characterAtIndex:0];
        if (firstChar != tagChar) {
            [dictKeys addObject:[NSString stringWithFormat:@"%c", firstChar]];
            
            if (i != 0) {
                [dict setValue:temp forKey:[NSString stringWithFormat:@"%c", tagChar]];
            }
            
            [temp release];
            temp = [[NSMutableArray alloc] init];
            tagChar = firstChar;
        }
        
        [temp addObject:[self getContactsNameByIndex:i]];
        //NSLog(@"namename=%@", [self getOriginNameByIndex:i]);
    }
    
    [dict setValue:temp forKey:[NSString stringWithFormat:@"%c", tagChar]];
    [temp release];
//    NSLog(@"dict =%@", self.dict);
    
//    for (i = 0 ; i < self.dictKeys.count; i++) {
//        NSLog(@"dictKeys =%@", [self.dictKeys objectAtIndex:i]);
//    }
//    NSLog(@"dictKeys =%@", self.dictKeys);

}

- (bool) transformToPinyin
{
    NSInteger i;
    //NSLog(@"contacts.count=%d", self.contacts.count);
    for(i=0; i<contacts.count; i++)
    {
         //取出元素
         NSString* name = [contacts objectAtIndex:i];
         //CFStringRef mm = CFSTR("杨辉");
         CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, name);
         CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
         CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
        
         //得到名字对应的拼音，没有空格
         NSString* namePinyin = [string stringByReplacingOccurrencesOfString: @" " withString: @""];
         NSString * indexString = [NSString stringWithFormat:@"%d", i];
         //在名字拼音后面加上索引，与存入的名字顺序对应
         namePinyin = [namePinyin stringByAppendingString:indexString];
        
        //将每一个名字的拼音作为一个元素，添加到可变数组中
        [cts_pinyin addObject:namePinyin];
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    cts_pinyinSorted = [cts_pinyin sortedArrayUsingDescriptors:descriptors];
    
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSUInteger) parseIndex:(NSString*) nameWithIndex
{
    //NSLog(@"nameWithIndex=%@, length=%d", nameWithIndex, nameWithIndex.length);
    char character;
    NSString* subIndexString;
    
    for (int i = 0; i < nameWithIndex.length; i++) {
        character = [nameWithIndex characterAtIndex:i];
        if(character >= '0' && character <= '9')
        {
            subIndexString = [nameWithIndex substringFromIndex:i];
            break;
        }
    }
    
    char* cStringIndex = [subIndexString cStringUsingEncoding:NSASCIIStringEncoding];
    int index = atoi(cStringIndex);
    
    return index;
}

- (NSString* ) getContactsNameByIndex:(NSUInteger) index
{
    NSString* pinyinSorted = [cts_pinyinSorted objectAtIndex:index];
    
    int contactsIndex = [self parseIndex:pinyinSorted];
    
    return [contacts objectAtIndex:contactsIndex];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //    NSLog(@"enter numberOfSectionsInTableView");
    
    return [dictKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //    NSLog(@"enter numberOfRowsInSection");
    
    //return [self.contacts count];
    NSString* secName = [dictKeys objectAtIndex:section];
    NSMutableArray* secTable = [dict valueForKey:secName];
    
    return secTable.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [[dictKeys objectAtIndex:section] uppercaseString];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"enter cellForRowAtIndexPath");
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //return cell;
    
    ///////////////
    static NSString *SimpleCellIdentifier = @"SimpleCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:SimpleCellIdentifier] autorelease];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    //NSLog(@"from getOriginNameByIndex: %@", [self getOriginNameByIndex:row]);
    NSString* secName = [dictKeys objectAtIndex:section];
    NSMutableArray* secTable = [dict valueForKey:secName];
    
    
    cell.textLabel.text = (NSString*)[secTable objectAtIndex:row];
    
    //UIImage *img = [UIImage imageNamed:[listImage objectAtIndex:row]];    //cell.imageView.image = img;
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) dealloc
{
    [contacts release];
    [cts_pinyin release];
    [cts_pinyinSorted release];
    [dict release];
    [dictKeys release];

    [super dealloc];
}

@end
