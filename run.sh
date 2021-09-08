#!/bin/bash

## This app will apply a warp field to a func/task datatype

set -x
set -e

input=`jq -r '.input' config.json`
template=`jq -r '.template' config.json`
warp=`jq -r '.warp' config.json`
label=`jq -r '.label' config.json`
key=`jq -r '.key' config.json`

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

[ ! -f ./output/bold.nii.gz ] && applywarp --interp=nn --ref=${template} --in=${input} --warp=${warp} --out=./output/parc.nii.gz

[ ! -f ./output/label.json ] && cp ${label} ./output/label.json

if [[ -f ${key} ]]; then
    [ ! -f ./output/key.txt ] && cp ${key} ./output/key.txt
fi

slicer ./output/parc.nii.gz -x 0.5 out_aligncheck.png

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
