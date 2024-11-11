// Set the input and output directories
inputDir = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Grayscale/14/";
segmentationOutputDir = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Segmentation/14/";
normalizedOutputDir = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Normalized/14/";
//mergedOutputDir = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Merged/9/";

// Get a list of files in the input directory
list = getFileList(inputDir);

// Loop through each file
for (i = 0; i < list.length; i++) {
    // Open the file
    open(inputDir + list[i]);
    imgTitle = getTitle();

    // Run the segmentation process
    call('de.unifreiburg.unet.SegmentationJob.processHyperStack', 'modelFilename=/Users/mac/Desktop/Redlab/12/img_12.modeldef.h5,Tile shape (px):=164x164,weightsFilename=/home/ubuntu/img_12.caffemodel.h5,gpuId=all available,useRemoteHost=true,hostname=ec2-44-193-5-21.compute-1.amazonaws.com,port=22,username=ubuntu,RSAKeyfile=/Users/mac/Desktop/Redlab/Key pairs/chika-key-pair.pem,processFolder=,average=none,keepOriginal=true,outputScores=false,outputSoftmaxScores=false');
    
    // Assign window titles to variables
    normalizedWindowTitle = imgTitle + " - rescaled (xy) - normalized";
    segmentedWindowTitle = imgTitle + " - rescaled (xy) - normalized - score (segmentation)";

    // Save the normalized image
    selectWindow(normalizedWindowTitle);
    saveAs("Tiff", normalizedOutputDir + imgTitle);

    // Save the segmented image
    selectWindow(segmentedWindowTitle);
    saveAs("Tiff", segmentationOutputDir + imgTitle);

    // Merge channels
    //run("32-bit");
    //run("Merge Channels...", "c2=" + segmentedWindowTitle + " c4=" + normalizedWindowTitle + " create keep");

    // Save the merged image
    //selectWindow("Composite");
    //saveAs("Tiff", mergedOutputDir + imgTitle);

    // Close all open windows
    close("*");
}
