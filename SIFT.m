clear vars
close all
clc
clear

Iref = imread('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized_Shrunk\resized_Reference.jpg');
[rows, columns, numberOfColorChannels] = size(Iref);
%Icompare = imread('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized_Shrunk\resized_Sign11.jpg');
Iref = rgb2gray(Iref);

filelist = dir('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized');
len = length(filelist) -2;
Ia = single(Iref);
solutionKey = zeros(rows,columns);


%%
% different things to effect Icompare
averageFilter = [1 1 1; 1 1 1; 1 1 1];

%Icompare = conv2(Iref,averageFilter,'same'); % average filtertrials
Icompare = Iref;
minv = double(min(Icompare(:)));
maxv = double(max(Icompare(:)));
figure
imshow(Icompare,[minv,maxv])



%%
Ib = single(Icompare);

[fa,da] = vl_sift(Ia) ;
[fb,db] = vl_sift(Ib) ;

[matches, scores] = vl_ubcmatch(da, db, 6) ;
[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

figure ; clf ;
imagesc(cat(2, Iref, Icompare)) ;
axis image off ;
figure ; clf ;
imagesc(cat(2, Iref, Icompare)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Iref,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

%%
% create locations of solution
lengthOfSolution = length(xa);
% for i= 1:lengthOfSolution
%     
% end

%%

%error radius may be affected by image size
%error assumes both images are the same
error_radius = sqrt((xa-(xb-columns)).^2 + (ya-yb).^2);
mean_Error   = median(error_radius);
median_Error = mean(error_radius);

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'r') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(Iref,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;
pause(.01)

