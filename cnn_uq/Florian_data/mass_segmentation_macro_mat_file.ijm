// Automated Mass Segmentation Using UNet Model in Fiji/ImageJ

input_directory = "/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Camera Images/"
composite_directory = "/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Segmentation results/Mass Segmenting Results/Composite/"
segmentation_directory = "/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Segmentation results/Mass Segmenting Results/Segmentation/"
list = getFileList(input_directory);
for(i=0; i<lengthOf(list);i++){
filename = list[i];
print(filename);
shorter_name = substring(filename, 0, lengthOf(filename)-4);	
Raw_img = "" + shorter_name;
print(Raw_img);
run("MATLAB .mat file Loader", "select="+input_directory+Raw_img+".mat");

selectWindow(Raw_img);

call('de.unifreiburg.unet.SegmentationJob.processHyperStack', 'modelFilename=/Users/mac/Desktop/Redlab/caffemodels/10bubbles_modeldef.caffemodel.h5,Tile shape (px):=164x164,weightsFilename=10bubbles_model_weights.caffemodel.h5,gpuId=GPU 0,useRemoteHost=true,hostname=ec2-34-237-51-65.compute-1.amazonaws.com,port=22,username=ubuntu,RSAKeyfile=/Users/mac/Desktop/Redlab/Key pairs/chika-key-pair.pem,processFolder=,average=none,keepOriginal=true,outputScores=false,outputSoftmaxScores=false');

selectWindow(Raw_img+" - composite - 32-Bit - rescaled (xy) - normalized - score (segmentation)");
run("32-bit");
selectWindow(Raw_img+" - composite - 32-Bit - rescaled (xy) - normalized");
run("RGB Color");
run("32-bit");
selectWindow(Raw_img+" - composite - 32-Bit - rescaled (xy) - normalized - score (segmentation)");
run("Merge Channels...", "c2=[" + Raw_img + " - composite - 32-Bit - rescaled (xy) - normalized - score (segmentation)] c4=[" + Raw_img+ " - composite - 32-Bit - rescaled (xy) - normalized (RGB)] create keep");
saveAs("Jpeg", composite_directory+ Raw_img+".jpg");
selectWindow(Raw_img+" - composite - 32-Bit - rescaled (xy) - normalized - score (segmentation)");
saveAs("jpgf", segmentation_directory+Raw_img+".jpg");
selectWindow("Composite");
close("*");
}
