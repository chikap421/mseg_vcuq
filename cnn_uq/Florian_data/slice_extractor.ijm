// Define the input and output directories
inputFolder = "/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF";
outputBaseFolder = "/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Annotations/Camera";

// Get list of all TIFF files in the input folder
list = getFileList(inputFolder);

// Loop through each TIFF file in the input folder
for (i = 0; i < list.length; i++) {
    // Check if the file is a TIFF
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        inputPath = inputFolder + "/" + list[i];

        // Extract the name of the TIFF file without the extension for folder naming
        fileName = list[i];
        lastDot = indexOf(fileName, ".");
        if (lastDot >= 0) {
            fileName = substring(fileName, 0, lastDot);
        }

        // Create a specific output folder for this TIFF file
        outputFolder = outputBaseFolder + "/" + fileName;
        File.makeDirectory(outputFolder);

        // Open the TIFF file
        open(inputPath);

        // Determine the slice sequence based on the file name
        if (fileName == "FC72") {
            startSlice = 1;
            endSlice = 3000;
            increment = 599;
        } else {
            startSlice = 1;
            endSlice = 6000;
            increment = 1199;
        }

        // Loop through slices using the determined sequence
        for (slice = startSlice; slice <= endSlice; slice += increment) {
            // Go to the specific slice in the original composite image
            setSlice(slice);

            // Duplicate the slice and give it a title
            run("Duplicate...", "title=" + slice);

            // Save the duplicated slice as a new TIFF file in the output folder
            saveAs("Tiff", outputFolder + "/" + slice + ".tif");

            // Close the duplicated slice
            close();
        }

        // Close the original TIFF file
        close();
    }
}
