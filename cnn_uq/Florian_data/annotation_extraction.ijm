// Base folder containing different experiment subfolders
baseFolder = "/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Annotations";
subfolders = "LN2_Baseline,LN2_Flipped,LN2_Quartz";
subfolderArray = split(subfolders, ",");

// Loop through each subfolder
for (k = 0; k < lengthOf(subfolderArray); k++) {

    // Current subfolder for Camera and Binary images
    baseCameraFolder = baseFolder + "/Camera/" + subfolderArray[k];
    baseBinaryFolder = baseFolder + "/Binary/" + subfolderArray[k];

    // Get the list of TIFF files in the Camera and Binary folders
    cameraFiles = getFileList(baseCameraFolder);
    binaryFiles = getFileList(baseBinaryFolder);

    // Loop through each pair of Camera and Binary TIFF files
    for (i = 0; i < cameraFiles.length; i++) {

        // Define paths for convenience
        inputCameraPath = baseCameraFolder + "/" + cameraFiles[i];
        inputBinaryPath = baseBinaryFolder + "/" + binaryFiles[i];

        // Open and select the camera image
        open(inputCameraPath);
        cameraTitle = getTitle();

        // Open and select the binary image
        open(inputBinaryPath);
        binaryTitle = getTitle();

        // Threshold and create a selection on the binary image
        selectImage(binaryTitle);
        setAutoThreshold("Default dark no-reset");
        run("Create Selection");
        roiManager("Add");

        // Show ROI on the camera image and save it
        selectImage(cameraTitle);
        roiManager("Select", 0);
        roiManager("Show All");
        run("Save");

        // Close all images
        close("*");
        roiManager("reset"); // Reset the ROI Manager
    }
}
