clear vars
close all
clc
clear

Iref = imread('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized\resized_Reference.jpg');
Icompare = imread('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized\resized_Sign2.jpg');

filelist = dir('C:\Users\Lawrence\Documents\MATLAB\imageProcessing\Resized');
len = length(filelist) -2;
image_mem = zeros(1, len);
Ia = single(rgb2gray(Iref));

for i=1 : len -1
    filename = filelist(i+3);

    if ~strcmp(filename.name , '.') && ~strcmp(filename.name , '..')
        image = imread(strcat(filename.folder,'\',filename.name));
        filename.name
        Ib = single(rgb2gray(image));

        [fa,da] = vl_sift(Ia) ;
        [fb,db] = vl_sift(Ib) ;

        [matches, scores] = vl_ubcmatch(da, db, 6) ;
        [drop, perm] = sort(scores, 'descend') ;
        matches = matches(:, perm) ;
        scores  = scores(perm) ;

        figure ; clf ;
        imagesc(cat(2, Iref, image)) ;
        axis image off ;
        figure ; clf ;
        imagesc(cat(2, Iref, image)) ;

        xa = fa(1,matches(1,:)) ;
        xb = fb(1,matches(2,:)) + size(Iref,2) ;
        ya = fa(2,matches(1,:)) ;
        yb = fb(2,matches(2,:)) ;

        hold on ;
        h = line([xa ; xb], [ya ; yb]) ;
        set(h,'linewidth', 1, 'color', 'r') ;

        vl_plotframe(fa(:,matches(1,:))) ;
        fb(1,:) = fb(1,:) + size(Iref,2) ;
        vl_plotframe(fb(:,matches(2,:))) ;
        axis image off ;
        pause(.01)
    end
end

