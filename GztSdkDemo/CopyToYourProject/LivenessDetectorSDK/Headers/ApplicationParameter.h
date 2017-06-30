//
//  Header.h
//
//
//  Created by jqshen on 6/25/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#ifndef FaceVerifiactionSDK_Header_h
#define FaceVerifiactionSDK_Header_h

const static char * const SDK_VERSION_NAME = "1.3.a";  // TODO: 发布SDK前应该检查此值
const static int SDK_VERSION_CODE = 40; // TODO: 每次发布SDK时应该增加此值

const static int FRAME_BUFFER_CAPACITY = 10;

const static int SESSION_START_DROP_FRAMES = 10;
const static long GETREADY_COOLDOWN_MILLISECOND = 400;
const static long START_COOLDOWN_MILLISECOND = 0;
const static long GETREADY_TIMEOUT_MILLISECOND = 10000;
const static long ACTION_TIMEOUT_MILLISECOND = 5000;
const static int FACIAL_ACTION_WORKER_THREAD_POOL_SIZE = 1;

// 图像截取参数
const static float FACE_IMAGE_TARGET_WIDTH = 300;
const static float FACE_IMAGE_TARGET_HEIGHT = 400;
const static float FACE_CROP_HORIZONTAL_PERCENT = 1.0f;
const static float FACE_VERTICAL_TOP_PERCENT = 0.0f; // android version is 0.0f
const static int FACE_PRE_ROTATION_DEGREE = 90;
const static bool FACE_IMAGE_SHOULD_FLIP = false;
const static int FACE_HORIZONTAL_MARGIN = 100;

// 网络请求参数
const static int DEFAULT_CONNECT_TIMEOUT_MILLISECOND = 10000;
const static int DEFAULT_RESPONSE_TIMEOUT_MILLISECOND = 30000;

const static char * const MODEL_PATH = "/sdcard/models/model2";

const static bool SAVE_IMAGE = false;
const static int SAVE_IMAGE_THREADS = 1;

const static char * const PAIR_VERIFICATION_FILE_PATH = "/sdcard/tmp/pair_verify/";

const static int MAX_PAIR_VERIFICATION_WAIT_DURATION_MILLISEC = 30000;

const static char * const SERVICE_IP = "121.42.152.46";

const static int USER_REGISTRACTION_UPLOAD_IMAGE_QUALITY = 95;

const static int ID_CARD_UPLOAD_IMAGE_WIDTH = 1920;

const static int MIN_FACE_PIXEL = 200;

const static int MAX_NO_FACE_FRAME_THRESHOULD = 10000000;

const static char* IMG_PROCESS_QUEUE = "image_handler_queue";

const static char* TEST_INPUT_FILE = "/appData/serial_action.json";

const static char* TEST_OUTPUT_FILE = "/appData/result.json";
#endif
