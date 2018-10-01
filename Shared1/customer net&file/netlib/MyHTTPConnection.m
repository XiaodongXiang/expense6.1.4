//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import "MyHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "AsyncSocket.h"
#import "ZipArchive.h"
#import <sqlite3.h>
#import <Parse/Parse.h>
#import "PokcetExpenseAppDelegate.h"
#import "Payee.h"
#import "Accounts.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#define OLDUSERDATA @"oldUserData"
#define FIRSTLAUNCHSINCEBACKUPOLDUSERDATA @"FirstLanchSinceBackupOldUserData"
#define NEWUSEDATA  @"newUserData"
#define FIRSTLAUNCHSINCEBACKUPNEWDATA @"FirstLanchSinceBackupNewUserData"
#import "ParseDBManager.h"
#import "User.h"
#import <Parse/Parse.h>
@implementation MyHTTPConnection
@synthesize isNext;
 /**
 * Returns whether or not the requested resource is browseable.
 **/
- (BOOL)isBrowseable:(NSString *)path
{
	// Override me to provide custom configuration...
	// You can configure it for the entire server, or based on the current request
	
	return YES;
}


/**
 * This method creates a html browseable page.
 * Customize to fit your needs
 **/
//-------在页面中 点击back up 产生压缩包
-(void)createZipFile:(NSString*)path
{
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
    //更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/Expense5Bak.zip"];

	
	ZipArchive* zipFile = [[ZipArchive alloc] init];
	BOOL ret=[zipFile CreateZipFile2:path2];
    
	while(!ret)
	{
		[fileManager createFileAtPath:path2 contents:nil attributes:nil];
		ret=[zipFile CreateZipFile2:path2];
	}
	
    for (NSString *fname in array)
    {
		NSLog(@"fname....................%@.....................", fname);
        NSString* a=[path stringByAppendingString:[NSString stringWithFormat:@"/%@", fname]];
        ret =[zipFile addFileToZip:a newname:[fname stringByAppendingString:@".p"]];

	}
	if( ret)
	{
		[zipFile CloseZipFile2];
		[zipFile release];
	}
	else
	{
		[zipFile release];
	}

	
}
-(BOOL)hasZipFile:(NSString*)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* a=[[path stringByAppendingString:@"/"] stringByAppendingString:@"PocketExpenseBak.zip"];
    
    NSLog(@"Aa是不是 app doc下的路径:%@",a);
    
	BOOL relust=[fileManager fileExistsAtPath:a];
	return relust;
}

//3...创建压缩文件
- (NSString *)createBrowseableIndex:(NSString *)path
{
	static BOOL isFrist=YES;
	PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	if(!appDelegate.isRestore)
	{
		dpath=path;
		NSError * error = nil;
		if([self hasZipFile:path])
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString* a=[[path stringByAppendingString:@"/"] stringByAppendingString:@"PocketExpenseBak.zip"];
			[fileManager removeItemAtPath:a error:&error];
		}
		[self createZipFile:path];
		isFrist=NO;
		appDelegate.isRestore = FALSE;

	}
	NSMutableString *outdata = [NSMutableString new];
	
	if ([self supportsPOST:path withSize:0])
    {
		NSString *path3 = [[NSBundle mainBundle] pathForResource:@"pocketExpense" ofType:@"html"];
        NSString* str=[NSString stringWithContentsOfFile:path3 encoding:NSUTF8StringEncoding error:nil];
		[outdata appendFormat:str,nil];
	}
	//	[outdata appendString:@"</body></html>"];

    return [outdata autorelease];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)relativePath
{
	if ([@"POST" isEqualToString:method])
	{
		return YES;
	}
	
	return [super supportsMethod:method atPath:relativePath];
}


/**
 * Returns whether or not the server will accept POSTs.
 * That is, whether the server will accept uploaded data for the given URI.
 **/
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
	dataStartIndex = 0;
	multipartData = [[NSMutableArray alloc] init];
	postHeaderOK = FALSE;
	return YES;
}


/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
 **/

