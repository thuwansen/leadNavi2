function VG_reg2_VF_mat = init_coreg(filename);

%该函数用于将CT和MR进行配准
%申伦豪

%% set input image and setting.
% option1: reference image.
% option2: moving image.
% option3: initial transform (center of VOI is available).
% option4: samling step.
% option5: accuracy of each parameter.
% option6: smooth FWHM of histogram.

% moving image filename.
VG = spm_vol(filename{1});

% reference image filename.
VF = spm_vol(filename{2});

% initialize transform using center of VOI.
geometry = true;

% sampling step: default [4, 2].
flags.sep = [4, 2];

% cost function:  'mi'  - Mutual Information
%                 'nmi' - Normalised Mutual Information
%                 'ecc' - Entropy Correlation Coefficient
%                 'ncc' - Normalised Cross Correlation
%                 default: 'nmi' for brain registration; 'ncc' for lead
%                 registration.
flags.cost_fun = 'nmi';

% initial parameters.
% P(1)  - x translation.
% P(2)  - y translation.
% P(3)  - z translation.
% P(4)  - x rotation about - {pitch} (radians).
% P(5)  - y rotation about - {roll}  (radians).
% P(6)  - z rotation about - {yaw}   (radians).
flags.params = [0 0 0 0 0 0];

if geometry;
    % calculate center voxel's coordinate and calculate initial transform.
    init_trans = VF.mat*[(VF.dim.'+[1; 1; 1])/2; 1]-VG.mat*[(VG.dim.'+[1; 1; 1])/2; 1];
    flags.params(1:3) = init_trans(1:3);
end

% tolerences for accuracy of each param: default [0.02 0.02 0.02 0.001
% 0.001 0.001].
flags.tol = [0.02 0.02 0.02 0.001 0.001 0.001];

% smoothing to apply to 256x256 joint histogram: default [7 7].
flags.fwhm = [0, 0]; 

%% start coregistration.
VG_reg2_VF = spm_coreg(VG, VF, flags);
% spm coreg matrix: apply to reference image.
% VF_reg2_VG = flags.params;
VG_reg2_VF_mat = spm_matrix(VG_reg2_VF(:).');

end