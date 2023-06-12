function get_marsbar_rois(coord,radius,voxel_size)

if voxel_size==2 % 2x2x2 mm3 (matrix size: 91x109x91)
    space1 = 'spacebase';
elseif voxel_size==3 % 3x3x3 mm3 (matrix size: 61x73x61)
    space1 = 'spacebase2';
else
    error('currently voxel size of 2 or 3 are supported; code needs to be modified to permit other values')
end

addpath(genpath('marsbar-0.43'))
copyfile('spm_get.m','spheres_marsbar_mat/spm_get.m');
[n1,n2] = size(coord);

for k=1:n1
cd spheres_marsbar_mat
c = coord(k,:)';
r = radius; %10mm voxel, for example
cd ..
o = maroi_sphere(struct('centre',c,'radius',r));
cd spheres_marsbar_mat
d = sprintf('sphere');
o = descrip(o,d);
l = sprintf('%d',k);
o = label(o,l);
fn = maroi('filename', mars_utils('str2fname', label(o)));
fnn{k} = fn;
f = sprintf('%s_roi.mat',l);
p = fn(1:end-length(f));
roi_fname = maroi('filename', fullfile(p, f));
saveroi(o, roi_fname)
clear c r o d f roi_fname
cd ..

%%
roi_list = fn;
img_name = sprintf('%sniisave%s%s.nii',p(1:end-20),p(3),l);
roi_space = maroi('classdata', space1); % 'space' variable defined earlier
% roi_space = maroi('classdata', 'spacebase'); % 91x109x91 ROIs (2x2x2 mm3 voxels)
% roi_space = maroi('classdata', 'spacebase2'); % 61x73x61 ROIs (3x3x3 mm3 voxels)

% In order to change the voxel size above, open the file 'my_classdata' in marsbar toolbox folder,
% and add another 't1mat' variable (say t1mat3) like in lines 30-33 (replace 2 by voxel size in mm),
% and another 'spacebase' line (say spacebase3) like in line 39: mention the matrix size here.
% Then add another line above with, say, spacebase3 as the input variable

flags = 'i';

roi_list = maroi('load_cell', roi_list);
roi_len = prod(size(roi_list));

img_data = zeros(roi_space.dim);
roi_ctr = 1;
for i = 1:roi_len
  roi = roi_list{i};
  % check ROI contains something
  if isempty(roi) 
    warning(sprintf('ROI %d is missing', i));
  elseif is_empty_roi(roi)
    warning(sprintf('ROI %d:%s is empty', i, label(roi)));
  else    
    % convert ROI to matrix
    mo = maroi_matrix(roi, roi_space);
    dat = matrixdata(mo);
    if isempty(dat) | ~any(dat(:))
      warning(sprintf('ROI %d: %s  - contains no points in this space',...
		      i, label(roi)));
    else
      % add matrix to image
      if any(flags == 'i')
	img_data(dat ~= 0) = roi_ctr;
	roi_info(roi_ctr) = struct('label', label(roi),...
				   'number', roi_ctr);
      else
	img_data = img_data + dat;
      end
      roi_ctr = roi_ctr + 1;
    end
  end
end
if roi_ctr == 1
  warning('Found no useful ROIs, no image saved');
  return
end

% output image type
img_type = 'float'; % to avoid rounding errors

% save ROI info
if any(flags == 'i')
  [p f e] = fileparts(img_name);
  iname = fullfile(p, [f '_labels.mat']);
  save(iname, 'roi_info');
end

% Prepare and write image
V = mars_vol_utils('def_vol');
V.fname = img_name;
V.mat = roi_space.mat;
V.dim(1:3) = roi_space.dim;
V = mars_vol_utils('set_type', V, img_type);

V = spm_create_vol(V);
V = spm_write_vol(V, img_data);

cd niisave
delete('*.mat')
cd ..

clear V ans c d dat e f flags fn i img_data img_name img_type iname l mo o roi roi_ctr roi_fname roi_info roi_len roi_list roi_space r

end

%%
roi_list = fnn;
img_name = sprintf('%sall_ROIs_combined.nii',p(1:end-7)); clear p
roi_space = maroi('classdata', space1);
flags = 'i';

roi_list = maroi('load_cell', roi_list);
roi_len = prod(size(roi_list));

img_data = zeros(roi_space.dim);
roi_ctr = 1;
for i = 1:roi_len
  roi = roi_list{i};
  % check ROI contains something
  if isempty(roi) 
    warning(sprintf('ROI %d is missing', i));
  elseif is_empty_roi(roi)
    warning(sprintf('ROI %d:%s is empty', i, label(roi)));
  else    
    % convert ROI to matrix
    mo = maroi_matrix(roi, roi_space);
    dat = matrixdata(mo);
    if isempty(dat) | ~any(dat(:))
      warning(sprintf('ROI %d: %s  - contains no points in this space',...
		      i, label(roi)));
    else
      % add matrix to image
      if any(flags == 'i')
	img_data(dat ~= 0) = roi_ctr;
	roi_info(roi_ctr) = struct('label', label(roi),...
				   'number', roi_ctr);
      else
	img_data = img_data + dat;
      end
      roi_ctr = roi_ctr + 1;
    end
  end
end
if roi_ctr == 1
  warning('Found no useful ROIs, no image saved');
  return
end

% output image type
img_type = 'float'; % to avoid rounding errors

% save ROI info
if any(flags == 'i')
  [p f e] = fileparts(img_name);
  iname = fullfile(p, [f '_labels.mat']);
  save(iname, 'roi_info');
end

% Prepare and write image
V = mars_vol_utils('def_vol');
V.fname = img_name;
V.mat = roi_space.mat;
V.dim(1:3) = roi_space.dim;
V = mars_vol_utils('set_type', V, img_type);

V = spm_create_vol(V);
V = spm_write_vol(V, img_data);

end