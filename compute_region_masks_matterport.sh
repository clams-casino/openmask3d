#!/bin/bash
export OMP_NUM_THREADS=9  # speeds up MinkowskiEngine
set -e

REGION_3D_PATH=$1
OUTPUT_DIRECTORY=$2

# RUN OPENMASK3D FOR A SINGLE REGION OF A MATTERPORT SCENE

# Get filename from the path
REGION_3D_FILENAME=$(basename -- "$REGION_3D_PATH")
MASK_OUTPUT_FOLDER="${REGION_3D_FILENAME%.*}"

# model ckpt paths
CKPT_PATH="/home/rsl_admin/openmask3d/checkpoints"
MASK_MODULE_CKPT_PATH="${CKPT_PATH}/scannet200_model.ckpt"

# output directories to save masks and mask features
OUTPUT_FOLDER_DIRECTORY="${OUTPUT_DIRECTORY}/${MASK_OUTPUT_FOLDER}"
SAVE_VISUALIZATIONS=false #if set to true, saves pyviz3d visualizations


cd openmask3d

# 1. Compute class agnostic masks and save them
echo "[INFO] Extracting class agnostic masks..."
python class_agnostic_mask_computation/get_masks_os_matterport_region.py \
general.experiment_name=${EXPERIMENT_NAME} \
general.checkpoint=${MASK_MODULE_CKPT_PATH} \
general.train_mode=false \
data.test_mode=test \
model.num_queries=120 \
general.use_dbscan=true \
general.dbscan_eps=0.95 \
general.save_visualizations=${SAVE_VISUALIZATIONS} \
general.scene_path=${REGION_3D_PATH} \
general.mask_save_dir="${OUTPUT_FOLDER_DIRECTORY}" \
hydra.run.dir="${OUTPUT_FOLDER_DIRECTORY}/hydra_outputs/class_agnostic_mask_computation" 
echo "[INFO] Mask computation done!"