//2......
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	NSLog(@"httpResponseForURI: method:%@ path:%@", method, path);
	NSData *requestData = [(NSData *)CFHTTPMessageCopySerializedMessage(request) autorelease];
	
	NSString *requestStr = [[[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"\n=== Request ====================\n%@\n================================", requestStr);
	
	if (requestContentLength > 0)  // Process POST data
	{
		
		if ([multipartData count] < 2) return nil;
		
		NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes]
													  length:[[multipartData objectAtIndex:1] length]
													encoding:NSUTF8StringEncoding];
		
		NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
		postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
		postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
		NSString* filename = [postInfoComponents lastObject];
		
		if (![filename isEqualToString:@""]) //this makes sure we did not submitted upload form without selecting file
		{
			UInt16 separatorBytes = 0x0A0D;
			NSMutableData* separatorData = [NSMutableData dataWithBytes:&separatorBytes length:2];
			[separatorData appendData:[multipartData objectAtIndex:0]];
			long l = [separatorData length];
			int count = 2;	//number of times the separator shows up at the end of file data
			
			NSFileHandle* dataToTrim = [multipartData lastObject];
			NSLog(@"data: %@", dataToTrim);
			
			for (unsigned long long i = [dataToTrim offsetInFile] - l; i > 0; i--)
			{
				[dataToTrim seekToFileOffset:i];
				if ([[dataToTrim readDataOfLength:l] isEqualToData:separatorData])
				{
					[dataToTrim truncateFileAtOffset:i];
					i -= l;
					if (--count == 0) break;
				}
			}
			
			NSLog(@"NewFileUploaded");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NewFileUploaded" object:nil];
		}
		
		for (int n = 1; n < [multipartData count] - 1; n++)
			NSLog(@"%@", [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:n] bytes] length:[[multipartData objectAtIndex:n] length] encoding:NSUTF8StringEncoding]);
		
		[postInfo release];
		[multipartData release];
		requestContentLength = 0;
		
	}
	
	NSString *filePath = [self filePathForURI:path];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return [[[HTTPFileResponse alloc] initWithFilePath:filePath] autorelease];
	}
	else
	{
		NSString *folder = [[server documentRoot] path];//[path isEqualToString:@"/"] ? [[server documentRoot] path] : [NSString stringWithFormat: @"%@%@", [[server documentRoot] path], path];
		
		if ([self isBrowseable:folder])
		{
			NSData *browseData = [[self createBrowseableIndex:folder] dataUsingEncoding:NSUTF8StringEncoding];
			return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
		}
	}
	
	return nil;
}


/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
 **/
- (void)processDataChunk:(NSData *)postDataChunk
{
	PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	appDelegate.isRestore = TRUE;
	multipartData = [[NSMutableArray alloc] init];
	[multipartData removeAllObjects];
	if (!postHeaderOK)
	{
		UInt16 separatorBytes = 0x0A0D;
		NSData* separatorData = [NSData dataWithBytes:&separatorBytes length:2];
		
		long l = [separatorData length];
		for (int i = 0; i < [postDataChunk length] - l; i++)
		{
			NSRange searchRange = {i, l};
			
			if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
			{
				NSRange newDataRange = {dataStartIndex, i - dataStartIndex};
				dataStartIndex = i + l;
				i += l - 1;
				NSData *newData = [postDataChunk subdataWithRange:newDataRange];
				
				if ([newData length])
				{
					[multipartData addObject:newData];
				}
				else
				{
					postHeaderOK = TRUE;
					NSError * errors;
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
					NSString *path = [paths objectAtIndex:0];
					NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
					NSFileManager *fileManager = [NSFileManager defaultManager];
					
					for (NSString *fname in array)
					{
						if([fname length]>4)
						{
							if([[fname substringFromIndex:[fname length]-4] isEqualToString:@".zip"])
							{
								[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fname] error:&errors];
							}
						}
					}
					NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
					NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
					
					postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
					postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];//					NSFileManager *fileManager = [NSFileManager defaultManager];
					
					NSString* filename = [[[server documentRoot] path] stringByAppendingPathComponent:[postInfoComponents lastObject]];
					
					//获取文件路径
					[postInfo stringByReplacingOccurrencesOfString:filename withString:@"Update.zip"];
					
					NSRange fileDataRange = {dataStartIndex, [postDataChunk length] - dataStartIndex};
					[[NSFileManager defaultManager] createFileAtPath:filename contents:[postDataChunk subdataWithRange:fileDataRange] attributes:nil];
					NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filename] retain];					
					if (file)
					{
						[file seekToEndOfFile];
						[multipartData addObject:file];
					}
					[postInfo release];
					[self writeSqliteFile];
					[self sureFileRight];
					break;
				}
			}
		}
	}
	else
	{
		[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
	}
	
}

