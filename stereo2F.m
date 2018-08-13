% clear all;
% close all;
% clc;
%
% [~, F(:, 1), F(:, 2), F(:, 3), ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = ...
%     textread('F.fcsv','%s%f%f%f%f%f%f%f%f%f%f%s%s%s', 'delimiter',',','headerlines',3);

function stereo2F_mat = stereo2F(F);

square = [1 1 -1 -1; 1 -1 1 -1; 0 0 0 0; 1 1 1 1];
opts = optimoptions(@fmincon);
affineP = [mean(F([1 3 4 6], :), 1).'; 0; 0; 0; mean([sqrt(sum((F(1, :)-F(4, :)).^2)), sqrt(sum((F(3, :)-F(6, :)).^2))])/2; mean([sqrt(sum((F(1, :)-F(3, :)).^2)), sqrt(sum((F(4, :)-F(6, :)).^2))])/2; 1; 0; 0; 0];
for i = 1;
    [affineP, affinefval] = fmincon(@(affineP)rigid_error(affineP, [F([1 3 4 6], :).'; 1 1 1 1], square), affineP, [], [], [], [], max(affineP-[10 10 10 pi/4 pi/4 pi/4 10 10 0 1 1 1].', [-inf -inf -inf -inf -inf -inf -inf 60 0 -inf -inf -inf].'), affineP+[10 10 10 pi/4 pi/4 pi/4 10 10 0 1 1 1].', [], opts);
end

invF = spm_matrix(affineP.')\[F.'; 1 1 1 1 1 1];
invF(1, 1:3) = 1;
invF(1, 4:6) = -1;
invF(2, [1 4]) = 1;
invF(2, [3 6]) = -1;
normF = spm_matrix(affineP.')*invF;
normF = normF(1:3, :).';

distnormF = (sqrt(sum((normF(1, :)-normF(3, :)).^2))/2+sqrt(sum((normF(4, :)-normF(6, :)).^2))/2)/2;

rateF1 = (1-invF(2, 2))/(invF(2, 2)+1);
rateF2 = (1-invF(2, 5))/(invF(2, 5)+1);

% rateF1 = (normdistF(1)-normdistF(2))/(normdistF(2)-normdistF(3));
% rateF2 = (normdistF(4)-normdistF(5))/(normdistF(5)-normdistF(6));

stereo(2, 3) = -60+120*rateF1/(rateF1+1);
stereo(5, 3) = -60+120*rateF2/(rateF2+1);
stereo(2, 2) = -stereo(2, 3);
stereo(5, 2) = -stereo(5, 3);
stereo(1:3, 1) = 95;
stereo(4:6, 1) = -95;
stereo([1 4], 2) = 60;
stereo([3 6], 2) = -60;
angleF = acos(60/distnormF);
angleF = -angleF; % Ç°ÃæµÍ
stereo(1, 3) = stereo(2, 3)+distnormF*(1-invF(2, 2))*sin(angleF);
stereo(3, 3) = stereo(2, 3)-distnormF*(invF(2, 2)+1)*sin(angleF);
stereo(4, 3) = stereo(5, 3)+distnormF*(1-invF(2, 5))*sin(angleF);
stereo(6, 3) = stereo(5, 3)-distnormF*(invF(2, 5)+1)*sin(angleF);

% pcaF = pca(F);
% pcanormF = pca(normF);
% pcastereo = pca(stereo);

F = [F.'; ones(1, size(F, 1))];
normF = [normF.'; ones(1, size(normF, 1))];
stereo = [stereo.'; ones(1, size(stereo, 1))];

% X = F/stereo;
% X = [F [pcaF; 1 1 1]]/[stereo [pcastereo; 1 1 1]];

% X = [[F.'; ones(1, size(F, 1))] [repmat(mean(F, 1).', [1, 3])+pcaF; 1 1 1]]/[[stereo.'; ones(1, size(stereo, 1))] [repmat(mean(stereo, 1).', [1, 3])+pcastereo; 1 1 1]];

rigidP = [mean(F(1:3, :), 2)-mean(stereo(1:3, :), 2); 0; 0; 0];
for i = 1;
    [rigidP, rigidfval] = fmincon(@(rigidP)rigid_error(rigidP, F, stereo), rigidP, [], [], [], [], [-100 -100 -100 -pi -pi -pi], [100 100 100 pi pi pi]);
end

stereo2F_mat = spm_matrix(rigidP.');

% Y = spm_mat2_slicer(spm_matrix(rigidP.'));
%
% write_slicer_mat('a.txt', Y);

end

%==========================================================================
% function rms = rigid_error(P, fixed, moving)
%==========================================================================
function rms = rigid_error(P, fixed, moving);

X = spm_matrix(P.');
rms = sqrt(mean(sqrt(sum((fixed-X*moving).^2, 1)).^2));

end

%==========================================================================
% function slicer_mat = spm_mat2_slicer(spm_mat)
%==========================================================================
function slicer_mat = spm_mat2_slicer(spm_mat);

% spm_coreg (which is 3dslicer/spm really read): translation*direction(rotation).
% 3dslicer_coreg (which is 3dslicer saved file): invz*direction*translation*invz.

% dir = [spm_mat(:, 1:3) [0; 0; 0; 1]];
% trans = [[1 0 0; 0 1 0; 0 0 1; 0 0 0] spm_mat(:, 4)];
invz = diag([1 1 -1 1]);
[dir, trans] = qr(invz*spm_mat*invz);

% in case inversion of direction.
adjxyz = diag([1; 1; 1; 1]-(diag(trans)<0)*2);

slicer_mat = adjxyz*trans*dir*adjxyz;

end

%==========================================================================
% function write_slicer_mat(filename, slicer_mat, fixed)
%==========================================================================
function write_slicer_mat(filename, slicer_mat, fixed);

% #Insight Transform File V1.0
% #Transform 0
% Transform: AffineTransform_double_3_3
% Parameters: 0.9855185992059645 -0.1524137461224298 0.07431783508715198 0.1190759242525363 0.9340857064730737 0.3366078092173489 -0.1207228846678121 -0.3228837917202201 0.9387076446699769 -11.69840592873397 -62.8038732891447 -152.5461608703792
% FixedParameters: 0 0 0

slicer_mat = slicer_mat(1:3, :);
slicer_mat = slicer_mat(:);
if nargin < 3;
    fixed = [0; 0; 0];
end

fid=fopen(filename,'w');
fprintf(fid,'#Insight Transform File V1.0\r\n');
fprintf(fid,'#Transform 0\r\n');
fprintf(fid,'Transform: AffineTransform_double_3_3\r\n');
fprintf(fid,'Parameters:');
for i = 1:12;
    fprintf(fid,' %.16g',slicer_mat(i));
end
fprintf(fid,'\r\nFixedParameters:');
for i = 1:3;
    fprintf(fid, ' %g', fixed(i));
end
fprintf(fid,'\r\n');
fclose(fid);

end