//
//  AKLoad.m
//  AKANiOS
//
//  Created by Ramon Cruz on 8/18/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKLoad.h"

@implementation AKLoad

@synthesize quotaDao,parliamentaryDao;

-(void)loadParliamentariesTestData
{
    parliamentaryDao=[AKParliamentaryDao getInstance];
    
    //Parlamentares experimentais
    [parliamentaryDao insertParliamentaryWithNickName:@"FRANCISCO TENORIO" andFullName:@"José Francisco Cerqueira Tenório" andIdParliamentary:@"141467" andParty:@"PMN" andPosRanking:@1 andUf:@"AL" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/141467.jpg" andValueRanking:@3000 andIdUpdate:@01 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"PAULÃO" andFullName:@"PAULO FERNANDO DOS SANTOS" andIdParliamentary:@"171617" andParty:@"PT" andPosRanking:@01 andUf:@"AL" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/171617.jpg" andValueRanking:@2000 andIdUpdate:@01 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"TIRIRICA" andFullName:@"FRANCISCO EVERARDO OLIVEIRA SILVA" andIdParliamentary:@"160976" andParty:@"PR" andPosRanking:@3 andUf:@"SP" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/160976.jpg" andValueRanking:@1212 andIdUpdate:@0 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"JAIR BOLSONARO" andFullName:@"AIR MESSIAS BOLSONARO" andIdParliamentary:@"74847" andParty:@"PP" andPosRanking:@5 andUf:@"RJ" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/74847.jpg" andValueRanking:@10000 andIdUpdate:@1 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"ROMÁRIO" andFullName:@"ROMARIO DE SOUZA FARIA" andIdParliamentary:@"160597" andParty:@"PSB" andPosRanking:@6 andUf:@"RJ" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/160597.jpg" andValueRanking:@10 andIdUpdate:@01 andFollowed:@0];
    
    
  
    
   }

-(void)loadQuotasTestData
{
    
}

@end
