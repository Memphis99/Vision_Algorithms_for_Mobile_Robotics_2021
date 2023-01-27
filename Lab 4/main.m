clear all
close all
clc

num_scales = 3; % Scales per octave.
num_octaves = 5; % Number of octaves.
sigma = 1.6;
contrast_threshold = 0.04;
image_file_1 = 'images/img_1.jpg';
image_file_2 = 'images/img_2.jpg';
rescale_factor = 0.2; % Rescaling of the original image for speed.

images = {getImage(image_file_1, rescale_factor), getImage(image_file_2, rescale_factor)};

descriptors = {};
kpt_locations={};

gauss_filter=fspecial('gaussian', [16, 16], 1.5*16);

for img_idx = 1:2 %we analyze both the images to match
    for o = 0:num_octaves-1 %for every octave
        sc_image = imresize(images{img_idx}, 1/(2^o)); %take the image rescaled
        for s = -1:num_scales+1 %create the different gauss filtered images
            k_sigma = 2^(s/num_scales)*sigma; 
            level{s+2} = imgaussfilt(sc_image, k_sigma, 'Padding', 0);
        end
        for i=1:num_scales+2 %create the dogs 
            dog{o+1, i} = abs(level{i+1} - level{i}); %this is MAGNITUDE, row=octave col= dog index
            for x=1:height(dog{o+1, i}) %suppress points with magnitude under threshold
                for y=1:width(dog{o+1, i})
                    if dog{o+1, i}(x, y)<contrast_threshold
                        dog{o+1, i}(x, y)=0;
                    end
                end
            end
        end
        
        %find the keypoints
        for i=2:num_scales+1 %search only in the middle layers of octave
            reg_max=imregionalmax(dog{o+1, i}, 26); %return a matrix whith 1 where max are
            for x=1:height(reg_max)
                for y=1:width(reg_max)
                    if (reg_max(x, y)==1) && (dog{o+1, i}(x, y)~=0)
                        kpt_locations{end+1, 1}=[x, y, num_scales*o + i - 1]; %save the location (DIVIDERE PER o+1??)
                        kpt_locations{end, 2}=img_idx; %save which image is this
                        
                        blur_img=level{i}; %select original blurred img
                        [norms, orient] = imgradient(blur_img); %make the gradient
                        
                        norms=padarray(norms, [8, 8], 0, 'both'); %pad to avoid problems with borders
                        orient=padarray(orient, [8, 8], 0, 'both');
                        
                        norm_patch= norms(kpt_locations{end, 1}(1)+1:kpt_locations{end, 1}(1)+16, kpt_locations{end, 1}(2)+1:kpt_locations{end, 1}(2)+16); %16x16 patch
                        orient_patch= orient(kpt_locations{end, 1}(1)+1:kpt_locations{end, 1}(1)+16, kpt_locations{end, 1}(2)+1:kpt_locations{end, 1}(2)+16);
                        
                        norm_patch=norm_patch.*gauss_filter; %wheight center values more
                        
                        norm_subpatch=mat2cell(norm_patch, [4, 4, 4, 4], [4, 4, 4, 4]); %divide into 16 subpatches of 4x4
                        orient_subpatch=mat2cell(orient_patch, [4, 4, 4, 4], [4, 4, 4, 4]);
                        
                        descriptors{end+1, 1}=[];
                        
                        for h=1:4
                            for k=1:4
                                descriptors{end, 1}=[descriptors{end, 1}, weightedhistc(orient_subpatch{h, k}(:).', norm_subpatch{h, k}(:).', -180:45:180)];
                                descriptors{end, 1}(end)=[]; %delete the last useless element
                            end
                        end
                        d=descriptors{end, 1};
                        n=norm(d);
                        descriptors{end, 1}=descriptors{end, 1}/n; %normalize every descriptor
                        descriptors{end, 2}=img_idx; %save which image is this
                    end
                end
            end
        end
        
    end
end

F1=[];
F2=[];

for i=1:size(descriptors, 1)
    if descriptors{i, 2}==1
        F1=[F1; descriptors{i, 1}];
    else
        F2=[F2; descriptors{i, 1}];
    end
end

kpt1=[];
kpt2=[];

for i=1:size(kpt_locations, 1)
    if kpt_locations{i, 2}==1
        kpt1=[kpt1; kpt_locations{i, 1}(1), kpt_locations{i, 1}(2)];
    else
        kpt2=[kpt2; kpt_locations{i, 1}(1), kpt_locations{i, 1}(2)];
    end
end

indexPairs = matchFeatures(F1,F2, 'MatchThreshold', 100, 'MaxRatio', 0.8, 'Unique', true);

kpt_matched_1 = fliplr(kpt1(indexPairs(:,1), :));
kpt_matched_2 = fliplr(kpt2(indexPairs(:,2), :));

figure; ax = axes;
showMatchedFeatures(images{1}, images{2}, kpt_matched_1, kpt_matched_2, ...
    'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');


    
    % Write code to compute:
    % 1)    image pyramid. Number of images in the pyarmid equals
    %       'num_octaves'.
    % 2)    blurred images for each octave. Each octave contains
    %       'num_scales + 3' blurred images.
    % 3)    'num_scales + 2' difference of Gaussians for each octave.
    % 4)    Compute the keypoints with non-maximum suppression and
    %       discard candidates with the contrast threshold.
    % 5)    Given the blurred images and keypoints, compute the
    %       descriptors. Discard keypoints/descriptors that are too close
    %       to the boundary of the image. Hence, you will most likely
    %       lose some keypoints that you have computed earlier.

% Finally, match the descriptors using the function 'matchFeatures' and
% visualize the matches with the function 'showMatchedFeatures'.
% If you want, you can also implement the matching procedure yourself using
% 'knnsearch'.