%{
    对结果进行攻击测试
    思路是分别对视频中的每一帧图像进行攻击，测试其鲁棒性
%}

clear;
clc;

video = VideoReader("ans.avi");

newVideo = VideoWriter("attack.avi", 'Uncompressed AVI');
newVideo.FrameRate = video.FrameRate;
open(newVideo);
for i = 1:video.NumFrames
    p = read(video, i);
    
%     whiteNoise = randn(size(p));  % 高斯白噪声攻击
%     p = p + uint8(whiteNoise);

%     H=fspecial('gaussian',[4,4],0.1); % 高斯滤波攻击
%     p=imfilter(p,H);

%     p(1:500, 1:400) = 256;    % 裁剪攻击
    
    p = imrotate(p, 180, 'bilinear', 'crop');   % 旋转攻击

    writeVideo(newVideo, p);
end
close(newVideo);