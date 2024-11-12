inputDir = "/Users/chikamaduabuchi/Documents/paul/case2/processed";
outputDir = "/Users/chikamaduabuchi/Documents/paul/case2/segmentation";
list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) {
        // Open the image
        open(inputDir + "/" + list[i]);
        // The title of the currently opened image
        imageTitle = getTitle();
        
        // Segment the image using UNet
        call('de.unifreiburg.unet.SegmentationJob.processHyperStack', 'modelFilename=/Users/chikamaduabuchi/Desktop/cell caffemodels/base.modeldef.h5,Tile shape (px):=500x500,weightsFilename=/home/ubuntu/paul_case2_300.caffemodel.h5,gpuId=GPU 0,useRemoteHost=true,hostname=ec2-18-207-250-15.compute-1.amazonaws.com,port=22,username=ubuntu,RSAKeyfile=/Users/chikamaduabuchi/Desktop/Key pairs/chika-key-pair.pem,processFolder=,average=none,keepOriginal=true,outputScores=false,outputSoftmaxScores=false');
        
        // Ensure the image is in 8-bit format
        run("8-bit");
        // Save the segmented image
        saveAs("Tiff", outputDir + "/" + list[i]);
        // Close all open images
        run("Close All");
    }
}
print("Segmentation complete for all images.");
