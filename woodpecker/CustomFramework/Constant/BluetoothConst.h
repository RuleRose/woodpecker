//
//  BluetoothConst.h
//  mmcS2
//
//  Created by 肖君 on 16/11/3.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#ifndef BluetoothConst_h
#define BluetoothConst_h

#define SERVICE_UUID_THERMOMETER @"1809"

#define SERVICE_DATA_UUID_WOODPECKER @"FE95"
#define MMC_SENSOR_WOODPECKER_PRODUCT_ID 0x00DC

#define SERVICE_UUID_MMCSERVICE @"ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6"

#define CHARACT_UUID_TIME_READ @"ebe0ccb5-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_TIME_WRITE @"ebe0ccb7-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_ALARM_READ @"ebe0ccb6-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_ALARM_WRITE @"ebe0ccb8-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_COUNT_READ @"ebe0ccb9-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_INDEX_WRITE @"ebe0ccba-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ @"ebe0ccbb-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_MONITORING_TEMPERATURE_READ @"ebe0ccb2-7a0a-4b0c-8a1a-6ff2997da3a6"

#define SELECTED_DEVICE_RSSI_THRESHOLD -50

#endif /* BluetoothConst_h */