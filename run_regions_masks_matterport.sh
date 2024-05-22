REGIONS_3D_DIR="/home/rsl_admin/openscene/openscene/data/matterport_3d/test"

OUTPUT_DIRECTORY="/home/rsl_admin/openmask3d/test_output/region_masks/test"


for REGION_3D_PATH in $REGIONS_3D_DIR/*.pth; do
    echo "Processing $(basename -- $REGION_3D_PATH) ..."
    bash ./compute_region_masks_matterport.sh $REGION_3D_PATH $OUTPUT_DIRECTORY
    echo "--------------------------------------------------"
    echo "" && echo ""
done