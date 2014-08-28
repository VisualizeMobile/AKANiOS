//
//  AKCurvedScatterPlot.m
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKCurvedScatterPlot.h"
#import "AKUtil.h"
#import "AKQuota.h"
#import "AKStatistic.h"

NSString *const middle  = @"Gasto médio dos parlamentares";

@interface AKCurvedScatterPlot ()

@property (nonatomic, weak)CPTTheme *currentTheme;

@end
@implementation AKCurvedScatterPlot

-(id)init
{
    if ( (self = [super init]) ) {
    }

    return self;
}

-(void)generateData
{
    if ( self.plotData == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        NSNumber *y;
        NSNumber *x;
        
        for ( int i = 1; i <= 12; i++ ) {
            
            for (AKQuota *quota in self.quotas) {
                if ([quota.month isEqual:@(i)]) {
                    y = quota.value;
                    break;
                }else{
                    y = @0;
                }
            }
            x = [NSNumber numberWithInteger:i];
            
            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
        }
        
        self.plotData = contentArray;
    }
    
    if ( self.plotData1 == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        NSNumber *y;
        NSNumber *x;
        
        for ( int i = 1; i <= 12; i++ ) {
            
            for (AKStatistic *statistic in self.middleQuotas) {
                if ([statistic.month isEqual:@(i)]) {
                    y = statistic.average;
                    break;
                }else{
                    y = @0;
                }
            }
            x = [NSNumber numberWithInteger:i];
            
            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
        }
        
        self.plotData1 = contentArray;
    }
}

