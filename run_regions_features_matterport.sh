SCAN_NAME=$1

REGIONS_3D_DIR="/home/rsl_admin/openscene/openscene/data/matterport_3d/test"

DATA_2D_DIR="/home/rsl_admin/openmask3d/process_matterport_2d"

MASK_OUTPUT_DIRECTORY="/home/rsl_admin/openmask3d/test_output/region_masks/test"

FREQUENCY=1


# Get all region 3D filenames in REGIONS_3D_DIR which contains the scan name
REGION_3D_PATHS=$(find $REGIONS_3D_DIR -name "*${SCAN_NAME}*.pth")


# iterate over all region filenames
for REGION_3D_PATH in $REGION_3D_PATHS; do
    REGION_3D_BASENAME=$(basename -- $REGION_3D_PATH)
    REGION_3D_NAME="${REGION_3D_BASENAME%.*}"

    echo "Processing ${REGION_3D_NAME} ..."
    bash ./compute_region_mask_features_matterport.sh $REGION_3D_PATH $DATA_2D_DIR $MASK_OUTPUT_DIRECTORY $FREQUENCY
    echo "--------------------------------------------------"
    echo "" && echo ""
done

