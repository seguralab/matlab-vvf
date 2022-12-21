% This function takes in a 2-D image, percentage of desired
% center-cropping, and scaling threshold, and outputs the void area fraction.


function [final_areas, void_fract] = processPores(refimg, widthCrop, heightCrop, ...
                                                  thresh_scale, plot_on)

    % Import image as NxMx3 array, where 3 refers to the RGB intensities of
    % each pixel
    [RawImage] = imread(refimg);

    % Center-crop image according to widthCrop and heightCrop
    img_width = size(RawImage,2);
    wCropEdges = floor((img_width - (img_width * (widthCrop/100))) / 2);
    x_minPxl = 1 + wCropEdges;
    x_maxPxl = img_width - wCropEdges;
    img_height = size(RawImage,1);
    hCropEdges = floor((img_height - (img_height * (heightCrop/100))) / 2);
    y_minPxl = 1 + hCropEdges;
    y_maxPxl = img_height - hCropEdges;
    [RawImage] = RawImage(y_minPxl:y_maxPxl, x_minPxl:x_maxPxl, :);

    % Begin image analysis
    % Convert to grayscale
    img = rgb2gray(RawImage); 
    % Saturate the bottom 1% and the top 1% of all pixel values
    img2 = imadjust(img);
    % Apply morphology operations (dilation and erosion using 3x3 disk
    % structuring element) to remove noise
    img_dil = imdilate(img2,strel('disk',3));
    img_er = imerode(img_dil,strel('disk',3));
    img_dil2 = imdilate(img_er,strel('disk',3));
    img_er2 = imerode(img_dil2,strel('disk',3));

    % Let's see it
    if strcmp(plot_on, 'on') || strcmp(plot_on, 'yes') || sum(plot_on) == 1
        figure;
        imshow(img_er2);
    end

    % Compute global threshold
    [thr,~] = graythresh(img_er2);
    % Binarize image, where '1' refers to BLACK pixel, i.e. void space
    img_bw = imbinarize(img_er2, thr/thresh_scale);

    if strcmp(plot_on, 'on') || strcmp(plot_on, 'yes') || sum(plot_on) == 1
        figure;
        imshow(img_bw);
    end
    % Determine void space (pore) fraction
    % Count up total number of WHITE pixels
    img_whitePxl = sum(img_bw(:));
    % Count up total number of ALL pixels
    img_totPxl = numel(img_bw);
    % Calculate and output pore fraction (i.e. proportion of BLACK pixels)
    void_fract = 1 - (img_whitePxl/img_totPxl);

    % Output array of selected areas
    final_areas = select_areas;
end