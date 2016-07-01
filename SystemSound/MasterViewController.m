//
//  MasterViewController.m
//  SystemSound
//
//  Created by aiquantong on 7/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "MasterViewController.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID sound = 0;

@interface MasterViewController ()

@property (nonatomic, retain) IBOutlet UITableView *mtableView;
@property (nonatomic, retain) NSArray *objects;

@end


@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    //    if (!self.objects) {
    //        self.objects = [[NSMutableArray alloc] init];
    //    }
    //    [self.objects insertObject:[NSDate date] atIndex:0];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *fileList = [fm contentsOfDirectoryAtPath:path error:&error];
    
    if (error == nil) {
        self.objects = fileList;
        [self.mtableView reloadData];
    }else{
        
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellName = @"MeEditCellIdentifier";
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:tableCellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCellName];
    }
    
    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.objects[indexPath.row];
    
    if (!sound) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",str];
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            if (error != kAudioServicesNoError) {
                sound = 0;
            }
        }
    }
    
    if (sound) {
        AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, soundAudioCallback, NULL);
        AudioServicesPlaySystemSound(sound);
    }
}

void soundAudioCallback()
{
    AudioServicesPlaySystemSound(sound);
    sound = 0;
}

@end



