%{
    水印图像嵌入视频中
    使用的方法是分别在每一帧图像的RGB颜色通道中嵌入水印图像的像素点
%}

clc;
clear;

% 水印预置信息
RANDSEED = 7;   % 随机数种子
SCALE = 0.7;    % 缩放比例
UNITNUM = 300;  % 单位颜色通道嵌入数量

% 水印图预处理
watermark = imread("2.jpg");
watermark = rgb2gray(watermark);    % 灰度化
watermark = imresize(watermark, SCALE);
watermark = imbinarize(watermark);  % 二值化
[height, width] = size(watermark);  % 获取水印图像的尺寸
% 水印图像矩阵转换为一维矩阵
watermark = reshape(watermark, 1, height * width);  

% 待嵌入视频
video = VideoReader("double.avi");
p = read(video, 1);
[w, c, d] = size(p);   % 获取视频中一帧图像的尺寸
newVideo = VideoWriter("ans.avi", 'Uncompressed AVI'); % 无压缩的形式保存
% newVideo = VideoWriter("ans");
newVideo.FrameRate = video.FrameRate;
open(newVideo);

% 初始化随机数序列
rng(RANDSEED);
X = randperm(w);
Y = randperm(c);
D = randperm(d);

% 初始化坐标信息
watermarkPos = 1;   % 定位水印图像的像素点
dimPos = 1; 
xPos = 1;
yPos = 1;
i = 1;  % 定位视频帧
p = read(video, i); % 取视频帧

% 用于展示成功嵌入的图片
photo = zeros(1, height * width);

% 水印嵌入
while true
    % 取视频帧待嵌入的坐标点
    x = X(xPos);
    y = Y(yPos);
    dim = D(dimPos);
    % 准备下一个随机坐标点
    xPos = xPos + 1;
    yPos = yPos + 1;
    if xPos > w
        xPos = 1;
    end
    if yPos > c
        yPos = 1;
    end
    
    % 嵌入水印图的像素值
    p(x, y, dim) = watermark(watermarkPos);
    photo(watermarkPos) = watermark(watermarkPos);
    
    watermarkPos = watermarkPos + 1;  % 待嵌入的像素位置递增
    if watermarkPos > length(watermark)  % 水印图像遍历结束
        disp("success!");
        break;
    end
    flag = 0;   % 标记处理的最后一帧是否有完整插入
    if mod(watermarkPos, UNITNUM) == 0   % 达到一个单位颜色通道的嵌入数量
        dimPos = dimPos + 1;    % 转换到下一个颜色通道
        if dimPos > d           % 当前视频帧的三个通道嵌入结束
            dimPos = 1;
            i = i + 1;          % 准备提取下一个视频帧
            if i > video.NumFrames % 待嵌入视频的容量已满，报错
                disp('error');
                return;
            end 
            writeVideo(newVideo, p); % 嵌入水印的视频帧插入
            flag = 1;
            p = read(video, i); % 读取下一个视频帧
        end
    end
end

if flag == 0    % 插入最后处理的一帧
    writeVideo(newVideo, p);
end
close(newVideo);

% 展示嵌入的图片
photo = reshape(photo, height, width);
imshow(photo);