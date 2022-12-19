
<a href="https://zenodo.org/badge/latestdoi/578834231"><img src="https://zenodo.org/badge/578834231.svg" alt="DOI"></a>

Code authors: Vera Weisbecker, supported by Thomas Guillerme

This code runs all R- based analyses for the manuscript "Multiple modes of inference reveal less phylogenetic signal in marsupial basicranial shape compared to the rest of the cranium" by Vera Weisbecker, Leonie Lange-Hodgson, Robin M D Beck, Arianna Harrington, Michael S Y Lee, Thomas Guillerme, and Matthew Phillips, accepted at the Mammalian Skull Special Issue of the Philosophical Transactions of the Royal Society B


*All scripts are in RMarkdown format (.Rmd) and can be opened in RStudio. There, you can edit and run code chunks as normal or use the Knit button to create HTML versions with both code and output. After cloning this repo, remember to either set your working directory to this folder on your computer or open an RStudio project from that folder.*

*The code is commented out and hopefully explains sufficiently where the various data and auxiliary files are needed. The following is just a brief overview.*

## Data
**Raw data:**
The [Raw Data](/Data/Raw/) folder in this repository contains all original data required to run the analyses. On the top level, it contains a [specimen data file](/Data/Raw/Species_classifier) for information associated with each specimen, as well as auxiliary files for removal of bilateral symmetry, landmark partitions, and a [single small .ply file](/Data/Raw/Marmosa_murina_MVZ197429_downsampled.ply) which represents the specimen on which the mean shape and PACA shapes are warped. In addition, it holds the following folders:

* [Coordinates](/Data/Raw/Coordinates/) contains the coordinates required to run all analyses. For the original surface meshes and associated Stratovan Checkpoint files, please go to the [figshare repository associated with this study](https://figshare.com/s/6b8027a0f0e7df492d09).
* [Reference phylogeny](/Data/Raw/Reference_phylogeny/) contains the reference phylogeny and files related to its construction.
* [Discrete phylogeny files] contains the reference phylogeny files as well as a list of basicranial characters from Beck et al. 2022.

**Processed:**
[Processed](/Data/Processed/) contains processed data derived from [Raw Data](/Data/Raw/). On the top level, this is where .rda files which store the outputs from the code in [Analyses](/Analyses/). In addition, it holds the following folders: 

* [Molecular_distance_trees](/Data/Processed/Molecular_distance_trees) contains the subfolder [UPGMA_distances_PAUP](/Data/Processed/Molecular_distance_trees/UPGMA_distances_PAUP), containing the data, commands, and outputs for the UPGMA distances of DNA data:a PAUP matrix with search commands, PAUP screenlog with distance matrices, and three PAUP treefiles. It also contains the subfolder [DNA_tnt](Data/Processed/Molecular_distance_trees/DNA_tnt) related to the TNT search on the DNA data, including the TNT matrix with search commands and the Treefile.
* [TNT_files](/Data/Processed/TNT_files/) contains all data and outputs for the parsimony-based tree searches done in TNT. This includes all the 3D datasets in TNT format, the TNT batch file, the stats_ci.run macro file, and the output treefiles

## Analyses 

This folder contains all R code required (in Rmarkdown format) to replicate the analyses in this study (except for the parsimony analyses, which were done in TNT). The files are broken up into the major steps of the workflow, and most output an .rda file into the [Processed](/Data/Processed/) folder. These can be used to load into the next step (so as to not laboriously replicate the previous steps every time).

* [01_1_Data_Preparation_MarsShapPhylo.Rmd](/Analyses/01_1_Data_Preparation_MarsShapPhylo.Rmd) This script is to read the coordinate data, phylogenies, and auxiliary files, and process them for analysis
* [01_2_Allometry_removal.Rmd](/Analyses/01_2_Allometry_removal.Rmd) is code in which the allometry analyses are performed and pgls allometry-free residuals are created
* [01_3_TNT_input_output.Rmd](/Analyses/01_3_TNT_input_output.Rmd) is a summary of the steps required to get R to talk to TNT
* [02_01_Standard_Allom_Physig_Analyses.Rmd](/Analyses/02_01_Standard_Allom_Physig_Analyses.Rmd) performs all conventional analyses within the geomorph package (PGLS, Phylogenetic signal, PACA)
* [02_02_generating_reduced_trees.Rmd](/Analyses/02_02_generating_reduced_trees.Rmd) contains the operations for obtaining successively pruned molecular reference trees and landmark dataset matching the pruned phylogenies. It also contains the code for exporting the landmark data into a format read by TNT, and the creation of 10,000 random trees.
* [02_03_distance_computations.Rmd](/Analyses/02_03_distance_computations.Rmd)  is code to compute distances between trees (including reference, GMM, and alternative molecular trees relative to the random trees. It also contains the code for output in Figures 4 and 5 of the manuscript (it was easier to leave here for workflow reasons).
* [02_04_cophenetic_tree_comparsions.Rmd](/Analyses/02_04_cophenetic_tree_comparisons.Rmd) has computations of co-phenetic matrix comparisons.
* [03_01_Figures_plots.Rmd](/Analyses/03_01_Figures_plots.Rmd) includes the code for most figures in the manuscript and supplementary files. It outputs into the [Figures](/Figures) folder

## Results

The [Results](/Results/) folder contains tabular outputs from the analyses for easier integration into the manuscript

## Figures 

[Figures](/Figures/) contains outputs from [03_01_Figures_plots.Rmd](/Analyses/03_01_Figures_plots.Rmd) and other components required for making figures. It requirese creation of sub-folders for particular figures as outlined in the code, and a Usrmats folder which contains coordinates for ensuring that meshes are oriented appropriately for screenshotting. 
 
