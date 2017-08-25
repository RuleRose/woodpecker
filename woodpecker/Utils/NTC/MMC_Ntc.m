//
//  MMC_Ntc.m
//  MiaoMiaoCe
//
//  Created by lanp on 9/13/14.
//  Copyright (c) 2014 Weisi Smart. All rights reserved.
//

#import "MMC_Ntc.h"

#define MAX_NTC_DATA_INDEX 900
#define MIN_TEMPERATURE    -25.0  //-20.0
#define MAX_TEMPERATURE    80.0   //50.0

#define ABSOLUTE_T_0         273.15

@implementation MMC_Ntc

extern const unsigned int NTC_01_TABLE[];
extern const unsigned int NTC_02_TABLE[];
extern const unsigned int NTC_03_TABLE[];
extern const unsigned int NTC_04_TABLE[];
extern const unsigned int NTC_05_TABLE[];
extern const unsigned int NTC_06_TABLE[];
extern const unsigned int NTC_07_TABLE[];
extern const unsigned int NTC_08_TABLE[];
extern const unsigned int NTC_09_TABLE[];
extern const unsigned int NTC_10_TABLE[];
extern const unsigned int NTC_11_TABLE[];
extern const unsigned int NTC_12_TABLE[];
extern const unsigned int NTC_13_TABLE[];
extern const unsigned int NTC_14_TABLE[];
extern const unsigned int NTC_15_TABLE[];
extern const unsigned int NTC_16_TABLE[];
extern const unsigned int NTC_17_TABLE[];
extern const unsigned int NTC_18_TABLE[];
extern const unsigned int NTC_19_TABLE[];
extern const unsigned int NTC_20_TABLE[];
extern const unsigned int NTC_21_TABLE[];

extern const double NTC_01_PARAM[];
extern const double NTC_02_PARAM[];
extern const double NTC_03_PARAM[];
extern const double NTC_04_PARAM[];
extern const double NTC_05_PARAM[];
extern const double NTC_06_PARAM[];
extern const double NTC_07_PARAM[];
extern const double NTC_08_PARAM[];
extern const double NTC_09_PARAM[];
extern const double NTC_10_PARAM[];
extern const double NTC_11_PARAM[];
extern const double NTC_12_PARAM[];
extern const double NTC_13_PARAM[];
extern const double NTC_14_PARAM[];
extern const double NTC_15_PARAM[];
extern const double NTC_16_PARAM[];
extern const double NTC_17_PARAM[];
extern const double NTC_18_PARAM[];
extern const double NTC_19_PARAM[];
extern const double NTC_20_PARAM[];
extern const double NTC_21_PARAM[];


// ntc data table, contains resistance value from 0.0 - 45.0
const unsigned int* ntc_table[] =
{
    NTC_01_TABLE,
    NTC_02_TABLE,
    NTC_03_TABLE,
    NTC_04_TABLE,
    NTC_05_TABLE,
    NTC_06_TABLE,
    NTC_07_TABLE,
    NTC_08_TABLE,
    NTC_09_TABLE,
    NTC_10_TABLE,
    NTC_11_TABLE,
    NTC_12_TABLE,
    NTC_13_TABLE,
    NTC_14_TABLE,
    NTC_15_TABLE,
    NTC_16_TABLE,
    NTC_17_TABLE,
    NTC_18_TABLE,
    NTC_19_TABLE,
    NTC_20_TABLE,
    NTC_21_TABLE
};

const double* ntc_param_table[] =
{
    NTC_01_PARAM,
    NTC_02_PARAM,
    NTC_03_PARAM,
    NTC_04_PARAM,
    NTC_05_PARAM,
    NTC_06_PARAM,
    NTC_07_PARAM,
    NTC_08_PARAM,
    NTC_09_PARAM,
    NTC_10_PARAM,
    NTC_11_PARAM,
    NTC_12_PARAM,
    NTC_13_PARAM,
    NTC_14_PARAM,
    NTC_15_PARAM,
    NTC_16_PARAM,
    NTC_17_PARAM,
    NTC_18_PARAM,
    NTC_19_PARAM,
    NTC_20_PARAM,
    NTC_21_PARAM
};

+ (float)ntcResistanceToTemperature:(float)resistance index:(int)ntcIndex
{
    float t_raw = [self _ntcResistanceToTemperature:resistance index:ntcIndex];
    float t = t_raw;
//    float t = t_raw - 0.05f;
//    
//    while (t < t_raw + 0.05f)
//    {
//        t = t + 0.001f;
//        if (resistance > [self ntcTemperatureToResistance:t index:ntcIndex])
//        {
//            break;
//        }
//    }
    
    //temperature adjust for C1C2 && CCC2
//    t = 1.013 * t - 1.5339;
    
    double a = 9.94408123930913E-05;
    double b = -1.14841989877623E-02;
    double c = 1.4345809516733;
    double d = -6.44140480679273;
    t = ((((a * (pow(t, 3))) + (b * (pow(t, 2)))) + (c * t)) + d);
    
    return t;
}

+ (float)_ntcResistanceToTemperature:(float)resistance index:(int)ntcIndex
{
    
    if (ntcIndex < 1 || ntcIndex > 21)
    {
        // invalid index, set to default
        ntcIndex = 18;
    }
    
    const unsigned int* ntc_data = ntc_table[ntcIndex-1];
    float t;
    
    if (resistance < ntc_data[MAX_NTC_DATA_INDEX])
    {
        // temperature higher than 45.0
        t = 45.0;
        
        while (t < MAX_TEMPERATURE)
        {
            t = t + 0.05f;
            if (resistance > [self ntcTemperatureToResistance:t index:ntcIndex])
            {
                break;
            }
        }
        
        return t;
    }
    else if (resistance > ntc_data[0])
    {
        // temperature lower than 0.0
        t = 0.0;
        
        while (t > MIN_TEMPERATURE)
        {
            t = t - 0.05f;
            if (resistance < [self ntcTemperatureToResistance:t index:ntcIndex])
            {
                break;
            }
        }
        
        return t;
    }
    
    for(int i = MAX_NTC_DATA_INDEX; i >= 0; i--)
    {
        if(resistance <= ntc_data[i])
        {
            return i * 0.05f; //一档0.05f
        }
    }
    
    // should not go here
    return  0;
}

+ (float)ntcTemperatureToResistance:(float)t index:(int)ntcIndex
{
    if (ntcIndex < 1 || ntcIndex > 21)
    {
        // invalid index, set to default
        ntcIndex = 18;
    }
    
    const double* ntc_param = ntc_param_table[ntcIndex-1];
    
    double a = ntc_param[0];
    double b = ntc_param[1];
    double c = ntc_param[2];
    double d = ntc_param[3];
    
    double at = (double)t + ABSOLUTE_T_0;
    
    double k = a + b/at + c/(pow(at,2)) + d/(pow(at,3));
    double rt = exp(k);
    return rt;
}

@end
