
inputImagePath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/FLORIAN DATASET 1/New New Latest/Ground Truths/3/img_3_1_new.tif';
outputImagePath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/FLORIAN DATASET 1/New New Latest/Ground Truths/3/img_3_1_new_binarized.tif';

binarizeAndSaveImage(inputImagePath, outputImagePath);
function binarizeAndSaveImage(inputImagePath, outputImagePath)
    img = imread(inputImagePath);
    
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    binaryImg = imbinarize(img);
    
    imwrite(binaryImg, outputImagePath);
end

