#!/bin/bash
set -e


REGION_3D_PATH=$1
DATA_2D_DIR=$2
MASK_OUTPUT_DIRECTORY=$3
FREQUENCY=$4

SAVE_CROPS=false 

# gpu optimization
OPTIMIZE_GPU_USAGE=false


# Get filename from the path
REGION_3D_FILENAME=$(basename -- "$REGION_3D_PATH")
REGION_3D_NAME="${REGION_3D_FILENAME%.*}"

# Get the scan name from the region name
# the scan name is the part of the string that's before the first underscore
SCAN_NAME=$(echo $REGION_3D_NAME | cut -d'_' -f1)


# --------
# NOTE: SET THESE PARAMETERS BASED ON YOUR SCENE!
# data paths
SCENE_DIR="${DATA_2D_DIR}/${SCAN_NAME}"
echo "[INFO] Using 2D data from ${SCENE_DIR}."

SCENE_POSE_DIR="${SCENE_DIR}/pose"
SCENE_INTRINSIC_PATH="${SCENE_DIR}/intrinsic/intrinsic_color.txt"
SCENE_INTRINSIC_RESOLUTION="[1024,1280]" # change if your intrinsics are based on another resolution
SCENE_COLOR_IMG_DIR="${SCENE_DIR}/color"
SCENE_DEPTH_IMG_DIR="${SCENE_DIR}/depth"
IMG_EXTENSION=".jpg"
DEPTH_EXTENSION=".png"
DEPTH_SCALE=4000

# model ckpt paths
CKPT_PATH="/home/rsl_admin/openmask3d/checkpoints"
SAM_CKPT_PATH="${CKPT_PATH}/sam_vit_h_4b8939.pth"

# output directories to save masks and mask features
OUTPUT_FOLDER_DIRECTORY="${MASK_OUTPUT_DIRECTORY}/${REGION_3D_NAME}"


# get the path of the saved masks
SCENE_MASK_PATH="${OUTPUT_FOLDER_DIRECTORY}/${REGION_3D_NAME}_masks.pt"
echo "[INFO] Loading mask from ${SCENE_MASK_PATH}."


cd openmask3d

echo "[INFO] Computing mask features..."

# print the datetime
echo "[INFO] $(date)"

python compute_features_os_matterport_region.py \
data.masks.masks_path=${SCENE_MASK_PATH} \
data.camera.poses_path=${SCENE_POSE_DIR} \
data.camera.intrinsic_path=${SCENE_INTRINSIC_PATH} \
data.camera.intrinsic_resolution=${SCENE_INTRINSIC_RESOLUTION} \
data.depths.depths_path=${SCENE_DEPTH_IMG_DIR} \
data.depths.depth_scale=${DEPTH_SCALE} \
data.depths.depths_ext=${DEPTH_EXTENSION} \
data.images.images_path=${SCENE_COLOR_IMG_DIR} \
data.images.images_ext=${IMG_EXTENSION} \
data.point_cloud_path=${REGION_3D_PATH} \
output.output_directory=${OUTPUT_FOLDER_DIRECTORY} \
output.save_crops=${SAVE_CROPS} \
hydra.run.dir="${OUTPUT_FOLDER_DIRECTORY}/hydra_outputs/mask_features_computation" \
external.sam_checkpoint=${SAM_CKPT_PATH} \
gpu.optimize_gpu_usage=${OPTIMIZE_GPU_USAGE} \
openmask3d.frequency=${FREQUENCY}
#echo "[INFO] Feature computation done!"


# print the datetime
echo "[INFO] $(date)"

