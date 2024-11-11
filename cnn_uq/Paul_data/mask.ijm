// Define the input and output directories
inputDir = "/Users/chikamaduabuchi/Documents/paul/case2/annotations";
outputDir = "/Users/chikamaduabuchi/Documents/paul/case2/groundtruth";

// Get a list of all files in the input directory
list = getFileList(inputDir);

// Loop through each file in the list
for (i = 0; i < list.length; i++) {
    // Construct the file path
    filePath = inputDir + "/" + list[i];
    // Check if the file is an image file, e.g., ends with ".tif"
    if (endsWith(list[i], ".tif")) {
        // Open the image
        open(filePath);
        
        // The title of the currently open image
        title = getTitle();
        
        // Run "Create Mask"
        run("Create Mask");
        
        // Save the mask to the output directory
        // Construct the output file path
        outputFilePath = outputDir + "/" + list[i];
        saveAs("Tiff", outputFilePath);
        
        // Close the processed image and its mask
        close('*');
    }
}
print("Processed all images.");
