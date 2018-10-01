//
//  FrequencyViewController.m
//  PillTracker
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "CurrencyTypeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ColorLabelView.h"

@implementation CurrencyTypeViewController

@synthesize selectedCurrency;
@synthesize filteredFrequency;
@synthesize currencyNameArray;
@synthesize currencyArray;
@synthesize managedObjectContext;
@synthesize symbolArray,nameArray;
@synthesize selectIndexPath;
#pragma mark -
#pragma mark Custom Methods
-(NSMutableArray*)filteredFrequency
{
	if (filteredFrequency != nil)
	{
		[filteredFrequency removeAllObjects];
		filteredFrequency = nil;
	}
	filteredFrequency = [[NSMutableArray alloc] init];
	return filteredFrequency;
}
//
-(void)cancelPressed
{
 	
	[self.navigationController popViewControllerAnimated:YES];
}

 


#pragma mark TableView Events
-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = currencyArray.count;
    return numberOfRows;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
	static NSString *Identifier = @"CurrencyCell";
	CurrencyCell *cell = (CurrencyCell *)[self.tableView dequeueReusableCellWithIdentifier:Identifier];
	if (cell == nil) 
	{
        cell = [[CurrencyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier] ;
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	//[self configureCell:cell atIndexPath:indexPath];
	NSString* symbol =(NSString *) [self.symbolArray objectAtIndex:indexPath.row];
	NSString* name =[NSString stringWithFormat:@" - %@",[self.nameArray objectAtIndex:indexPath.row]];
    if ([self.selectedCurrency isEqualToString:[self.currencyNameArray objectAtIndex:indexPath.row]])
	{
		selectIndexPath = indexPath.row;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else 
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.nameLabel.text = name;
    cell.nameLabel.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    
	cell.symbolLabel.text = symbol;
    cell.symbolLabel.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    
    if (indexPath.row == [self.nameArray count]-1)
    {
        cell.bgImageView.image = [UIImage imageNamed:@"cell_j2_320_44.png"];
    }
    else
    {
        cell.bgImageView.image = [UIImage imageNamed:@"cell_j1_320_44.png"];

    }
    cell.tintColor=[UIColor colorWithRed: 99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
	return cell;//
}

 
 
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* freq =(NSString *) [self.currencyNameArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	appDelegate.settings.currency = freq;
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}	
    [appDelegate.epnc setCurrenyStrBySettings];

 	selectIndexPath = indexPath.row;
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark System Events
-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 450.0);
}

-(void) viewDidLoad
{	
	[super viewDidLoad];
    
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Currency", nil);
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	managedObjectContext = [appDelegate managedObjectContext];
    
    self.tableView.separatorColor = RGBColor(226, 226, 226);



 	currencyArray  = [[NSMutableArray alloc] init];
	currencyNameArray  = [[NSMutableArray alloc] init];
	currencyNameArray = [NSMutableArray arrayWithObjects:
						  //A
						  @"Lek - Albanian Lek", @"Kz - Angolan Kwanza", @"$ - Argentine Peso", 
						  @"դր. - Armenian Dram", @"Afl. - Aruban Florin", @"$ - Australian Dollar",
						  @"AZN - Azerbaijanian Manat",@"د.ج - Algerian Dinar",@"؋ - Afghan Afghani",
						  //B
						  @"B$ - Bahamian Dollar", @"৳ - Bangladeshi Taka", 
						  @"Bds$ - Barbadian Dollar", @"BYR - Belarusian Ruble", @"$ - Belize Dollar",
						  @"BD$ - Bermudan Dollar", @"Nu. - Bhutanese Ngultrum", @"Bs - Bolivian Boliviano",
						  @"KM - Bosnia-Herzegovina", @"P - Botswanan Pula", @"R$ - Brazilian Real", 
						  @"£ - British Pound Sterling", @"$ - Brunei Dollar", @"лв. - Bulgarian Lev", 
						  @"FBu - Burundian Franc",@"BHD - Bahraini Dinar",
						  //C
						  @"$ - Canadian Dollar", @"$ - Cape Verde Escudo", @"$ - Cayman Islands Dollars", 
						  @"CFA - CFA Franc BCEAO", @"FCFA - CFA Franc BEAC", @"F - CFP Franc",
						  @"$ - Chilean Peso", @"¥ - Chinese Yuan Renminbi", @"$ - Colombian Peso",
						  @"CF - Comorian Franc", @"F - Congolese Franc", @"₡ - Costa Rican colón", @"Kn - Croatian Kuna", 
						  @"$MN - Cuban Peso", @"Kč - Czech Republic Koruna",@"؋ - Cambodian Riel",
						  //D
						  @"kr - Danish Krone", @"$ - Djiboutian Franc", @"RD$ - Dominican Peso",
						  //E
						  @"$ - East Caribbean Dollar", @"$ - Eritrean Nakfa", @"kr - Estonian Kroon",
						  @"$ - Ethiopian Birr", @"€ - Euro",@"ج.م - Egyptian Pound",
						  //F
						  @"£ - Falkland Islands Pound", @"FJ$ - Fijian Dollar",
						  //G
						  @"D - Gambia Dalasi", @"GEL - Georgian Lari", @"GH¢ - Ghanaian Cedi", 
						  @"£ - Gibraltar Pound", @"Q - Guatemalan Quetzal", @"FG - Guinean Franc", @"F$ - Guyanaese Dollar",
						  //H
						  @"G - Haitian Gourde", @"L - Honduran Lempira", @"$ - Hong Kong Dollar", @"Ft - Hungarian Forint",
						  //I
						  @"kr. - Icelandic króna", @"₹ - Indian Rupee", @"Rp - Indonesian Rupiah", @"₪ - Israeli New Sheqel",
						  @"ع.د - Iraqi Dinar",@"﷼ - Iranian Rial",
						  //J
						  @"J$ - Jamaican Dollar", @"￥ - Japanese Yen",@"د.ا - Jordanian Dinar",
						  //K
						  @"〒 - Kazakhstani Tenge", @"KSh - Kenyan Shilling", @"KGS - Kyrgystani Som",@"د.ك - Kuwaiti Dinar",
						  //L
						  @"₭ - Laotian Kip", @"Ls - Latvian Lats", @"L - Lesotho Loti", @"L$ - Liberian Dollar", 
						  @"Lt - Lithuanian Litas",@"ل.ل - Lebanese Pound",@"ل.د - Libyan Dinar",
						  //M
						  @"MOP - Macanese Pataca", @"MDen - Macedonian Denar", @"MGA - Madagascar Ariary",
						  @"MK - Malawian Kwacha", @"RM - Malaysian Ringgit", @"MRf - Maldive Islands Rufiyaa",
						  @"R - Mauritian Rupee", @"UM - Mauritanian Ouguiya", @"$ - Mexican Peso", @"MDL - Moldovan Leu", 
						  @"₮ - Mongolian Tugrik", @"MTn - Mozambican Metical", @"K - Myanma Kyat",@"د.م. - Moroccan Dirham",
						  //N
						  @"N$ - Namibian Dollar", @"रू. - Nepalese Rupee", @"ƒ - Netherlands Antillean Guilder", 
						  @"NT$ - New Taiwan Dollar", @"$ - New Zealand Dollar", @"₦ - Nigerian Naira", @"C$ - Nicaraguan Cordoba Oro",
						  @"₩ - North Korean Won", @"kr - Norwegian Krone",
						  //O
						  @"ر.ع. - Omani Rial",
						  //P
						  @"PKR - Pakistani Rupee", @"PAB - Panamanian Balboa", @"K - Papua New Guinea Kina", @"PYG - Paraguayan Guarani", 
						  @"PEN - Peruvian Nuevo Sol", @"₱ - Philippine Peso", @"zł - Polish Zloty", @"£ - Pound",
						  //Q
						  @"ر.ق - Qatari Rial",
						  //R
						  @"lei - Romanian Leu", @"руб. - Russian Ruble", @"RF - Rwandan Franc",
						  //S
						  @"£ - Saint Helena Pound", @"Db - São Tomé and Príncipe", @"RSD - Serbian Dinar", @"SR - Seychelles Rupee", 
						  @"Le - Sierra Leonean Leone", @"$ - Singapore Dollar", @"SI$ - Solomon Islands Dollar", @"$ - Somali Shilling", 
						  @"₩ - Sorth Korean Won", @"R - South African Rand", @"LKR - Sri Lanka Rupee", @"SDG - Sudanese Pound",
						  @"$ - Surinamese Dollar", @"L - Swazi Lilangeni", @"kr - Swedish Krona", @"SFr. - Swiss Franc",
						  @"ر.س - Saudi Riyal",@"ل.س - Syrian Pound",
						  //T
						  @"TJS - Tajikistani Somoni", @"TSh - Tanzanian Shilling", @"฿ - Thai Baht", @"T$ - Tonga Pa‘anga",
						  @"TT$ - Trinidad and Tobago", @"TRY - Turkish Lira",@"د.ت - Tunisian Dinar",
						  //U
						  @"USh - Ugandan Shilling", @"rpH. - Ukrainian Hryvnia", @"COU - Unidad de Valor Real", @"$U - Uruguay Peso",
						  @"$ - US Dollar", @"so‘m - Uzbekistan Som",@"د.إ - United Arab Emirates",
						  //V
						  @"Vt - Vanuatu Vatu", @"BsF - Venezuelan Bolivar Fuerte", @"₫ - Vietnamese Dong",
						  //W
						  @"WS$ - Samoabn Tala",
						  //Y
						  @"﷼ - Yemeni Rial",
						  //Z
						  @"ZK - Zambian Kwacha",
						  nil] ;
	symbolArray = [[NSMutableArray alloc] init];
	nameArray = [[NSMutableArray alloc] init];
	for (int i = 0; i<[currencyNameArray count]; i++) 
	{
		NSArray * seprateSrray = [[currencyNameArray objectAtIndex:i] componentsSeparatedByString:@" - "];
		[symbolArray addObject:[seprateSrray objectAtIndex:0]];
		[nameArray addObject:[seprateSrray objectAtIndex:1]];
	}
	for (int i = 0; i<[currencyNameArray count]; i++) 
	{
		UIView * pickerLabelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 44.0)];
		pickerLabelView.backgroundColor = [UIColor clearColor];
		[pickerLabelView setAutoresizingMask:UIViewAutoresizingNone];
		ColorLabelView *currencyViewSymbol = [[ColorLabelView alloc] initWithFrame:CGRectMake(40.0, 0.0, 45.0, 44.0)];
		currencyViewSymbol.colorLabel.text = [symbolArray objectAtIndex:i];//[currencyNameArray objectAtIndex:i];
		[currencyViewSymbol.colorLabel setTextColor:[UIColor colorWithRed:46.f/255 green:46.f/255 blue:46.f/255 alpha:1.f]];
		[currencyViewSymbol.colorLabel setTextAlignment:NSTextAlignmentRight];
		[currencyViewSymbol setAutoresizingMask:UIViewAutoresizingNone];
		[pickerLabelView addSubview:currencyViewSymbol.colorLabel];
		[currencyViewSymbol.colorLabel setFrame:CGRectMake(0.0, 0.0, 50.0, 44.0)];
		
		ColorLabelView *currencyViewName = [[ColorLabelView alloc] initWithFrame:CGRectMake(85.0, 0.0, 180.0, 44.0)];
		[currencyViewName setFrame:CGRectMake(85.0, 0.0, 180.0, 44.0)];
		currencyViewName.colorLabel.text = [NSString stringWithFormat:@" - %@",[nameArray objectAtIndex:i]];//[currencyNameArray objectAtIndex:i];
		[currencyViewName.colorLabel setTextColor:[UIColor colorWithRed:46.f/255 green:46.f/255 blue:46.f/255 alpha:1.f]];
		[currencyViewName.colorLabel setTextAlignment:NSTextAlignmentLeft];
		[currencyViewName setAutoresizingMask:UIViewAutoresizingNone];
		[pickerLabelView addSubview:currencyViewName.colorLabel];
		[currencyViewName.colorLabel setFrame:CGRectMake(50.0, 0.0, 270.0, 44.0)];
		
		[self.currencyArray addObject:pickerLabelView];
	}
	 
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
	for(int i=0;i<[self.symbolArray count];i++)
	{
		if ([self.selectedCurrency isEqualToString:[self.currencyNameArray objectAtIndex:i]])
		{
			selectIndexPath = i;
			break;
		}
	}
	[self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndexPath inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	[super viewWillAppear:animated];
}

- (void) back:(id)sender
{
	
	[[self navigationController] popViewControllerAnimated:YES]; 
}
-(void)viewDidAppear:(BOOL)animated
{


	[super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
//- (void)viewDidUnload 
//{
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}



@end
