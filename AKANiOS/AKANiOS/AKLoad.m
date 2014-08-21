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
    [parliamentaryDao insertParliamentaryWithNickName:@"FRANCISCO TENORIO" andFullName:@"José Francisco Cerqueira Tenório" andIdParliamentary:@"141467" andParty:@"PMN" andPosRanking:@1 andUf:@"AL" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/141467.jpg" andValueRanking:@90000 andIdUpdate:@01 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"PAULÃO" andFullName:@"PAULO FERNANDO DOS SANTOS" andIdParliamentary:@"171617" andParty:@"PT" andPosRanking:@02 andUf:@"AL" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/171617.jpg" andValueRanking:@55000 andIdUpdate:@01 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"TIRIRICA" andFullName:@"FRANCISCO EVERARDO OLIVEIRA SILVA" andIdParliamentary:@"160976" andParty:@"PR" andPosRanking:@3 andUf:@"SP" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/160976.jpg" andValueRanking:@12000 andIdUpdate:@0 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"JAIR BOLSONARO" andFullName:@"JAIR MESSIAS BOLSONARO" andIdParliamentary:@"74847" andParty:@"PP" andPosRanking:@4 andUf:@"RJ" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/74847.jpg" andValueRanking:@20000 andIdUpdate:@1 andFollowed:@0];
    
    [parliamentaryDao insertParliamentaryWithNickName:@"ROMÁRIO" andFullName:@"ROMARIO DE SOUZA FARIA" andIdParliamentary:@"160597" andParty:@"PSB" andPosRanking:@5 andUf:@"RJ" andUrlPhoto:@"http://www.camara.gov.br/internet/deputado/bandep/160597.jpg" andValueRanking:@10 andIdUpdate:@01 andFollowed:@0];
    
    
   }

-(void)loadQuotasTestData
{
    
    quotaDao=[AKQuotaDao getInstance];
    
    //Cotas ficticias do Francisco Tenorio
    [quotaDao insertQuotaWithId:@"01" andNumQuota:@1 andNameQuota:@"Passagens aéreas" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@1000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"02" andNumQuota:@2 andNameQuota:@"Telefonia" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@1000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"03" andNumQuota:@3 andNameQuota:@"Serviços postais" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@65000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"04" andNumQuota:@4 andNameQuota:@"Escritório" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"05" andNumQuota:@5 andNameQuota:@"Alimentação" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"06" andNumQuota:@6 andNameQuota:@"Hospedagem" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@2000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"07" andNumQuota:@7 andNameQuota:@"Fretamento" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"08" andNumQuota:@8 andNameQuota:@"Combustíveis" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@500 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"09" andNumQuota:@9 andNameQuota:@"Segurança" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@3000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"10" andNumQuota:@10 andNameQuota:@"Contratações" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@50000 andIdParliamentary:@"141467"];
    [quotaDao insertQuotaWithId:@"11" andNumQuota:@11 andNameQuota:@"Publicidade" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@50000 andIdParliamentary:@"141467"];
    
    
    //Cotas Ficticias do Paulão
    [quotaDao insertQuotaWithId:@"12" andNumQuota:@1 andNameQuota:@"Passagens aéreas" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10000 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"13" andNumQuota:@2 andNameQuota:@"Telefonia" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@1500 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"14" andNumQuota:@3 andNameQuota:@"Serviços postais" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6500 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"15" andNumQuota:@4 andNameQuota:@"Escritório" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10000 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"16" andNumQuota:@5 andNameQuota:@"Alimentação" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"17" andNumQuota:@6 andNameQuota:@"Hospedagem" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@20000 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"18" andNumQuota:@7 andNameQuota:@"Fretamento" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6100 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"19" andNumQuota:@8 andNameQuota:@"Combustíveis" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6500 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"20" andNumQuota:@9 andNameQuota:@"Segurança" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@300 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"21" andNumQuota:@10 andNameQuota:@"Contratações" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@500 andIdParliamentary:@"171617"];
    [quotaDao insertQuotaWithId:@"22" andNumQuota:@11 andNameQuota:@"Publicidade" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@5000 andIdParliamentary:@"171617"];
    

    
    //Cotas Ficticias do Tiririca
    [quotaDao insertQuotaWithId:@"23" andNumQuota:@1 andNameQuota:@"Passagens aéreas" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@4500 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"24" andNumQuota:@2 andNameQuota:@"Telefonia" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@15000 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"25" andNumQuota:@3 andNameQuota:@"Serviços postais" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@600 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"26" andNumQuota:@4 andNameQuota:@"Escritório" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@5000 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"27" andNumQuota:@5 andNameQuota:@"Alimentação" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10000 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"28" andNumQuota:@6 andNameQuota:@"Hospedagem" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@2000 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"29" andNumQuota:@7 andNameQuota:@"Fretamento" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"30" andNumQuota:@8 andNameQuota:@"Combustíveis" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@600 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"31" andNumQuota:@9 andNameQuota:@"Segurança" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@300 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"34" andNumQuota:@10 andNameQuota:@"Contratações" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@50000 andIdParliamentary:@"160976"];
    [quotaDao insertQuotaWithId:@"35" andNumQuota:@11 andNameQuota:@"Publicidade" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@2000 andIdParliamentary:@"160976"];
    
    //Cotas Ficticias do Bolsonaro
    [quotaDao insertQuotaWithId:@"36" andNumQuota:@1 andNameQuota:@"Passagens aéreas" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@1000 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"37" andNumQuota:@2 andNameQuota:@"Telefonia" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@15000 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"38" andNumQuota:@3 andNameQuota:@"Serviços postais" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@1500 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"39" andNumQuota:@4 andNameQuota:@"Escritório" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@3000 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"40" andNumQuota:@5 andNameQuota:@"Alimentação" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"41" andNumQuota:@6 andNameQuota:@"Hospedagem" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@2000 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"42" andNumQuota:@7 andNameQuota:@"Fretamento" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@5100 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"43" andNumQuota:@8 andNameQuota:@"Combustíveis" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6500 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"44" andNumQuota:@9 andNameQuota:@"Segurança" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@300 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"45" andNumQuota:@10 andNameQuota:@"Contratações" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@5000 andIdParliamentary:@"74847"];
    [quotaDao insertQuotaWithId:@"46" andNumQuota:@11 andNameQuota:@"Publicidade" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@500 andIdParliamentary:@"74847"];
    
    //Cotas Ficticias do Romario
    [quotaDao insertQuotaWithId:@"47" andNumQuota:@1 andNameQuota:@"Passagens aéreas" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"48" andNumQuota:@2 andNameQuota:@"Telefonia" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@150000 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"50" andNumQuota:@3 andNameQuota:@"Serviços postais" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@500 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"51" andNumQuota:@4 andNameQuota:@"Escritório" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@100 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"52" andNumQuota:@5 andNameQuota:@"Alimentação" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@10000 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"53" andNumQuota:@6 andNameQuota:@"Hospedagem" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@2000 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"54" andNumQuota:@7 andNameQuota:@"Fretamento" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6500 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"55" andNumQuota:@8 andNameQuota:@"Combustíveis" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@6500 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"56" andNumQuota:@9 andNameQuota:@"Segurança" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@300 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"57" andNumQuota:@10 andNameQuota:@"Contratações" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@50000 andIdParliamentary:@"160597"];
    [quotaDao insertQuotaWithId:@"58" andNumQuota:@11 andNameQuota:@"Publicidade" andMonth:@1 andYear:@2014 andIdUpdate:@01 andValue:@500 andIdParliamentary:@"160597"];
}

@end
