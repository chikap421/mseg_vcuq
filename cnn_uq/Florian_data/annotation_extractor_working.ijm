input_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Camera/Colored/16/";
thresholding_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Threshold/Grayscale/16/";
roisets_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Roisets/16/";
annotations_colored_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Colored/16/";
annotations_grayscale_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Grayscale/16/";

list = getFileList(input_folder);
processed_count = 0; // Counter for processed images

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".jpg")) {
        base_name = list[i].substring(0, lastIndexOf(list[i], "."));
        print("Processing: " + list[i]); // Added print statement to show the image being processed
        open(input_folder + list[i]);
        open(thresholding_folder + base_name + ".tif");
        selectWindow(list[i]);
        selectWindow(base_name + ".tif");
        setAutoThreshold("Default dark no-reset");
        setThreshold(154, 224);
        run("Create Selection");
        roiManager("Add");
        roiManager("Select", 0);
        roiManager("Rename", base_name);
        roiManager("Save", roisets_folder + base_name + ".roi");
        selectWindow(list[i]);
        roiManager("Show All");
        saveAs("Tiff", annotations_colored_folder + base_name + ".tif");
        run("32-bit");
        saveAs("Tiff", annotations_grayscale_folder + base_name + ".tif");
        
        // Close the images
        close("*");
        
        processed_count++; // Increment the processed images counter
    }
    roiManager("reset"); // Reset the ROI Manager
}

print("Total number of images processed: " + processed_count);
