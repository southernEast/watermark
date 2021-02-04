clc;
clear;

watermark = imread("ans.png");
[row, col] = size(watermark);

% 初始化输出信息矩阵
lineArray = zeros(1, 82 * 8);

% DCT反变换
fun = @(block_struct) idct2(block_struct.data);
watermark = blockproc(watermark, [8, 8], fun);

row = row / 8;
col = col / 8;
pos = 0;

a = 7;
b = 3;
for i = 1:row
    for j = 1:col
        x = (i - 1) * 8;
        y = (j - 1) * 8;
        
        pos = pos + 1;
        
        % 如果标记点1大于标记点2则说明嵌入的信息是1，否则是0
        if watermark(x+a, y+b) > watermark(x+b, y+a)
            lineArray(pos) = '1';
        else
            lineArray(pos) = '0';
        end
        if pos >= length(lineArray)
            break;
        end
    end
    if pos >= length(lineArray)
        break;
    end
end

% 二进制信息转换为字符信息
newArray = char(lineArray);
newArray = reshape(newArray, [82, 8]);
ansArray = native2unicode(bin2dec(newArray));
[w, c] = size(ansArray);
ansArray = reshape(ansArray, [1, w*c]);
disp(ansArray);
