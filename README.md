# Coordinate-Transformation-and-Visualization
Lidar sensors provide valuable data on surroundings, crucial for various automated robotic applications like self-driving cars. While Lidar offers a dense 360-degree point cloud, aligning camera images with this data results in sparse depth maps for specific cameras. This limitation hinders the utility of matched depth information for practical purposes.

Our project centers on extracting point cloud, camera images, and calibration parameters from the sample Kitti dataset [1], aiming to generate dense depth images for cameras with known translations and rotations. Below is a snapshot of the point cloud.

![image](https://github.com/Garrydcruz/Coordinate-Transformation-and-Visualization/assets/36693471/ec553ea8-f24b-4e20-bf58-987837b3038c)




Within the dataset, we have RGB images from camera2 and camera3, along with their respective projections in the calibration file. By parsing this calibration data, we generate a 3x4 projection matrix, denoted as P, which maps the [X;Y;Z;1] vector to pixel locations within the camera2 frame. Here is the camera image depicted below.
![image](https://github.com/Garrydcruz/Coordinate-Transformation-and-Visualization/assets/36693471/a80db308-0729-47be-a89c-ef28020be6a1)
To perform the projection, we utilize the standard projection process where P, X, Y, Z are known, but λ, x, y parameters need to be estimated. By solving the equation, we can determine the projection of each point onto the image plane represented by (x, y). Subsequently, we assign the λ value to the depth information of (x, y). However, this approach yields a sparse Map, with only 6% of its indexes having values.

To address this sparsity issue, we devised a solution. Instead of solely calculating the depth information of (x, y) locations, we also computed the depth information of neighboring points, including left, right, bottom, and top locations. We defined a neighborhood size parameter, ngrid, which determines the extent of the neighborhood. For example, if ngrid=4, we utilized a 9x9 neighborhood and calculated the weighted depth information based on the distance of the neighbors. Essentially, we employed the distance of the neighborhood as a weight in the summation process. The result showcases the initial depth map without any processing, alongside depth maps with varying neighborhood sizes (1, 2, 3, 4, and 5).
![image](https://github.com/Garrydcruz/Coordinate-Transformation-and-Visualization/assets/36693471/bd24cc58-2421-4290-9623-679dc9eebd75)

To evaluate depth and image matching by sight, you can see both the inverse of the depth map and camera image together in the following image.
![image](https://github.com/Garrydcruz/Coordinate-Transformation-and-Visualization/assets/36693471/012e1f88-b241-4925-a309-d7e1437a7d48)

You can basically launch the main script by following Matlab command.
> main





