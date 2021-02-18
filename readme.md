# xBerry setup

1. Instal nvidia-docker
2. Build docker `Dockerfile`
    ```bash
    docker build -t face_swap_gpu -f Dockerfile .
    ```
3. Make sure that all needed models are in data directory
    ```bash
    cd data
    wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
    bzip2 -d shape_predictor_68_face_landmarks.dat.bz2
    wget https://github.com/YuvalNirkin/face_swap/releases/download/0.9/3dmm_cnn_resnet_101.zip
    unzip 3dmm_cnn_resnet_101.zip
    wget https://github.com/YuvalNirkin/face_segmentation/releases/download/1.0/face_seg_fcn8s.zip
    unzip face_seg_fcn8s.zip
    wget https://github.com/YuvalNirkin/face_segmentation/releases/download/1.1/face_seg_fcn8s_300_no_aug.zip
    unzip face_seg_fcn8s_300_no_aug.zip
    rm *.zip
    ```
4. Modify config file in `data/test.cfg`. Especially input images data. All images has to be stored in `data/images`
5. Run docker container with GPU support (At least 4GB of GPU memory needed)
    ```bash
    docker run --gpus 0 -it -v ${PWD}/data:/installations/face_swap/data face_swap bash
    ```
6. Inside docker got to dir and run face_swap
    ```bash
    cd /installations/face_swap/bin
    ./face_swap_image --cfg ../data/test.cfg 
    ```
7. Image is stored on local machine in directory `data/images`

PS: [face_swap application guide](https://github.com/YuvalNirkin/face_swap/wiki/Applications-Guide)

# Acknowledgement
This work is done when the author is interning at AILabs.tw

# Dockerized Fast Face Swap

This is a container for Fast Face Swap inherited from [YuvalNirkin/face_swap](https://github.com/YuvalNirkin/face_swap) with all dependency installed.

Since OpenGL is used, we leverage the browser interface from [thewtex/docker-opengl](https://github.com/thewtex/docker-opengl) to
access OpenGL.

# Prerequisite 

You must have face_swap and yolo.so under this folder.
You can clone them from Gitlab
face_swap: `git clone https://github.com/RudyChin/face_swap -b kcf` (Default branch is kcf)
yolo.so: `git clone https://github.com/RudyChin/yolo.so.git`

# Models
    ./fetch_data.sh

Download [dfm_cnn_resnet_101](https://drive.google.com/file/d/0B8k2u9qYUPLca1RKXzBRb3l5TzQ/view?usp=sharing) and put them under models folder.

# Existing Image
`docker pull rudychin/face_swap_docker:gpu`

# Install

Install the docker image by `./build-gpu.sh` (It will get nvidia-driver.run for you)
You should prepare `nvidia-driver.run` with the same driver version installed on the host

There are several variables to be set in `run-gpu.sh` 

Please set `MODEL_PATH` to path that contains the following models:
1. landmarks, e.g. shape_predictor_68_face_landmarks.dat
2. model_3dmm_h5, e.g. BaselFaceModel_mod_wForehead_noEars.h5
3. model_3dmm_dat, e.g. BaselFace.dat
4. reg_model, e.g. dfm_resnet_101.caffemodel
5. reg_deploy, e.g. dfm_resnet_101_deploy.prototxt
6. reg_mean, e.g. dfm_resnet_101_mean.binaryproto
7. seg_model, e.g. face_seg_fcn8s.caffemodel
8. seg_deploy, e.g. face_seg_fcn8s_deploy.prototxt

Please set `IMAGE_PATH` to contain the source images, e.g. Brad Pitt

# Run

To run test on GPU 0:

    ./run-gpu.sh test 0


Noted that there are several idols to pick from:
0 (Brad Pitt), 1 (Emma Stone), 2 (Emma Watson), 3 (Donald Trump), 4 (Aniki), 5 (Nick Young)
To change source idols, please modify codes in `face_swap/py_face_swap/fs_service.py`

# Switch Algorithms (KCF / DLIB+YOLO)

## Method 1
    cd face_swap
    git checkout {yolo/kcf}
    cd ..
    make docker-gpu #Suppose you have nvidia-driver.run already

## Method 2
    ./run-gpu.sh 8899

    docker# git checkout {yolo/kcf}
    docker# cd build
    docker# make -j12
    docekr# make install

# Notes for run-gpu.sh

The parameters given to the docker in `run-gpu.sh` is essential to enable OpenGL.
You should especially take care of `-e DISPLAY=:0`. It should bind to the display.
In case :0 doesn't work anymore:
1. Physically login to the computer, e.g. ws2 (It should connect to a screen)
2. Open a terminal
3. check the working value of DISPLAY by `echo $DISPLAY`

