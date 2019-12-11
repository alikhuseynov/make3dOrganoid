setBatchMode(true);
// input and output directories
input = "/Users/Work/Desktop/make3dOrganoid_rg/input_images/rgb/"; // includes images
output = "/Users/Work/Desktop/make3dOrganoid_rg/output_fiji/"; // make an empty folder
list = getFileList(input);

for (i = 0; i < list.length; i++){
        print(input + list[i]);
        // load image data
        open(input + list[i]);
        mainTitle=getTitle();
        dirOutput=output+File.separator+mainTitle;
        File.makeDirectory(dirOutput);     
        // image processing and filtering
        run("8-bit");
        //run("Set Scale...", "distance=1 known=1.58 unit=micron"); // you can use this if you know the windown size and knonw distance
        run("Morphological Filters", "operation=Dilation element=Square radius=2"); // change morphological filters as necessary for your input images
        selectWindow(list[i]);
        close();
		title=getTitle();
		run("Gamma...", "value=4.04");
		run("Normalize Local Contrast", "block_radius_x=140 block_radius_y=40 standard_deviations=3 center stretch");
		run("Enhance Contrast...", "saturated=4 normalize");
		run("Subtract Background...", "rolling=120 light sliding");
		run("Gamma...", "value=4.38");
        run("Median...", "radius=2");
		run("Gaussian Blur...", "sigma=2");
		run("Auto Threshold", "method=Default ignore_white");
		run("Invert");
		run("Fill Holes");
		// image segmentation
		run("Watershed");
		// image analysis and outlines extraction
		// here play with the size and circularity parameters for your own images to remove debris
       run("Analyze Particles...", "size=8000-Infinity circularity=0.50-1.00 show=[Bare Outlines] exclude clear add");
        selectWindow(getTitle());
        close();
        saveAs("Tiff", output+list[i]+".tif");
		// loop through ROIs and save 
		for(n=0;n<roiManager("Count");n++){ 
   			selectWindow(getTitle());
			roiManager("Select", n);
			// save ROIs and their xy coords
   			saveAs("Selection", dirOutput+File.separator+(n+1)+".roi");
   			saveAs("XY Coordinates", dirOutput+File.separator+(n+1)+".txt");
        }  
}
close();
setBatchMode(false);