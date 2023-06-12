Run run_ROI.m on a system running MATLAB and SPM12 to get all Power atlas ROIs.

spm_get.m is a helper function for get_marsbar_rois.m which is does the majority of the work
to define the ROIs.

/coordinates contains the learned and uncleaned Excel files with coordinates for each ROI 
(in MNI space). 

/marsbar-0.43 contains the MATLAB files for the Marsbar package. 

/spheres_marsbar_mat contains .mat files used to define each spherical ROI.