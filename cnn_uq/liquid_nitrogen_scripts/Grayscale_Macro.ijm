// Prompt user to select input and output directories
inputDir = getDirectory("Choose input directory");
outputDir = getDirectory("Choose output directory");

// Get list of TIFF files in input directory
fileList = getFileList(inputDir);

// Loop over each file in the list
for (i=0; i<fileList.length; i++) {
    // Check if the current file is a TIFF file
    if (endsWith(fileList[i], ".tif") || endsWith(fileList[i], ".tif/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Grayscale/3/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Colored/3")) {
        // Open current file/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Chika/Thresholding/16-18/Colored
        open(inputDir + "/" + fileList[i]);

        // Convert to 8-bit grayscale
        run("32-bit");

        // Save as TIFF to output directory
        saveAs("TIFF", outputDir + "/" + fileList[i]);
        
        // Close current file
        close();
    }
}
