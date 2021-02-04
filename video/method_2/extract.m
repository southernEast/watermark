%{
    提取的整体思路是嵌入的逆运算
%}

clear;
clc;

% 预置水印图片信息
RANDSEED = 1;
HEIGHT = 750;
WIDTH = 750;

% 打开待提取的视频
video = VideoReader("ans.avi");
% video = VideoReader("attack.avi");

% 初始化准备信息
watermark = zeros(HEIGHT, WIDTH);
rng(RANDSEED);
k1 = randn(1, 8);
k2 = randn(1, 8);
pos = 1;
[rm, cm] = deal(ceil(HEIGHT / 6), ceil(WIDTH / 6));

% 提取水印
for m = 0:5
    for n = 0:5     % 外层循环定位当前嵌入水印的位置
        % 读取一个视频帧
        disp(['Processing part ', num2str(pos), ' ...']);
        imshow(watermark);
        inmark = read(video, pos);
        inmark = rgb2gray(inmark);
        pos = pos + 1;
        fun = @(block_struct) idct2(block_struct.data);
        inmark = blockproc(inmark, [8 8], fun);
        
        % 从当前视频帧中提取
        for i = 1:rm
            for j = 1:cm    % 内层循环定位当前帧嵌入的位置
                x=(i-1)*8;y=(j-1)*8;
                p = zeros(1, 8);
                for a = 1:8
                    p(a) = inmark(x+a, y+9-a);
                end
                if corr2(p, k1) > corr2(p, k2)  % 判断相关系数
                    watermark(m * rm + i, n * cm + j)= 1;
                else
                    watermark(m * rm + i, n * cm + j)= 0;
                end
            end
        end
    end
end

imshow(watermark);
