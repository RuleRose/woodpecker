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
#define MMC_SENSOR_WOODPECKER_PRODUCT_ID_1 0x00DC
#define MMC_SENSOR_WOODPECKER_PRODUCT_ID_2 0xFFDC

#define SERVICE_UUID_DEVICE_INFO @"180a"
#define CHARACT_UUID_MODEL_NUM @"2a24"
#define CHARACT_UUID_HARDWARE_REV @"2a27"
#define CHARACT_UUID_SOFTWARE_REV @"2a28"

#define SERVICE_UUID_MMCSERVICE @"ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_TIME_READ_WRITE @"ebe0ccb7-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_ALARM_READ_WRITE @"ebe0ccb8-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_COUNT_READ @"ebe0ccb9-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_INDEX_READ_WRITE @"ebe0ccba-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ @"ebe0ccbb-7a0a-4b0c-8a1a-6ff2997da3a6"
//#define CHARACT_UUID_MONITORING_TEMPERATURE_READ @"ebe0ccb5-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_TEMPERATURE_UNIT_READ_WRITE @"ebe0ccbe-7a0a-4b0c-8a1a-6ff2997da3a6"
#define CHARACT_UUID_STATUS_READ_NOTIFY @"ebe0ccbf-7a0a-4b0c-8a1a-6ff2997da3a6"

#define SELECTED_DEVICE_RSSI_THRESHOLD -50

#endif /* BluetoothConst_h */
