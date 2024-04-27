# Coordinate-Transformation-and-Visualization
Lidar sensors provide valuable data on surroundings, crucial for various automated robotic applications like self-driving cars. While Lidar offers a dense 360-degree point cloud, aligning camera images with this data results in sparse depth maps for specific cameras. This limitation hinders the utility of matched depth information for practical purposes.

Our project centers on extracting point cloud, camera images, and calibration parameters from the sample Kitti dataset [1], aiming to generate dense depth images for cameras with known translations and rotations. Below is a snapshot of the point cloud.

![image](https://github.com/Garrydcruz/Coordinate-Transformation-and-Visualization/assets/36693471/ec553ea8-f24b-4e20-bf58-987837b3038c)




Within the dataset, we have RGB images from camera2 and camera3, along with their respective projections in the calibration file. By parsing this calibration data, we generate a 3x4 projection matrix, denoted as P, which maps the [X;Y;Z;1] vector to pixel locations within the camera2 frame. Here is the camera image depicted below.
