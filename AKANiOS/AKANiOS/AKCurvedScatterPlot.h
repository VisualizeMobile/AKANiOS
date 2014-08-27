//
//  AKCurvedScatterPlot.h
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKCurvedScatterPlot : NSObject<CPTPlotAreaDelegate,
CPTPlotSpaceDelegate,
CPTPlotDataSource,
CPTScatterPlotDelegate>

@property (nonatomic, strong)CPTPlotSpaceAnnotation *symbolTextAnnotation;
@property (nonatomic, strong) CPTGraphHostingView *defaultLayerHostingView;
@property (nonatomic, strong) NSMutableArray *graphs;
@property (nonatomic, weak) NSString *section;
@property (nonatomic, weak) NSString *title;
@property (nonatomic, strong) NSArray *quotas;
@property (nonatomic, strong) NSArray *middlQquotas;
@property (nonatomic, strong) NSArray *plotData;
@property (nonatomic, strong) NSArray *plotData1;

-(void)renderInView:(UIView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated;
-(void)killGraphic;
@end
