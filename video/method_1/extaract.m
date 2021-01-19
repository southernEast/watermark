%{
    提取的整体思路是嵌入的逆运算
%}

clc;
clear;

% 水印预置信息
RANDSEED = 7;   % 随机数种子
SCALE = 0.7;    % 缩放比例
UNITNUM = 300;  % 单位颜色通道嵌入数量
SIZE = 748;     % 水印的尺寸
[height, width] = deal(uint64(SIZE * SCALE));  

% 获取水印视频
video = VideoReader("ans.avi");
p = read(video, 1);
[w, c, d] = size(p);
% video = VideoReader("attack.avi");

% 初始化随机数序列
rng(RANDSEED);
X = randperm(w);
Y = randperm(c);
D = randperm(d);

% 初始化待提取的水印图片
photo = zeros(1, height * width);

% 初始化坐标信息
watermarkPos = 1;
dimPos = 1;
xPos = 1;
yPos = 1;
i = 1;
p = read(video, i);

% 水印提取
while true
    x = X(xPos);
    y = Y(yPos);
    dim = D(dimPos);
    xPos = xPos + 1;
    yPos = yPos + 1;
    if xPos > w
        xPos = 1;
    end
    if yPos > c
        yPos = 1;
    end
    
    photo(watermarkPos) = p(x, y, dim);
    watermarkPos = watermarkPos + 1;
    if watermarkPos > length(photo) % 水印图像填充完成，成功退出
        disp("success!");
        break;
    end
    if mod(watermarkPos, UNITNUM) == 0 
        dimPos = dimPos + 1;
        if dimPos > d
            dimPos = 1;
            i = i + 1;
            if i > video.NumFrames % 遍历完所有的图像帧仍未提取全水印信息，报错
                disp("error!");
                break;
            end
            p = read(video, i);
        end
    end
end

photo = reshape(photo, height, width);
imshow(photo);