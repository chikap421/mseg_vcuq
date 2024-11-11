dir = "/Users/mac/Desktop/Validation Study/Camera/img_16/";
outDir = "/Users/mac/Desktop/Validation Study/Segmentations/";
modelFilename = "/Users/mac/Desktop/New New Latest/Caffemodels/16/img_16.modeldef.h5";
weightsFilename = "/home/ubuntu/img_16.caffemodel.h5";
hostname = "ec2-44-201-69-3.compute-1.amazonaws.com";
list = getFileList(dir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) { // process only .tif files
        open(dir + list[i]);
        selectWindow(list[i]);
        call('de.unifreiburg.unet.SegmentationJob.processHyperStack', 'modelFilename=' + modelFilename + ',Tile shape (px):=388x388,weightsFilename=' + weightsFilename + ',gpuId=GPU 0,useRemoteHost=true,hostname=' + hostname + ',port=22,username=ubuntu,RSAKeyfile=/Users/mac/Desktop/Redlab/Key pairs/chika-key-pair.pem,processFolder=,average=none,keepOriginal=true,outputScores=false,outputSoftmaxScores=false');
        run("8-bit"); // convert image to 8-bit
        saveAs("Tiff", outDir + list[i]);
        close("*"); // close all the windows
    }
}