-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated
{
    CGRect bounds = layerHostingView.bounds;
    CPTGraph *graph;
    
    if (self.graphs == nil) {
        graph = [[CPTXYGraph alloc] initWithFrame:bounds];
        [self addGraph:graph toHostingView:layerHostingView];
        
        [graph applyTheme:self.currentTheme];
        
        graph.title = [NSString stringWithFormat: @"Gastos com %@", self.title];
        
        graph.plotAreaFrame.paddingLeft   += 75.0;
        graph.plotAreaFrame.paddingTop    += 30.0;
        graph.plotAreaFrame.paddingRight  += 25.0;
        graph.plotAreaFrame.paddingBottom += 100.0;
        graph.plotAreaFrame.masksToBorder  = NO;
        
        // Plot area delegate
        graph.plotAreaFrame.plotArea.delegate = self;
        
        // Setup scatter plot space
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        plotSpace.allowsUserInteraction = YES;
        plotSpace.delegate              = self;
        
        // Grid line styles
        CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
        majorGridLineStyle.lineWidth = 0.5;
        majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.25];
        
        CPTLineCap *lineCap = [CPTLineCap sweptArrowPlotLineCap];
        lineCap.size = CGSizeMake(15.0, 15.0);
        
        // Axes
        // Label x axis with a fixed interval policy
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        x.majorIntervalLength   = CPTDecimalFromDouble(1.0);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:0];
        x.labelFormatter = formatter;
        x.minorTicksPerInterval = 0;
        x.majorGridLineStyle    = majorGridLineStyle;
        x.axisConstraints       = [CPTConstraints constraintWithRelativeOffset:0.0];
        
        lineCap.lineStyle = x.axisLineStyle;
        lineCap.fill      = [CPTFill fillWithColor:lineCap.lineStyle.lineColor];
        x.axisLineCapMax  = lineCap;
        
        x.title       = [NSString stringWithFormat:@"Meses de %@",self.year];
        x.titleOffset = 20.0;
        
        // Label y with an automatic label policy.
        CPTXYAxis *y = axisSet.yAxis;
        y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
        y.minorTicksPerInterval       = 0;
        y.preferredNumberOfMajorTicks = 8;
        y.majorGridLineStyle          = majorGridLineStyle;
        y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
        y.labelOffset                 = 20.0;
        
        lineCap.lineStyle = y.axisLineStyle;
        lineCap.fill      = [CPTFill fillWithColor:lineCap.lineStyle.lineColor];
        y.axisLineCapMax  = lineCap;
        
        y.title       = @"Gastos (R$)";
        y.titleOffset = 0.0;
        y.titleDirection = CPTSignNegative ;
        
        // Set axes
        graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
        
        
        CPTScatterPlot *averagePlot = [[CPTScatterPlot alloc] init];
        averagePlot.identifier    = middle;
        // Make the data source line use curved interpolation
        averagePlot.interpolation = CPTScatterPlotInterpolationLinear;

        CPTMutableLineStyle *lineStyle = [averagePlot.dataLineStyle mutableCopy];
        lineStyle.lineWidth     = 4.0;
        lineStyle.lineColor     = [[[CPTColor alloc]initWithCGColor:[[AKUtil color2] CGColor]] colorWithAlphaComponent:1];
        averagePlot.dataLineStyle = lineStyle;
        averagePlot.dataSource    = self;
        
        [graph addPlot:averagePlot];
        
        // Create a plot that uses the data source method
        CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
        dataSourceLinePlot.identifier = self.kData;
        
        // Make the data source line use curved interpolation
        dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear;
        lineStyle.lineWidth              = 5.0;
        lineStyle.lineColor              = [[[CPTColor alloc]initWithCGColor:[[AKUtil color5] CGColor]] colorWithAlphaComponent:1];
        dataSourceLinePlot.dataLineStyle = lineStyle;
        
        dataSourceLinePlot.dataSource = self;
        [graph addPlot:dataSourceLinePlot];
        
        // Auto scale the plot space to fit the plot data
        [plotSpace scaleToFitPlots:[graph allPlots]];
        CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
        CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
        
        // Expand the ranges to put some space around the plot
        [xRange expandRangeByFactor:CPTDecimalFromDouble(1.1)];
        [yRange expandRangeByFactor:CPTDecimalFromDouble(1.1)];
        plotSpace.xRange = xRange;
        plotSpace.yRange = yRange;
        
        [xRange expandRangeByFactor:CPTDecimalFromDouble(1.1)];
        xRange.location = plotSpace.xRange.location;
        [yRange expandRangeByFactor:CPTDecimalFromDouble(1.1)];
        x.visibleAxisRange = xRange;
        y.visibleAxisRange = yRange;
        
        [xRange expandRangeByFactor:CPTDecimalFromDouble(1.0)];
        [yRange expandRangeByFactor:CPTDecimalFromDouble(1.0)];
        plotSpace.globalXRange = xRange;
        plotSpace.globalYRange = yRange;
        
        // Add plot symbols
        CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineColor = [[[CPTColor alloc]initWithCGColor:[[AKUtil color1] CGColor]] colorWithAlphaComponent:0.5];
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill               = [CPTFill fillWithColor:[[[CPTColor alloc]initWithCGColor:[[AKUtil color1] CGColor]] colorWithAlphaComponent:0.5]];
        plotSymbol.lineStyle          = symbolLineStyle;
        plotSymbol.size               = CGSizeMake(15.0, 15.0);
        dataSourceLinePlot.plotSymbol = plotSymbol;
        
        // Set plot delegate, to know when symbols have been touched
        // We will display an annotation when a symbol is touched
        dataSourceLinePlot.delegate                        = self;
        dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
        
        // Add legend
        graph.legend                 = [CPTLegend legendWithGraph:graph];
        graph.legend.numberOfRows    = 2;
        graph.legend.textStyle       = x.titleTextStyle;
        graph.legend.fill            = [CPTFill fillWithColor:[CPTColor whiteColor]];
        graph.legend.borderLineStyle = x.axisLineStyle;
        graph.legend.cornerRadius    = 5.0;
        graph.legend.swatchSize      = CGSizeMake(25.0, 25.0);
        graph.legendAnchor           = CPTRectAnchorBottom;
        graph.legendDisplacement     = CGPointMake(0.0, 12.0);
        
        
    }else{
        graph = [self.graphs objectAtIndex:0];
        graph.frame = bounds;
        [graph reloadData];
    }
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger numRecords = 0;
    NSString *identifier  = (NSString *)plot.identifier;
    
    if ( [identifier isEqualToString:self.kData] ) {
        numRecords = self.plotData.count;
    }
    else if ( [identifier isEqualToString:middle] ) {
        numRecords = self.plotData1.count;
    }
    
    return numRecords;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num        = nil;
    NSString *identifier = (NSString *)plot.identifier;
    
    if ( [identifier isEqualToString:self.kData] ) {
        num = [[self.plotData objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    }
    else if ( [identifier isEqualToString:middle] ) {
        num = [[self.plotData1 objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    }
    return num;
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)space.graph.axisSet;
    
    CPTMutablePlotRange *changedRange = [newRange mutableCopy];
    
    switch ( coordinate ) {
        case CPTCoordinateX:
            [changedRange expandRangeByFactor:CPTDecimalFromDouble(1.025)];
            changedRange.location          = newRange.location;
            axisSet.xAxis.visibleAxisRange = changedRange;
            break;
            
        case CPTCoordinateY:
            [changedRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
            axisSet.yAxis.visibleAxisRange = changedRange;
            break;
            
        default:
            break;
    }
    
    return newRange;
}

#pragma mark -
#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    CPTXYGraph *graph = [self.graphs objectAtIndex:0];
    
    if ( self.symbolTextAnnotation ) {
        [graph.plotAreaFrame.plotArea removeAnnotation:self.symbolTextAnnotation];
        self.symbolTextAnnotation = nil;
    }
    
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [[CPTColor alloc] initWithCGColor:[[AKUtil color1] CGColor]];
    hitAnnotationTextStyle.fontSize = 16.0;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    // Determine point of symbol in plot coordinates
    NSNumber *x          = [[self.plotData objectAtIndex:index] valueForKey:@"x"];
    NSNumber *y          = [[self.plotData objectAtIndex:index] valueForKey:@"y"];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];
    
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
    self.symbolTextAnnotation              = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    self.symbolTextAnnotation.contentLayer = textLayer;
    self.symbolTextAnnotation.displacement = CGPointMake(0.0, 20.0);
    [graph.plotAreaFrame.plotArea addAnnotation:self.symbolTextAnnotation];
}

#pragma mark -
#pragma mark Plot area delegate method

-(void)plotAreaWasSelected:(CPTPlotArea *)plotArea
{
    // Remove the annotation
    if ( self.symbolTextAnnotation ) {
        CPTXYGraph *graph = [self.graphs objectAtIndex:0];
        
        [graph.plotAreaFrame.plotArea removeAnnotation:self.symbolTextAnnotation];
        self.symbolTextAnnotation = nil;
    }
}

-(void)addGraph:(CPTGraph *)graph toHostingView:(CPTGraphHostingView *)layerHostingView
{
    if (self.graphs == nil ) {
        self.graphs = [[NSMutableArray alloc] init];
        [self.graphs addObject:graph];

    }
    
    if ( layerHostingView ) {
        layerHostingView.hostedGraph = graph;
    }
}

-(void)renderInView:(UIView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated{
    if(self.defaultLayerHostingView == nil){
        self.defaultLayerHostingView = [(CPTGraphHostingView *)[CPTGraphHostingView alloc] initWithFrame : hostingView.bounds];
        [hostingView addSubview:self.defaultLayerHostingView];
        self.currentTheme = theme;
    }else{
        self.defaultLayerHostingView.frame = hostingView.bounds;
    }
    
    self.defaultLayerHostingView.collapsesLayers = NO;
    [self.defaultLayerHostingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.defaultLayerHostingView setAutoresizesSubviews:YES];
    
    [self generateData];
    [self renderInLayer:self.defaultLayerHostingView withTheme:theme animated:animated];
}

-(void)dealloc{
    [self killGraphic];
}

-(void)killGraphic{
    self.symbolTextAnnotation = nil;
    self. defaultLayerHostingView = nil;
    [self.graphs removeAllObjects];
    self.graphs = nil;
    self.plotData = nil;
    self.plotData1 = nil;

}


@end
