setwd('Downloads/anat_img/')
######################################################################
### oro.nifti is packages for anat neuroimaging structure anakysis ###
######################################################################

library(oro.nifti)

######################################################################
### read in the base data###
######################################################################

anat_img <- readNIfTI('anat.nii', reorient = TRUE)

######################################################################
### dimension of the image###
######################################################################

dim(anat_img)
slotsNames(anat_img)

######################################################################
### visualize the data###
######################################################################

# axial slice#
image(anat_img[,,128])

#cronal slice#
image(anat_img[,128,], col = rainbow(12))

#sigittal slice#
image(anat_img[128,,], col = topo.colors(12))

######################################################################
###using orthographic function(form oro.nifti package)###
######################################################################

orthographic(anat_img)
orthographic(anat_img, xyz = c(90, 100, 15))

######################################################################
### calculation of the nifti objects###
######################################################################
mean(anat_img)
std(anat_img)
min(anat_img)
max(anat_img)

#histgrom of the image#
hist(anat_img)

######################################################################
### load in the follow study data###
######################################################################

second_data <- readNIfTI('anat.img', reorient = TRUE)

######################################################################
### plot baseline and followup data ###
######################################################################

install.packages(fslr)
library(fslr)

######################################################################
### fsl is useful tools for neuroimaging analysis ###
######################################################################

double_ortho(anat_img, second_data)

# plot the different between the first and second #

diff = anat_img - second_data
orthographic(diff)

######################################################################
### processing the data using fslr ###
######################################################################

## set path to fsl ##

option(fsl.path ='/usr/share/fsl/4.1/')

######################################################################
### Inhomogenity correction with fslr 'fsl_biascorrect' ###
##################################################################

bias_corr_nat_img <- fsl_biascorrect(second_data)

anat_img_bias_corr_img  <- readNIfTI('bias_corr_nat_img', reorient=TRUE)

bias_diff = anat_img_bias_corr_img  - anat_img

orthographic(bias_diff)

######################################################################
### skull strip with fslr using fslbet ###
######################################################################

anat_img_bias_corr_img_strip <- fslbet(anat_img_bias_corr_img, 
	reorient = TRUE)
double_ortho(anat_img, anat_img_bias_corr_img_strip)

## mask a brain mask from the strip skull brain ##

bet_mask <- niftiarr(anat_img_bias_corr_img_strip, 1)
is_in_mask <- anat_img_bias_corr_img_strip >0
bet_mask[!is_in_mask] <- NA 


## plot ##
orthographic(anat_img_bias_corr_img, bet_mask)

# a best histgrom #
hist(anat_img_bias_corr_img[bet_mask] ==1)

# write the brain mask
writeNIfTI(bet_mask, filename = 'r_test_brain_mask', verbose= TRUE,
	gzipped = TRUE)


######################################################################
### Registration of the follup to the baseline with a rigid regi-
### starion ###
######################################################################

anat_img_bias_reg_img = flirt(second_data, anat_img, dof =6,
	retimg= TRUE, reorient = TRUE)

anat_img_reg_diff <- anat_img - anat_img_bias_reg_img

double_ortho(diff, anat_img_reg_diff)

######################################################################
### antsr analysis###
##################################################################

install.packages("devtools")
libraryr(devtools)
install_github("stnava/cmake")
install_github("stnava/ITKR")
install_github("stnava/ANTsR")

## more R packages for structure neurimaging analysis##
install_packages("oro.dicom")   # working with DICOM
install_github("muschellij2/extrantsr")  # EXTRA ANTsR functions

##the different tools for norimoazational for neuroimaging##
install.packages("WhiteStripe")
library(devtools)
install_github("Jfortin1/RAVEL")


## using some algorithm to find some wrong areas in our brain##
# 1. R packages : oasis
# 2. R packages : SuBLIME
# instal this packaegs
install.packages("oasis")

library(devtools)
install_github("emsweene/SuBLIME_package")

# more info about neuroimaging analysis see Neurohacking for R:
# www.coursera.org/learn/neurohacking/
 