-(void)writeSqliteFile
{
	NSString * device = [[UIDevice currentDevice] model];
	if ([[device substringToIndex:4] isEqualToString:@"iPad"] ) 
	{
        
        [self retain];
//	AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];//appDelegate1
		
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Confirm restore", nil)
                                                         message:NSLocalizedString(@"VC_Do you want to restore Pocket Expense with the uploaded backup? All current data will be ERASED and REPLACED with the backup, this cannot be undone.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                               otherButtonTitles:NSLocalizedString(@"VC_Restore", nil),nil];
        alert.tag = 0;
        [alert show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alert;
        [alert release];

        
	}
	else
    {
        //???为什么这里被释放了一次？
        [self retain];
//		AppDelegate_iPhone * appDelegate1 = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];//appDelegate1

		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Confirm restore", nil)
                                                         message:NSLocalizedString(@"VC_Do you want to restore Pocket Expense with the uploaded backup? All current data will be ERASED and REPLACED with the backup, this cannot be undone.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                               otherButtonTitles:NSLocalizedString(@"VC_Restore", nil),nil];
        alert.tag = 0;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alert;
        [alert show];
        [alert release];
		
	}

}

-(void)getOldDataBaseInsertToNewDataBase{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *oldPath2=[documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite.p"];
    BOOL hasOldPasscode;
    if ([fileManager fileExistsAtPath:oldPath2]) {
        hasOldPasscode = YES;
    }
    else
        hasOldPasscode = NO;
    [appDelegate.epdc getOldDataBaseInsertToNewDataBase_isBackup:YES];
    if(hasOldPasscode)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Pocket Expense data restore complete", nil)
                                                          message:NSLocalizedString(@"VC_You must now quit Pocket Expense and re-launch for the new changes to take effect.", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        [alertView release];

    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
    {
        if(buttonIndex == 0)
            return;
        else {
            PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            
            [appDelegate.appAlertView release];
            
//            [self restoreDelete];
            
            //获取文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
            NSError * errors;
            NSArray *array1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&errors];
            
            BOOL isOldDataBase = NO;
            for (NSString *fname in array1)
            {
                if ([fname length]>=20) {
                    if([[fname substringFromIndex:[fname length]-20] isEqualToString:@"PocketExpenseBak.zip"])
                    {
                        isOldDataBase = YES;
                        break;
                    }
                }
                
            }
            
            NSString *path2 = nil;
            if (isOldDataBase) {
                path2= [documentsDirectory stringByAppendingPathComponent:@"/PocketExpenseBak.zip"];
            }
            else{
                path2= [documentsDirectory stringByAppendingPathComponent:@"/Expense5Bak.zip"];
            }
            ZipArchive* zipFile = [[ZipArchive alloc] init];
            [zipFile UnzipOpenFile:path2];
            
            BOOL ret=[zipFile UnzipFileTo:documentsDirectory overWrite:YES];
            [zipFile UnzipCloseFile];
            [zipFile release];
            [self deleteCutemFile];
            
            //若解压出来了
            if(ret)
            {
                NSString * newPath = nil;
                NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&errors];
                if (isOldDataBase) {
                    for (NSString *fname in array)
                    {
                        if([fname length]>=27)
                        {
                            if([[fname substringFromIndex:[fname length]-27] isEqualToString:@"PocketExpense1.0.0.sqlite.p"])
                            {
                                newPath = fname;
                                isOldDataBase = YES;
                                break;
                            }
                        }
                    }
                    
                }
                else{
                    for (NSString *fname in array)
                    {
                        if([fname length]>=21)
                        {
                            if([[fname substringFromIndex:[fname length]-21] isEqualToString:@"Expense5.0.0.sqlite.p"])
                            {
                                newPath = fname;
                                break;
                            }
                        }
                    }
                    
                }
                
                if (isOldDataBase && newPath!= nil) {
                    [self getOldDataBaseInsertToNewDataBase];
                }
                else if(!isOldDataBase && newPath!=nil)
                {
                    //先关闭dropbox
                    if (appDelegate.dropbox.drop_account)
                    {
                        [appDelegate.dropbox linkDropBoxAccount:NO fromViewController:self];
                    }
                    newPath = [documentsDirectory stringByAppendingPathComponent:newPath];
                    NSDateFormatter * format = [[NSDateFormatter alloc] init];
                    [format setDateStyle:NSDateFormatterMediumStyle];
                    [format setTimeStyle:NSDateFormatterShortStyle];
                    
                    NSString * sqlPath = [documentsDirectory stringByAppendingPathComponent:@"Expense5.0.0.sqlite"];
                    [fileManager removeItemAtPath:sqlPath error:&errors];
                    
                    NSString *NewToFilePath = [documentsDirectory stringByAppendingPathComponent:@"Expense5.0.0.sqlite"];
                    [fileManager moveItemAtPath:newPath toPath:NewToFilePath error:&errors];
                    
                    
                    
                    //添加-wal和-shm文件
                    //先移除掉之前的文件
                    NSString * sqlwalPath = [documentsDirectory stringByAppendingPathComponent:@"Expense5.0.0.sqlite-wal"];
                    [fileManager removeItemAtPath:sqlwalPath error:&errors];
                    
                    NSString *newwalPath = [documentsDirectory stringByAppendingString:@"/Expense5.0.0.sqlite-wal"];
                    NSString *currentwalzaPaht = [documentsDirectory stringByAppendingString:@"/Expense5.0.0.sqlite-wal.p"];
                    [fileManager moveItemAtPath:currentwalzaPaht toPath:newwalPath error:&errors];
                    
                    NSString * sqlshmPath = [documentsDirectory stringByAppendingPathComponent:@"Expense5.0.0.sqlite-shm"];
                    [fileManager removeItemAtPath:sqlshmPath error:&errors];
                    NSString *newshmPath = [documentsDirectory stringByAppendingString:@"/Expense5.0.0.sqlite-shm"];
                    NSString *currentshmzaPaht = [documentsDirectory stringByAppendingString:@"/Expense5.0.0.sqlite-shm.p"];
                    NSString *currentBank = [documentsDirectory stringByAppendingString:@"/Expense5Bak.zip"];
                    [fileManager removeItemAtPath:currentBank error:&errors];
                    
                    [fileManager moveItemAtPath:currentshmzaPaht toPath:newshmPath error:&errors];
                    
                    
                    //5.0数据库restore,需要覆盖数据库中的数据
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:FIRSTLAUNCHSINCEBACKUPNEWDATA forKey:NEWUSEDATA];
                    //如果不立即更新的话，可能会导致这个值不会立即存进去
                    [userDefaults synchronize];
                    
                    
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Pocket Expense data restore complete", nil)
                                                                      message:NSLocalizedString(@"VC_You must now quit Pocket Expense and re-launch for the new changes to take effect.", nil)
                                                                     delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                            otherButtonTitles:nil];
                    alertView.tag = 1;
                    [alertView show];
                    [alertView release];
                    [fileManager removeItemAtPath:path2 error:&errors];
                    [fileManager removeItemAtPath:newPath error:&errors];
                    [format release];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
                                                                     message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
                                                                    delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
                    [alert show];
                    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                    appDelegate.appAlertView = alert;
                    [alert release];
                }
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
                                                                 message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
                                                                delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
                [alert show];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.appAlertView = alert;
                [alert release];
            }
            
        }
        
    }
    else if(alertView.tag == 1)
    {
        exit(1);
    }
}
-(BOOL)sureFileRight
{
	BOOL relust=NO;
	return YES;
	NSString*	fileName;
	
	NSString*	filepath = [[NSBundle mainBundle] pathForResource:@"Version" ofType:@"plist"];
	NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filepath];
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
    for (NSString *fname in array)
    {
		fileName=fname;
		for(id version in dictionary)
		{
			NSString* v=(NSString*)version;
			NSString*	value=[dictionary valueForKey:v];
			if([fileName compare:value]==NSOrderedSame)
			{
				relust=YES;
			}
		}
	}
	[dictionary release];
	return relust;
	
}
-(void)deleteCutemFile
{
	NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* path=[paths objectAtIndex:0];
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
	
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	
	for (NSString *fname in array)
    {
		if([fname compare:@"Update.zip"]==NSOrderedSame)
		{
//			NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath: [path stringByAppendingPathComponent:fname] error: &errors];
            //[[NSFileManager defaultManager] fileAttributesAtPath:[path stringByAppendingPathComponent:fname] traverseLink:NO];
			[fileManager removeItemAtPath:fname error:nil];
		}
	}
	
}
-(void)editedTimeChange
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:appDelegate.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[appDelegate.managedObjectContext executeFetchRequest:requestLocal error:&error];
        for (int j=0; j<datas.count; j++)
        {
            switch (i) {
        case 0:
            {
                if (datas.count!=0)
                {
                    Accounts *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];
                }
            }
            break;
        case 1:
            {
                if (datas.count!=0)
                {
                    AccountType *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];
                }
            }
            break;
        case 2:
            {
                if (datas.count!=0)
                {
                    BudgetItem *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 3:
            {
                if (datas.count!=0)
                {
                    BudgetTemplate *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 4:
            {
                if (datas.count!=0)
                {
                    BudgetTransfer *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 5:
            {
                if (datas.count!=0)
                {
                    Category *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 6:
            {
                if (datas.count!=0)
                {
                    EP_BillItem *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 7:
            {
                if (datas.count!=0)
                {
                    EP_BillRule *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 8:
            {
                if (datas.count!=0)
                {
                    Payee *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
                
            }
            break;
        case 9:
            {
                if (datas.count!=0)
                {
                    Transaction *object=[datas objectAtIndex:0];
                    object.updatedTime=[NSDate date];
                    [appDelegate.managedObjectContext save:&error];

                }
            }
            break;
        default:
            break;
            }
        }
    }
}

#pragma mark - 还原数据的方法
-(void)localAllToServer
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //修改user时间
    NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
    NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
    requestUser.entity=descUser;
    NSError *error;
    NSArray *arrayUser=[appDelegate.managedObjectContext executeFetchRequest:requestUser error:&error];
    User *user=[arrayUser objectAtIndex:0];
    user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
    [appDelegate.managedObjectContext save:&error];
    
    [[ParseDBManager sharedManager]dataSyncWithServer];
}




@end