clc;
clear;

watermark = imread("ans.png");
% watermark = imread("at.png");
[row, col] = size(watermark);

% 初始化输出嵌入信息矩阵，水印图像为35*133
lineArray = zeros(1, 35 * 133);

% DCT反变换
fun = @(block_struct) idct2(block_struct.data);
watermark = blockproc(watermark, [8, 8], fun);

rng(1);
k1 = randn(1, 8);
k2 = randn(1, 8);

row = row / 8;
col = col / 8;
pos = 1;

% 提取信息
for i = 1:row
    for j = 1:col 
        x = (i - 1) * 8;
        y = (j - 1) * 8;
        
        p = zeros(1, 8);
        for a = 1:8
            p(a)=watermark(x+a,y+9-a);       
        end
         
        if corr2(p, k1) > corr2(p, k2)  % 判断相关系数
            lineArray(pos)= 1;
        else
            lineArray(pos)= 0;
        end
        pos = pos + 1;
        if pos > length(lineArray)
            break;
        end
    end
    if pos > length(lineArray)
        break;
    end
end

% 转换水印信息图像的形状
ansArray = reshape(lineArray, [35, 133]);
imshow(ansArray);
imwrite(ansArray, "out.png");