clc;
clear;

% 读取处理文字水印信息图片
content = imread("content.jpg");
content = im2bw(content);   % 二值化
[w, c] = size(content);
lineArray = reshape(content, [1, w * c]);

% 读取待嵌入图片
img = imread("object.jpg");
watermark = img;

fun1 = @(block_struct) dct2(block_struct.data);
watermark = blockproc(watermark, [8, 8], fun1);
[row, col] = size(watermark);
alpha = 75; % 控制嵌入幅度

rng(1);
k1 = randn(1, 8);
k2 = randn(1, 8);

row = row / 8;
col = col / 8;
pos = 0;

% 嵌入信息
for i = 1:row
    for j = 1:col 
        x = (i - 1) * 8;
        y = (j - 1) * 8;
        pos = pos + 1;
        if pos > length(lineArray)
            continue;
        end
        if lineArray(pos) == 1
            k = k1;
        else
            k = k2;
        end
        for a = 1:8
            watermark(x+a,y+9-a) = watermark(x+a,y+9-a) + alpha*k(a);
        end
    end
end


fun2 = @(block_struct) idct2(block_struct.data);
watermark = blockproc(watermark, [8, 8], fun2);
watermark = uint8(watermark);

imwrite(watermark, "ans.png");
disp("嵌入成功！");


