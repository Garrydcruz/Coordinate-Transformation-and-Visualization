clear all
%close all
clc

% Read camera image
I = imread('data/image_2/0000000001.png');

%% Read calibration file

% Open and read calibration file
fd = fopen('data/calib/000001.txt');
raw_data = fscanf(fd,'%c');
fclose(fd);

% Extract calibration parameters
ii = find(raw_data == ':')+1;
ie = find(raw_data == 10 );

P0 = reshape(str2num( raw_data(ii(1):ie(1)) ),4,3)';
P1 = reshape(str2num( raw_data(ii(2):ie(2)) ),4,3)';
P2 = reshape(str2num( raw_data(ii(3):ie(3)) ),4,3)';
P3 = reshape(str2num( raw_data(ii(4):ie(4)) ),4,3)';
R0_rect = reshape(str2num( raw_data(ii(5):ie(5)) ),3,3)';
Tr_velo_to_cam = reshape(str2num( raw_data(ii(6):ie(6)) ),4,3)';
Tr_imu_to_velo = reshape(str2num( raw_data(ii(7):ie(7)) ),4,3)';

%% Read Lidar data file
fd = fopen('data/velodyne/0000000001.bin','rb');
velo = fread(fd,[4 inf],'single')';
fclose(fd);

% Remove all points behind image plane (approximation)
idx = velo(:,1)<5;
velo(idx,:) = [];

% Exclude luminance and set last column to all 1
velo(:,4)=1;

% Plot raw point cloud
figure;
plot3(velo(:,1),velo(:,2),velo(:,3),'r.');
title('Raw Point Cloud');

% Create projection matrix
R0_rect(4,4)=1;
Tr_velo_to_cam(4,4)=1;
P=P2 * R0_rect * Tr_velo_to_cam;

% Project points to image plane 
px = (P * velo')';
px(:,1) = px(:,1)./px(:,3);
px(:,2) = px(:,2)./px(:,3);

% Remove out of image size indexes
px(px(:,1)<1,:)=[];
px(px(:,1)>size(I,2),:)=[];    
px(px(:,2)>size(I,1),:)=[];

[n, m, ~] = size(I);

% Compute dense depth map
tic
[fulldepth, depth] = dense_depth_map(px, n, m, 4);
toc

% Visualize full depth map
figure;
imagesc(fulldepth,[0 30]);
axis image
axis off
title('Full Depth Map (Grid Size = 4)');

% Visualize initial depth map
figure;
imagesc(depth);
axis image
axis off
title('Initial Depth Map');

% Composite image of grayscale left image and disparity map 

tmp(:,:,1) = double(rgb2gray(I))/255;
tmp(:,:,2) = tmp(:,:,1);
tmp(:,:,3) = tmp(:,:,1);

dmap = 1./fulldepth;
dmap(isinf(dmap))=0;
dmap = 63*(dmap-min(dmap(:)))./(max(dmap(:))-min(dmap(:)));
dmap = round(dmap);

figure;
sc = colormap('jet');
DImage = 0.5*tmp + 0.5*reshape(sc(dmap+1,:), [n,m ,3]);
imshow((DImage));
title('Inverse of Depth');
