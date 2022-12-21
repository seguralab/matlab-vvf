% This code computes the average void area fraction among a z-stack of 2-D
% images in a folder inputted as folder_path. It was initially written by
% Don Griffin in 2015 [DOI: 10.1038/NMAT4294], modified by Elias Sideris
% 10/16/2015 [DOI: 10.1021/acsbiomaterials.6b00444], then adapted by
% Lindsay Riley 2018 - 2022.

close all;
clearvars;

folder_path  = 'C:\Users\slice_images';
plot_on      = 'on';
plot_slice   = 1;
thresh_scale = 1;  % divide 'Otsu's method' binarize threshold by this value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder_files = {dir(folder_path).name};
% remove non-files
remove = false(length(folder_files), 1);
for i = 1 : length(folder_files)
    if folder_files{i}(1) == '.' || folder_files{i}(1) == '~'
        remove(i) = true;
    end
end
folder_files(remove) = [];
num_items = numel(folder_files);

avg_void_vec = zeros(num_items, 1);
for i = 1 : num_items
    % Import an image for analysis
    refimg = [folder_path, '/',folder_files{i}];
    % Choose the percentage of the width and height to center-crop all images
    widthCrop = 100;
    heightCrop = 100;

    if i == plot_slice
        [final_areas, void_fract] = processPores(refimg, widthCrop, heightCrop, ...
                                                 thresh_scale, 'on');
    else
        [final_areas, void_fract] = processPores(refimg, widthCrop, heightCrop, ...
                                                 thresh_scale, plot_on);
    end
    avg_void_vec(i)  = void_fract;
end
average_void_fraction = mean(avg_void_vec);

