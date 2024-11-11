dir = "/Users/mac/Desktop/Validation Study/Camera/";
list = getFileList(dir);

setOption("ScaleConversions", true);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) { // process only .tif files
        open(dir + list[i]);
        selectWindow(list[i]);
        run("8-bit");
        run("Save");
        close(); // close the image window
    }
}
