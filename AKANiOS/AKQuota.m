//
//  AKQuota.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuota.h"

@implementation AKQuota

-(BOOL)isEmpty{
    return (self.value == 0.0) ? YES : NO;
}


/*
 1 - passagens aéreas;
 2 - telefonia;
 3 - serviços postais, vedada a aquisição de selos;
 4 - manutenção de escritórios de apoio à atividade parlamentar, compreendendo locação de imóveis, pagamento de taxa de condomínio, IPTU, energia elétrica, água e esgoto, locação de móveis e equipamentos, material de expediente e suprimentos de informática, acesso à internet, assinatura de TV a cabo ou similar, locação ou aquisição de licença de uso de software, assinatura de publicações;
 5 - fornecimento de alimentação do parlamentar;
 6 - hospedagem, exceto do parlamentar no Distrito Federal;
 7 - locação ou fretamento de aeronaves, embarcações e veículos automotores (neste último caso, o ressarcimento é limitado ao percentual de 10% do valor do veículo conforme a tabela Fipe do mês utilizado pelo parlamentar);
 8 - combustíveis e lubrificantes, até o limite de R$ 4.500,00 mensais;
 9 - serviços de segurança, prestados por empresa especializada, até o limite inacumulável de R$ 4.500,00 mensais;
 10 - contratação, para fins de apoio ao exercício do mandato parlamentar, de consultorias e trabalhos técnicos, permitidas pesquisas socioeconômicas;
 11 - divulgação da atividade parlamentar, exceto nos 120 dias anteriores à data das eleições de âmbito federal, estadual ou municipal.
 */

-(NSString *)subtypeName{
    switch (_subtype) {
        case 1:
            return @"Passagens Aereas";
            break;
        case 2:
            return @"Telefonia";
            break;
        case 3:
            return @"Serviços Postais";
            break;
        case 4:
            return @"Escritório";
            break;
        case 5:
            return @"Alimentação";
            break;
        case 6:
            return @"Hospedagem";
            break;
        case 7:
            return @"Locação de Aeronaves";
            break;
        case 8:
            return @"Locação de Automóveis";
            break;
        case 9:
            return @"Combustiveis";
            break;
        case 10:
            return @"Segurança";
            break;
        case 11:
            return @"Pesquisas";
            break;
        case 12:
            return @"Divulgação";
            break;
        case 13:
            return @"Assinaturas";
            break;
        default:
            return @"";
            break;
    }
}


-(NSString *)imageType{
    switch (_subtype) {
        case 1:
            return @"passagem";
            break;
        case 2:
            return @"telefonia";
            break;
        case 3:
            return @"postais";
            break;
        case 4:
            return @"escritorio";
            break;
        case 5:
            return @"alimentacao";
            break;
        case 6:
            return @"hospedagem";
            break;
        case 7:
            return @"aeronaves";
            break;
        case 8:
            return @"automoveis";
            break;
        case 9:
            return @"combustivel";
            break;
        case 10:
            return @"seguranca";
            break;
        case 11:
            return @"consultoria";
            break;
        case 12:
            return @"divulgacao";
            break;
        case 13:
            return @"assinaturas";
            break;
        default:
            return @"";
            break;
    }

}

-(NSString *)imageColor{
    
    if (self.value < 1.0) {
        return @"1";
    }else if(self.value < 1500.0){
        return @"2";
    }else if(self.value < 3000.0){
        return @"3";
    }else if(self.value < 6000.0){
        return @"4";
    }else {
        return @"5";
    }
}

-(NSString *)imageName{
    NSString *name = [NSString stringWithFormat:@"%@%@", [self imageType],[self imageColor]];
    //NSLog(@"aaa %@",name);
    return name;
}
@end
