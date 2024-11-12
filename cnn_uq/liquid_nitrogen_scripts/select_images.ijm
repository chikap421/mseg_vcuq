input_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Grayscale/";
output_folder = "/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Annotations/Grayscale/Selected/";

for (i = 2; i <= 21; i++) {
    if (i == 19 || i == 20) {
        continue; // skip i values 19 and 20
    }

    for (j = 0; j < 3; j++) {
        if (j == 0) {
            k = 1;
        } else {
            k = j * 700 + 1;
        }
        
        file_name = "img_" + i + "_" + k + ".tif";
        input_path = input_folder + file_name;
        output_path = output_folder + file_name;

        if (File.exists(input_path)) {
            open(input_path);
            saveAs("Tiff", output_path);
            close();
        }
    }
}
