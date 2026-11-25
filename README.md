<h1 align="center">Apply warp to BOLD data and parcellations</h1>

<p align="center">
  BOLD fMRI data or a volumetric parcellation resampled into MNI152 or NIHPD template space with an existing nonlinear warp and FSL applywarp.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.566"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.566-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `v1.0`, is the brainlife.io App Apply warp to BOLD data** ([doi:10.25663/brainlife.app.566](https://doi.org/10.25663/brainlife.app.566)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Applies an existing FSL nonlinear warp to BOLD fMRI data with FSL applywarp, resampling it into MNI152 2 mm or NIHPD template space.**

Runs applywarp (nearest-neighbour interpolation) on the func/task image with the supplied warp field, using MNI152 T1 2 mm as the reference for every MNI choice or the selected NIHPD template, and sets the output space tag. It does not compute a registration; the warp must map the BOLD data's space to the chosen template. A slice image is produced for alignment checking.

| | |
|---|---|
| **Inputs** | `neuro/func/task` · `neuro/transform/nifti` |
| **Outputs** | `neuro/func/task` |
| **Container** | `brainlife/fsl:6.0.4` |
| **Resources** | 4 CPUs · 2 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.566](https://doi.org/10.25663/brainlife.app.566) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `bold` | `neuro/func/task` | yes | BOLD fMRI image (func/task) to warp. |
| `transform` | `neuro/transform/nifti` | yes | Nonlinear warp field (warp) to the template space. Must map the BOLD image's space to the selected template. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/func/task` | The warped BOLD file |

<details>
<summary><b>Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `template` | enum | `MNI152_1mm` | Template defining the output space: any MNI152 option uses the MNI152 T1 2 mm image as applywarp reference; NIHPD options use the matching pediatric template. Options: `MNI152_1mm`, `nihpd_asym_04.5-08.5`, `nihpd_asym_04.5-18.5`, `nihpd_asym_07.0-11.0`, `nihpd_asym_07.5-13.5`, `nihpd_asym_10.0-14.0`, `nihpd_asym_13.0-18.5`. |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

Each App is built from its own branch of this repository.

| Version | FSL | Branch | Run it | Status |
|---|---|---|---|---|
| Apply warp to Parcellation | 6.0.4 | [`parc-v1.0`](https://github.com/brainlife/app-warp-bold/tree/parc-v1.0) | [doi:10.25663/brainlife.app.569](https://doi.org/10.25663/brainlife.app.569) | current |
| **Apply warp to BOLD data** (this branch) | 6.0.4 | [`v1.0`](https://github.com/brainlife/app-warp-bold/tree/v1.0) | [doi:10.25663/brainlife.app.566](https://doi.org/10.25663/brainlife.app.566) | available |

## Running the App

### On brainlife.io

Open [Apply warp to Parcellation](https://doi.org/10.25663/brainlife.app.569) or [Apply warp to BOLD data](https://doi.org/10.25663/brainlife.app.566), choose the parcellation (`neuro/parcellation/volume`) or BOLD (`neuro/func/task`) dataset and the nonlinear warp (`neuro/transform/nifti`), pick the template and press **Execute**. The warped dataset is archived to your project with the tag `warped` and a `space-…` tag, and an alignment-check image is shown on the task page.

The App does not compute a registration: the warp must map the input's space to the chosen template. `template` selects the output space:

- **`MNI152_1mm`** (default): the FSL MNI152 T1 2 mm image is used as the `applywarp` reference; the output is tagged `space-MNI152NLin6Asym`.
- **`nihpd_asym_<age range>`** (4.5–8.5, 4.5–18.5, 7.0–11.0, 7.5–13.5, 10.0–14.0 or 13.0–18.5 years): the matching NIHPD asymmetric (natural) paediatric T1w template, tagged `space-NIHPD`.

Both Apps use nearest-neighbour interpolation.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/); `main` runs FSL 6.0.4 from `brainlife/fsl:6.0.4`. The templates are in `templates/`.

1. Clone this repository and check out the App you want (`git checkout parc-v1.0` or `git checkout v1.0`).
2. Create `config.json` with the paths to your inputs:

   ```json
   {
       "input": "/input/parc/parc.nii.gz",
       "label": "/input/parc/label.json",
       "key": "/input/parc/key.txt",
       "warp": "/input/transform/warp.nii.gz",
       "template": "MNI152_1mm"
   }
   ```

   For BOLD data, set `input` to the BOLD image (for example `/input/bold/bold.nii.gz`) and leave out `label` and `key`.

3. Run the App:

   ```bash
   ./main
   ```

### Sample data

Download sample datasets from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download <dataset-id>
```

## Outputs

```text
output/
├── parc.nii.gz    warped parcellation (Apply warp to Parcellation), with label.json and key.txt (if given)
└── bold.nii.gz    warped BOLD image (Apply warp to BOLD data)
product.json       output space tag and an alignment-check image (slicer, -x 0.5)
```

## Troubleshooting

- **Output misaligned with the template**: the warp must map the input's space to the selected template; check the alignment-check image on the task page.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Woolrich MW, Jbabdi S, Patenaude B, Chappell M, Makni S, Behrens T, Beckmann C, Jenkinson M, Smith SM. Bayesian analysis of neuroimaging data in FSL. *NeuroImage* 45:S173–86 (2009).
- Smith SM, Jenkinson M, Woolrich MW, Beckmann CF, Behrens TEJ, Johansen-Berg H, Bannister PR, De Luca M, Drobnjak I, Flitney DE, Niazy R, Saunders J, Vickers J, Zhang Y, De Stefano N, Brady JM, Matthews PM. Advances in functional and structural MR image analysis and implementation as FSL. *NeuroImage* 23(S1):208–19 (2004).
- Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, Smith SM. FSL. *NeuroImage* 62:782–790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Apply warp to BOLD data. brainlife.io App. [doi:10.25663/brainlife.app.566](https://doi.org/10.25663/brainlife.app.566)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). FSL is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
