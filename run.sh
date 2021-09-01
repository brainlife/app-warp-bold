#!/bin/bash

## This app will apply a warp field to a func/task datatype

set -x
set -e

input=`jq -r '.input' config.json`
template=`jq -r '.template' config.json`
warp=`jq -r '.warp' config.json`

[ ! -d ./output ] && mkdir -p output

product=""

#we use space from
#https://bids-specification.readthedocs.io/en/stable/99-appendices/08-coordinate-systems.html#template-based-coordinate-systems


case $template in
nihpd_asym*)
    space="NIHPD"
    template=templates/${template}_t1w.nii
    ;;
*)
    space="MNI152NLin6Asym"
    template=templates/MNI152_T1_2mm
    ;;
esac

[ ! -f ./output/bold.nii.gz ] && applywarp --ref=${template} --in=${input} --warp=${warp} --out=./output/bold.nii.gz

# create product.json
cat << EOF > product.json
{
    "output": { "meta": { "Space": "$space" }, "tags": [ "space-$space"] },
    "brainlife": [
        { 
            "type": "image/png", 
            "name": "Alignment Check (-x 0.5)",
            "base64": "$(base64 -w 0 out_aligncheck.png)"
        }
    ]
}
EOF
echo "all done!"
