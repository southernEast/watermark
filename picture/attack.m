clear;
clc;

p = imread("ans.png");

% 高斯白噪声
p = imnoise(p,'gaussian',0,0.02);

% 高斯滤波 
% H=fspecial('gaussian',[4,4], 0.1);
% p=imfilter(p,H);

% 剪切
% p(1:100, 1:100) = 512;
    
% 旋转　
% p = imrotate(p, 10, 'bilinear', 'crop');

imwrite(p, 'at.png');