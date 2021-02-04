clc;
clear;

% 水印信息转换为二进制
content = "东南大学网络空间安全学院2020年网络信息安全与信息隐藏课程";    
native = unicode2native(content);
binArray = dec2bin(native);
[w, c] = size(binArray);
lineArray = reshape(binArray, [1, w * c]);  % 转换矩阵维度

% 读取载体图片
img = imread("object.jpg");
watermark = img;

fun1 = @(block_struct) dct2(block_struct.data); % DCT变换
watermark = blockproc(watermark, [8, 8], fun1);
[row, col] = size(watermark);

row = row / 8;
col = col / 8;
pos = 0;

% 选取每一个DCT块的嵌入标记点位置
a = 7;
b = 3;

% 控制两个点之间的差距大小
alpha = 200; 

% 嵌入信息
for i = 1:row
    for j = 1:col
        x = (i - 1) * 8;
        y = (j - 1) * 8;
        pos = pos + 1;
        if pos > length(lineArray)
            continue;
        end
        
        % 如果待嵌入信息是1则将两个标记点的信息设置为点1大于点2；如果是0则反之
        if lineArray(pos) == '1'
            if watermark(x+a, y+b) < watermark(x+b, y+a)
                temp = watermark(x+a, y+b);
                watermark(x+a, y+b) = watermark(x+b, y+a);
                watermark(x+b, y+a) = temp;
            end
            watermark(x+b, y+a) = watermark(x+b, y+a) - alpha;
        elseif lineArray(pos) == '0'
            if watermark(x+a, y+b) > watermark(x+b, y+a)
                temp = watermark(x+a, y+b);
                watermark(x+a, y+b) = watermark(x+b, y+a);
                watermark(x+b, y+a) = temp;
            end
            watermark(x+a, y+b) = watermark(x+a, y+b) - alpha;
        end
    end
end


fun2 = @(block_struct) idct2(block_struct.data); % DCT反变换
watermark = blockproc(watermark, [8, 8], fun2);
watermark = uint8(watermark);

imwrite(watermark, "ans.png");
disp("嵌入成功！");


