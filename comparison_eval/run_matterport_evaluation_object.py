import os
import json
import logging
from datetime import datetime


MATTERPORT_DIR = "/media/rsl_admin/T7/matterport/data/v1/scans"

LATTICE_GRAPHS_DIR = "/media/rsl_admin/T7/matterport/lattice_graphs"

OUTPUT_DIR = "/home/rsl_admin/openmask3d/eval_output"

# OM3D_REGION_INSTANCES_DIR = \
    # "/home/rsl_admin/openmask3d/labeled_instance_outputs/object-test"

# OM3D_REGION_INSTANCES_DIR = \
#     "/home/rsl_admin/openmask3d/labeled_instance_outputs/filt_iou_0.4/object-test"

# OM3D_REGION_INSTANCES_DIR = \
#     "/home/rsl_admin/openmask3d/labeled_instance_outputs/filt_iou_0.6/object-test"

OM3D_REGION_INSTANCES_DIR = \
    "/home/rsl_admin/openmask3d/labeled_instance_outputs/filt_iou_0.8/object-test"


if "filt_iou" in OM3D_REGION_INSTANCES_DIR:
    prepend_save_dir = OM3D_REGION_INSTANCES_DIR.split("/")[-2] + "-"
else:
    prepend_save_dir = ""

save_dir = os.path.join(
    OUTPUT_DIR, 
    f"{prepend_save_dir}object-{datetime.now().strftime('%Y-%m-%d_%H-%M')}"
)
os.makedirs(save_dir, exist_ok=True)

print(f"saving outputs to: {save_dir}")


scans = set()
for fname in os.listdir(OM3D_REGION_INSTANCES_DIR):
    scans.add(fname.split("_")[0])
    
scans = tuple(sorted(scans))

print(f"will process scans: {scans}")


BLACKLISTED_OBJECT_LABELS = (
    "misc", "objects", "void", "unlabeled",
    "wall", "floor", "ceiling", "other"
)

params = {
    "label_params": {
        "blacklisted_labels": BLACKLISTED_OBJECT_LABELS,
    },

    # Make sure sides of proposal boxes are at least this long
    "min_proposal_box_length": 0.1,

}


from evaluate_matterport_scan_object import evaluate_matterport_scan_object_localizations

# save the params
params_save_path = os.path.join(save_dir, 'params.json')
with open(params_save_path, 'w') as f:
    json.dump(params, f)


logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
# logger.setLevel(logging.DEBUG)
logger.setLevel(logging.INFO)


# run the evaluation
for scan_name in scans:

    scan_dir = os.path.join(MATTERPORT_DIR, f"{scan_name}/{scan_name}")
    lattice_graph_path = os.path.join(LATTICE_GRAPHS_DIR, f"{scan_name}_lattice_graph.pkl")
    
    evaluate_matterport_scan_object_localizations(
        params=params,
        scan_dir=scan_dir,
        om3d_region_instances_dir=OM3D_REGION_INSTANCES_DIR,
        lattice_graph_path=lattice_graph_path,
        output_dir=save_dir,
        logger=logger,
    )