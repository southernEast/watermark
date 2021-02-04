%{
    水印图像嵌入视频中
    使用的方法是将每一帧的图像进行分块DCT变换，然后再在每一个DCT小块中嵌入信息
%}

clc;
clear;

% 预置水印图片信息
RANDSEED = 1;
HEIGHT = 750;
WIDTH = 750;
alpha = 80; % 添加水印的强度

% 读取水印图片
mark = imread('2.jpg');
mark = rgb2gray(mark);      % 灰度化
mark = imbinarize(mark);    % 二值化
mark = imresize(mark, [HEIGHT WIDTH]);
% imshow(mark);

% 打开待嵌入水印的视频
video = VideoReader("test.mp4");

newVideo = VideoWriter("ans.avi", 'Uncompressed AVI');    % 非压缩方式
% newVideo = VideoWriter("ans");  % 默认AVI压缩方式
newVideo.FrameRate = video.FrameRate;
open(newVideo);

% 初始化准备信息
pos = 1;    % 定位视频帧
rng(RANDSEED);
k1 = randn(1, 8);
k2 = randn(1, 8);
[rm, cm] = deal(ceil(HEIGHT / 6), ceil(WIDTH / 6));

% 嵌入水印
for m = 0:5
    for n = 0:5     % 外层循环定位当前嵌入水印的位置
        % 读取一个并处理一个视频帧
        disp(['current frame is ', num2str(pos)]);
        p = read(video, pos);
        pos = pos + 1;
        currentFrame = rgb2gray(p);
        fun1 = @(block_struct) dct2(block_struct.data);
        currentFrame = blockproc(currentFrame, [8, 8], fun1);
        
        % 在当前帧嵌入水印的一部分
        for i = 1:rm
            for j = 1:cm   % 内层循环定位当前帧嵌入的位置
                x = (i - 1) * 8;
                y = (j - 1) * 8;
                if mark(m * rm + i, n * cm + j) == 1
                    k = k1;
                else
                    k = k2;
                end
                for a = 1:8
                    currentFrame(x+a,y+9-a)=currentFrame(x+a,y+9-a)+alpha*k(a);
                end
            end
        end
        
        fun2 = @(block_struct) idct2(block_struct.data);
        result = blockproc(currentFrame, [8 8], fun2);
        result = uint8(result);
        writeVideo(newVideo, result);
    end
end

close(newVideo);
