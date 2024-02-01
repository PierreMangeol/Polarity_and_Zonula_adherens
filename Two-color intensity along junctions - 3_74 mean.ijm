/*************************************************************************************************/

macro "Open Image Action Tool - Cee8 F14b9  C000 R03c9  Cee8 D13D23  C000 D03D02D01D11D21D31D32 P1b35f5cb0 Cee8 DbaDc9Dc8Dc7Dc6"
{

dir = getDirectory("input folder");
files = getFileList(dir);

index = 0;
for (i=0; i<floor(files.length); i++) {
	if(indexOf(files[i],"Series")!=-1)
	index = index + 1;

	else if(indexOf(files[i],"Image")!=-1)

	index = index + 1;}

files_with_images = newArray(index);

index = 0;
for (i=0; i<floor(files.length); i++) {
	if(indexOf(files[i],"Series")!=-1) 
	{files_with_images[index] = files[i];
	index = index + 1;}

	else if(indexOf(files[i],"Image")!=-1)
	{files_with_images[index] = files[i];
	index = index + 1;}}

Array.sort(files_with_images);

order_color = getBoolean("Was A568 first acquired?")

for (i=0; i<floor(files_with_images.length/2); i++) {
	name = "";
	if(indexOf(files_with_images[i*2],"Series")!=-1)     
	{open(dir + "/" + files_with_images[i*2]);
	name = File.name;//getInfo("image.filename");
	rename("image1");
	open(dir + "/" + files_with_images[i*2+1]);
	rename("image2");

	if(order_color)
	run("Merge Channels...", "c1=image1 c2=image2 create");
	else
	run("Merge Channels...", "c1=image2 c2=image1 create");
	
	selectWindow("Composite");
	rename(name);
	run("Z Project...", "projection=[Max Intensity]");
		}
	if(indexOf(files_with_images[i*2],"Image")!=-1)    
	{open(dir + "/" + files_with_images[i*2]);
	name = File.name;//getInfo("image.filename");
	rename("image1");
	open(dir + "/" + files_with_images[i*2+1]);
	rename("image2");

	if(order_color)
	run("Merge Channels...", "c1=image1 c2=image2 create");
	else
	run("Merge Channels...", "c1=image2 c2=image1 create");
	selectWindow("Composite");
	rename(name);
	}
}
run("Tile");

}


/*************************************************************************************************/



macro "Make a segmented line [F3] Action Tool - C000 P3e7a34b4f70" {
setTool("polyline");
}


/*************************************************************************************************/



macro "Spline [F4] Action Tool - C000 P3e4d5c5b4a393837465565758595a6b6c7d8e80" {
run("Fit Spline");
}

/*************************************************************************************************/



macro "Make a segmented line Action Tool [F3]" {
setTool("polyline");
}


/*************************************************************************************************/



macro "Spline Action Tool [F4]" {
run("Fit Spline");
}


/*************************************************************************************************/


macro "Swap channels to get junction on channel 2 Action Tool - Cc00 T0709S T7709w Te709p T0f09c T3f09h T7f09a Tcf09n Thf09n" {
run("Arrange Channels...", "new=21");
}

/*************************************************************************************************/
macro "Get max slice on protein of interest Action Tool -  C000 T0709M T7709a Tc709x T0f09s T4f09l T6f09i T8f09c Tcf09e" {

getDimensions(width1, height1, channels, slices, frames);

n=0;
maxi=0;
for (k=1; k<slices+1; k++)
	{Stack.setSlice(k);

getStatistics(area,mean);
	if(mean>maxi)
	{maxi = mean;
	n = k;
	}
	}
Stack.setSlice(n);}

/*************************************************************************************************/


macro "PLANAR: Fit junction on middle junction channel Action Tool - C0c0 T0709F T5709i T8709t Cc00 Tb709P Th709l C0c0 T0f09j T2f09u T7f09n Tcf09c Thf09t" {
	
	Stack.setChannel(2);
	
	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	
	run("Interpolate", "interval=" + 1 + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel

	Roi.getCoordinates(x,y);

	lengthofprofile = 201;
	profile=newArray(lengthofprofile); 
	new_X=newArray(lengthOf(x)-1); 
	new_Y=newArray(lengthOf(x)-1); 
	
for (k=0; k<lengthOf(x)-1; k++)
	{
			norm = sqrt((x[k]-x[k+1])*(x[k]-x[k+1])+(y[k]-y[k+1])*(y[k]-y[k+1]));
			unit_perp_x = (-(y[k+1]-y[k])/norm);
			unit_perp_y = ((x[k+1]-x[k])/norm);

					for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));

						
			profile[l] = (1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1);
		}
		// finds the maximum along the junction
		maxLoc = Array.findMaxima(profile, 1);
        lmax = maxLoc[0];

        new_X[k] = x[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_x;
        new_Y[k] = y[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_y;}

makeSelection("polyline", new_X, new_Y);
run("Fit Spline");}


/*************************************************************************************************/



macro "PLANAR: Fit junction to Minimum channel Action Tool - C0c0 T0709F T5709i T8709t Cc00 Tb709P Th709l C0c0 T0f09M T9f09i Tcf09n" {
	
	Stack.setChannel(2);
	
	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	
	run("Interpolate", "interval=" + 1 + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel

	Roi.getCoordinates(x,y);

	lengthofprofile = 61;
	profile=newArray(lengthofprofile); 
	new_X=newArray(lengthOf(x)-1); 
	new_Y=newArray(lengthOf(x)-1); 
	
for (k=0; k<lengthOf(x)-1; k++)
	{
			norm = sqrt((x[k]-x[k+1])*(x[k]-x[k+1])+(y[k]-y[k+1])*(y[k]-y[k+1]));
			unit_perp_x = (-(y[k+1]-y[k])/norm);
			unit_perp_y = ((x[k+1]-x[k])/norm);

					for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));

						
			profile[l] = -((1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1));
		}
		// finds the maximum along the junction
		maxLoc = Array.findMaxima(profile, 1);
        lmax = maxLoc[0];

        new_X[k] = x[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_x;
        new_Y[k] = y[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_y;}

makeSelection("polyline", new_X, new_Y);
run("Fit Spline");}


/*************************************************************************************************/



macro "PLANAR: Get intensity along junction (channel 2 reference protein)  [F7] Action Tool -  Cc00 T0709T T5709w Tb709o T0f09I T2f09n T8f09t C0c0 Tbf09P Thf09l" {

/***
 * Save two files for two colors with (intensity vs position perp to TJ) vs position along TJ
 * Currently the distance between positions is 10nm along the tight junction and perpendicular to it
 */

image_folder_name = getDirectory("Please select the folder containing your image");

imagenumber = getTitle();


if (File.exists(image_folder_name + File.separator + "Intensity_measurement")!=1) {
	File.makeDirectory(image_folder_name + File.separator + "Intensity_measurement");
}

	i = 1;
	j = 1;
  while (File.exists(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_reference_line_" + i +".txt")==1) {	
   	i = i + 1;
	j = i;  }
	
	
segment_path = image_folder_name + File.separator + "Intensity_measurement" + File.separator +  imagenumber + "_reference_line_" + j + ".txt";
 // name file for reference line

	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	run("Interpolate", "interval=" + toString(interval) + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel
	Roi.getCoordinates(x,y);


File.saveString(toString(pw), image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_pixel_size_" + j + ".txt");
 // save file for pixel size
 
File.saveString("", segment_path); 

   for (k=0; k<lengthOf(x)-1; k++)
	{File.append('\r'+toString(x[k])+"\t"+toString(y[k])+'\r', segment_path);
 // save file for reference line

  	}
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_1_" + j + ".txt") // create file for intensity measurement on color 1
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_2_" + j + ".txt") // create file for intensity measurement on color 2


////// Local segments perpendicular to the junction are used to obtain the profile perpendicular to the junction

for (i=1; i<3; i++)
{	Stack.setChannel(i);
	f = File.open(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_" + i + "_" + j + ".txt");


   for (k=0; k<lengthOf(x)-2; k++)
	{		if (k<3) {
			norm = sqrt((x[0]-x[6])*(x[0]-x[6])+(y[0]-y[6])*(y[0]-y[6]));
			unit_perp_x = (-(y[6]-y[0])/norm);
			unit_perp_y = ((x[6]-x[0])/norm);
			}
			else if (k>lengthOf(x)-4) {
			norm = sqrt((x[lengthOf(x)-7]-x[lengthOf(x)-1])*(x[lengthOf(x)-7]-x[lengthOf(x)-1])+(y[lengthOf(x)-7]-y[lengthOf(x)-1])*(y[lengthOf(x)-7]-y[lengthOf(x)-1]));
			unit_perp_x = (-(y[lengthOf(x)-1]-y[lengthOf(x)-7])/norm);
			unit_perp_y = ((x[lengthOf(x)-1]-x[lengthOf(x)-7])/norm);
			}
			else {
			norm = sqrt((x[k-3]-x[k+3])*(x[k-3]-x[k+3])+(y[k-3]-y[k+3])*(y[k-3]-y[k+3]));
			unit_perp_x = (-(y[k+3]-y[k-3])/norm);
			unit_perp_y = ((x[k+3]-x[k-3])/norm);
			}
						
		//From the reference line, creates a segment (profile line) whose middle is a given point of the reference line, its length is +-2 microns and locally perpendicular to the reference line
		lengthofprofile = 401;
		profile=newArray(lengthofprofile); 

		for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));
						
			profile[l] = (1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1);
		}

		string="";
		for (l=0; l<lengthOf(profile); l++) {
			if (l==0) {
				string=string+profile[l];
			}
			else {
				string=string+"\t"+profile[l];
			}
			
		}
		print(f, string);
  	}
	File.close(f);

}
showMessageWithCancel("Finished");
}

/*************************************************************************************************/




macro "PLANAR: Get intensity along junction (channel 2 reference protein)  Action Tool [F7]" {

/***
 * Save two files for two colors with (intensity vs position perp to TJ) vs position along TJ
 * Currently the distance between positions is 10nm along the tight junction and perpendicular to it
 */

image_folder_name = getDirectory("Please select the folder containing your image");

imagenumber = getTitle();


if (File.exists(image_folder_name + File.separator + "Intensity_measurement")!=1) {
	File.makeDirectory(image_folder_name + File.separator + "Intensity_measurement");
}

	i = 1;
	j = 1;
  while (File.exists(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_reference_line_" + i +".txt")==1) {	
   	i = i + 1;
	j = i;  }
	
	
segment_path = image_folder_name + File.separator + "Intensity_measurement" + File.separator +  imagenumber + "_reference_line_" + j + ".txt";
 // name file for reference line

	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	run("Interpolate", "interval=" + toString(interval) + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel
	Roi.getCoordinates(x,y);


File.saveString(toString(pw), image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_pixel_size_" + j + ".txt");
 // save file for pixel size
 
File.saveString("", segment_path); 

   for (k=0; k<lengthOf(x)-1; k++)
	{File.append('\r'+toString(x[k])+"\t"+toString(y[k])+'\r', segment_path);
 // save file for reference line

  	}
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_1_" + j + ".txt") // create file for intensity measurement on color 1
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_2_" + j + ".txt") // create file for intensity measurement on color 2


////// Local segments perpendicular to the junction are used to obtain the profile perpendicular to the junction

for (i=1; i<3; i++)
{	Stack.setChannel(i);
	f = File.open(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_" + i + "_" + j + ".txt");


   for (k=0; k<lengthOf(x)-2; k++)
	{		if (k<3) {
			norm = sqrt((x[0]-x[6])*(x[0]-x[6])+(y[0]-y[6])*(y[0]-y[6]));
			unit_perp_x = (-(y[6]-y[0])/norm);
			unit_perp_y = ((x[6]-x[0])/norm);
			}
			else if (k>lengthOf(x)-4) {
			norm = sqrt((x[lengthOf(x)-7]-x[lengthOf(x)-1])*(x[lengthOf(x)-7]-x[lengthOf(x)-1])+(y[lengthOf(x)-7]-y[lengthOf(x)-1])*(y[lengthOf(x)-7]-y[lengthOf(x)-1]));
			unit_perp_x = (-(y[lengthOf(x)-1]-y[lengthOf(x)-7])/norm);
			unit_perp_y = ((x[lengthOf(x)-1]-x[lengthOf(x)-7])/norm);
			}
			else {
			norm = sqrt((x[k-3]-x[k+3])*(x[k-3]-x[k+3])+(y[k-3]-y[k+3])*(y[k-3]-y[k+3]));
			unit_perp_x = (-(y[k+3]-y[k-3])/norm);
			unit_perp_y = ((x[k+3]-x[k-3])/norm);
			}
						
		//From the reference line, creates a segment (profile line) whose middle is a given point of the reference line, its length is +-2 microns and locally perpendicular to the reference line
		lengthofprofile = 401;
		profile=newArray(lengthofprofile); 

		for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));
						
			profile[l] = (1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1);
		}

		string="";
		for (l=0; l<lengthOf(profile); l++) {
			if (l==0) {
				string=string+profile[l];
			}
			else {
				string=string+"\t"+profile[l];
			}
			
		}
		print(f, string);
  	}
	File.close(f);

}
showMessageWithCancel("Finished");
}

/*************************************************************************************************/
macro "APICOBASAL (base LEFT): Fit apical edge of junction channel Action Tool - C66a T0709F T5709i T8709t Cc00 Tb709A Tg709B C66a T0f09j T2f09u T7f09n Tcf09c Thf09t" {
	
	Stack.setChannel(2);
	
	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	
	run("Interpolate", "interval=" + 1 + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel

	Roi.getCoordinates(x,y);

	lengthofprofile = 201;
	profile=newArray(lengthofprofile); 
	new_X=newArray(lengthOf(x)-1); 
	new_Y=newArray(lengthOf(x)-1); 
	
for (k=0; k<lengthOf(x)-1; k++)
	{
			norm = sqrt((x[k]-x[k+1])*(x[k]-x[k+1])+(y[k]-y[k+1])*(y[k]-y[k+1]));
			unit_perp_x = (-(y[k+1]-y[k])/norm);
			unit_perp_y = ((x[k+1]-x[k])/norm);

					for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));

						
			profile[l] = (1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1);
		}
		//finds the maximum along the junction
		maxLoc = Array.findMaxima(profile, 1);
        lmax = maxLoc[0];

        //finds the most apical point that intensity is at most a third of the maximum intensity
        l_third = 0;
        max_third = 0.333*profile[lmax];
        for (l=lmax+1; l<lengthOf(profile); l++)
		{if(profile[l]>=max_third)
		l_third = l;}
        

        new_X[k] = x[k] + 0.010/pw*(l_third-(lengthOf(profile)-1)/2)*unit_perp_x;
        new_Y[k] = y[k] + 0.010/pw*(l_third-(lengthOf(profile)-1)/2)*unit_perp_y;}

makeSelection("polyline", new_X, new_Y);
run("Fit Spline");}


/*************************************************************************************************/


macro "AB: Get intensity along junction (TJ on left) Action Tool -  C66a T0709T T5709w Tb709o T0f09I T2f09n T8f09t Cc00 Tbf09A Thf09B" {

/***
 * Save two files for two colors with (intensity vs position perp to TJ) vs position along TJ
 * Currently the distance between positions is 10nm along the tight junction and perpendicular to it
 */

image_folder_name = getDirectory("Please select the folder containing your image");

imagenumber = getTitle();

if (File.exists(image_folder_name + File.separator + "Intensity_measurement")!=1) {
	File.makeDirectory(image_folder_name + File.separator + "Intensity_measurement");
}

	i = 1;
	j = 1;
  while (File.exists(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_reference_line_" + i +".txt")==1) {	
   	i = i + 1;
	j = i;  }
	
	
segment_path = image_folder_name + File.separator + "Intensity_measurement" + File.separator +  imagenumber + "_reference_line_" + j + ".txt";
// name file for reference line

/*******************************************************************************/

//From the polyline currently drawn, find the new polyline that points Mn are spaced so that the projection of
// the vector MoMn on the unitary vector of direction MoMN (first and last points) equals an integer times a defined
// step size

Roi.getCoordinates(xpoints, ypoints);

getPixelSize(unit, pixelWidth, pixelHeight);
step_in_um = 0.010;
step = step_in_um/pixelWidth; //step in nm translated in pixel

M0 = newArray(xpoints[0], ypoints[0]);
MN = newArray(xpoints[xpoints.length-1], ypoints[ypoints.length-1]);
first_last_length = sqrt(pow(MN[0]-M0[0],2)+pow(MN[1]-M0[1],2));
ux = (MN[0]-M0[0])/first_last_length;
uy = (MN[1]-M0[1])/first_last_length;
unit_vector_main_dir = newArray(ux, uy);
//unit vector in the direction of first point-last point

new_segment_number_of_points = floor(sqrt(pow((MN[0]-M0[0]),2)+pow((MN[1]-M0[1]),2))/step)+1; //divides length of first to last point segment with step size

New_segment_xposition = newArray(new_segment_number_of_points);
New_segment_yposition = newArray(new_segment_number_of_points);
New_segment_xposition[0]=M0[0];
New_segment_yposition[0]=M0[1];

current_point = 0; /* used in the following loop to point to the nth point 
of the polyline used as a base for the new polyline*/

//Evaluate new coordinates
for(i=1; i<new_segment_number_of_points; i++)
{	current_segment_length = i*step;
	position = (xpoints[current_point]-M0[0])*unit_vector_main_dir[0]+(ypoints[current_point]-M0[1])*unit_vector_main_dir[1];
	//projection of first point-current point on the unitary vector in the direction of first point-last point
	//to evaluate the distance
		
	while(position < current_segment_length)
		{current_point = current_point + 1;
		position = (xpoints[current_point]-M0[0])*unit_vector_main_dir[0]+(ypoints[current_point]-M0[1])*unit_vector_main_dir[1];}

	if(position == current_segment_length)
		{New_segment_xposition[i] = xpoints[i];
		 New_segment_yposition[i] = ypoints[i];}
		
	else{//evaluate the centroid
		position_previous = (xpoints[current_point-1]-M0[0])*unit_vector_main_dir[0]+(ypoints[current_point-1]-M0[1])*unit_vector_main_dir[1];
		epsilon = (current_segment_length - position_previous)/((position - position_previous));
	
		New_segment_xposition[i]=(1-epsilon)*xpoints[current_point-1]+epsilon*xpoints[current_point];
		New_segment_yposition[i]=(1-epsilon)*ypoints[current_point-1]+epsilon*ypoints[current_point];
		}
}

makeSelection("polyline", New_segment_xposition, New_segment_yposition);

 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel
	Roi.getCoordinates(x,y);


File.saveString(toString(pixelWidth), image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_pixel_size_" + j + ".txt");
 // save file for pixel size
 
File.saveString("", segment_path); 

   for (k=0; k<lengthOf(x)-1; k++)
	{File.append('\r'+toString(x[k])+"\t"+toString(y[k])+'\r', segment_path);
 // save file for reference line

  	}
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_1_" + j + ".txt") // create file for intensity measurement on color 1
File.saveString("", image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_2_" + j + ".txt") // create file for intensity measurement on color 2


////// Local segments perpendicular to the junction are used to obtain the profile perpendicular to the junction

for (i=1; i<3; i++)
{	Stack.setChannel(i);
	f = File.open(image_folder_name + File.separator + "Intensity_measurement" + File.separator + imagenumber + "_Intensity_color_" + i + "_" + j + ".txt");

////// From the line drawn on the image, the first and last pointd are used to define an overall direction of apico-basal polarity (the perpendicular direction of this segment)
////// Then a given point on the line is used as a reference (middle point here) for a profile measured in the apico-basal direction


	//toUnscaled(x,y);
	nmax = lengthOf(x)-1;
	norm = sqrt((x[0]-x[nmax])*(x[0]-x[nmax])+(y[0]-y[nmax])*(y[0]-y[nmax]));
	unit_perp_x = (-(y[nmax]-y[0])/norm);
	unit_perp_y = ((x[nmax]-x[0])/norm);
	
   for (k=0; k<lengthOf(x)-2; k++)
	{
		//From the reference line, creates a segment (profile line) whose middle is a given point of the reference line, its length is +-2 microns and locally perpendicular to the reference line
		lengthofprofile = 401;
		profile=newArray(lengthofprofile); 

		for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pixelWidth*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pixelWidth*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));
	
			profile[l] = ((1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1));
		}

		string="";
		for (l=0; l<lengthOf(profile); l++) {
			if (l==0) {
				string=string+profile[l];
			}
			else {
				string=string+"\t"+profile[l];
			}
			
		}
		print(f, string);
  	}
	File.close(f);

}

showMessageWithCancel("Finished");
}

/*************************************************************************************************/


macro "Save as jpeg with 1µm scale bar Action Tool [F8] -  C000 T0709S T6709a Tc709v Th709e T4f09j T6f09p Tbf09g" {

nameimg = getTitle();

image_folder_name = getDirectory("Please select the folder containing your image");

if (File.exists(image_folder_name + File.separator + "Presentation_images")!=1) {
	File.makeDirectory(image_folder_name + File.separator + "Presentation_images");
}

run("RGB Color");
run("Scale Bar...", "width=1 height=2 font=14 color=White background=None location=[Lower Right] bold hide");
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + nameimg);
saveAs("tif", image_folder_name + File.separator + "Presentation_images" + File.separator + nameimg);
run("Copy");
close();

/// color side by side

selectWindow(nameimg);
getDimensions(width1, height1, channels, slices, frames);
newImage(nameimg + "HyperStack", "RGB", 3*width1, height1, channels, slices, frames);
makeRectangle(2*width1, 0, width1, height1);
run("Paste");


selectWindow(nameimg);
run("Duplicate...", "duplicate channels=1");
run("RGB Color");
run("Scale Bar...", "width=1 height=4 font=14 color=White background=None location=[Lower Right] bold hide");
name_red = substring(nameimg, 0, lengthOf(nameimg)-4) + "_red"; 
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_red);
run("Copy");
close();

selectWindow(nameimg + "HyperStack");
makeRectangle(width1, 0, width1, height1);
run("Paste");

selectWindow(nameimg);
run("Duplicate...", "duplicate channels=2");
run("RGB Color");
run("Scale Bar...", "width=1 height=4 font=14 color=White background=None location=[Lower Right] bold hide");
name_green = substring(nameimg, 0, lengthOf(nameimg)-4) + "_green"; 
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_green);
run("Copy");
close();

selectWindow(nameimg + "HyperStack");
makeRectangle(0, 0, width1, height1);
run("Paste");
name_triple = substring(nameimg, 0, lengthOf(nameimg)-4) + "_triple";
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_triple);
close();
}


/*************************************************************************************************/

macro "Save all except MAX in tiff in chosen directory with prefix Action Tool -  C000 T0709S T6709a Tc709v Th709e T4f09a T9f09l Tbf09l" {

  list = getList("image.titles");
  if (list.length==0)
     print("No image windows are open");
  else {
	dir = getDirectory("input folder");
	prefix = getString("type the prefix of files", "2016");
	for (i=0; i<list.length; i++)
        {if(startsWith(list[i], "MAX")==false)
 			{selectWindow(list[i]);       
        	saveAs("tiff", dir + File.separator + prefix + list[i]);}
        	}}
}

/*************************************************************************************************/
/*************************************************************************************************/

macro "Weighted average results for planar data (symmetrize along junction center) Action Tool -  C66a T0709R T5709e Ta709s Tc709u Tg709l T0f09p T5f09l T8f09a Tdf09n" {


 	color1_results=newArray(401); Array.fill(color1_results, 0); // initialize arrays where results will be written
 	color2_results=newArray(401); Array.fill(color2_results, 0);
 	variance_color1=newArray(401); Array.fill(variance_color1, 0);
 	variance_color2=newArray(401); Array.fill(variance_color2, 0);	

Results_folder = getDirectory("Please select the folder containing your results");
fileList = getFileList(Results_folder); 

data_color1 = "";
data_color2 = "";

for(i=0; i<fileList.length; i++){

//select each file with first color results

String.resetBuffer;
	if(indexOf(fileList[i], "color_1")>-1)
	{
//Open the current file
	filecolor = File.openAsString(Results_folder + File.separator + fileList[i]);
	data_color1 = data_color1 + filecolor;}

	else if(indexOf(fileList[i], "color_2")>-1)
		{
//Open the current file
	filecolor = File.openAsString(Results_folder + File.separator + fileList[i]);
	data_color2 = data_color2 + filecolor;}
	
}


//read file by row
	rows=split(data_color1, "\n");
				columns0=split(rows[0],"\t");
				//weights_col1[i_col1] = rows.length;
				x=newArray(columns0.length); Array.fill(x, 0);
				
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						x[k] = parseFloat(columns[columns.length-k-1]) + parseFloat(columns[k]) + x[k];
					 		}
					}
					
				// average value
				for(k=0; k<columns.length; k++){
							x[k] = x[k]/rows.length; // average value for a given position
					 		}
			
				// variance
				variance = newArray(columns0.length); Array.fill(variance, 0);
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						variance[k] = Math.sqr(parseFloat(columns[k]) - x[k]/2) + Math.sqr(parseFloat(columns[columns.length-k-1]) - x[k]/2) + variance[k];
					 		}
					}
				for(k=0; k<columns.length; k++){
					variance[k] = variance[k]/(rows.length-1); // average value for a given position
					}
	color1_results = x;
	variance_color1 = variance;

	rows=split(data_color2, "\n");
				columns0=split(rows[0],"\t");
				//weights_col1[i_col1] = rows.length;
				x=newArray(columns0.length); Array.fill(x, 0);
				
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						x[k] = parseFloat(columns[columns.length-k-1]) + parseFloat(columns[k]) + x[k];
					 		}
					}
					
				// average value
				for(k=0; k<columns.length; k++){
							x[k] = x[k]/rows.length; // average value for a given position
					 		}
			
				// variance
				variance = newArray(columns0.length); Array.fill(variance, 0);
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						variance[k] = Math.sqr(parseFloat(columns[k]) - x[k]/2) + Math.sqr(parseFloat(columns[columns.length-k-1]) - x[k]/2) + variance[k];
					 		}
					}
				for(k=0; k<columns.length; k++){
					variance[k] = variance[k]/(rows.length-1); // average value for a given position
					}
	color2_results = x;
	variance_color2 = variance;


File.saveString("", Results_folder + File.separator + "Results_mean_2.txt"); 

   for (k=0; k<lengthOf(color1_results); k++)
	{if(k==lengthOf(color1_results)-1){File.append(toString(color1_results[k])+"\t"+toString(color2_results[k])+"\t"+toString(variance_color1[k])+"\t"+toString(variance_color2[k]), Results_folder + File.separator + "Results_mean_2.txt");}
	else{File.append(toString(color1_results[k])+"\t"+toString(color2_results[k])+"\t"+toString(variance_color1[k])+"\t"+toString(variance_color2[k])+"\r", Results_folder + File.separator + "Results_mean_2.txt");}
  	}

}



/*************************************************************************************************/

macro "Weighted average results for apicobasal data Action Tool -  C66a T0709R T5709e Ta709s Tc709u Tg709l T0f09a T5f09p T9f09i Tbf09c" {

 	color1_results=newArray(401); Array.fill(color1_results, 0); // initialize arrays where results will be written
 	color2_results=newArray(401); Array.fill(color2_results, 0);
 	variance_color1=newArray(401); Array.fill(variance_color1, 0);
 	variance_color2=newArray(401); Array.fill(variance_color2, 0);	

Results_folder = getDirectory("Please select the folder containing your results");
fileList = getFileList(Results_folder); 

data_color1 = "";
data_color2 = "";

for(i=0; i<fileList.length; i++){

//select each file with first color results

String.resetBuffer;
	if(indexOf(fileList[i], "color_1")>-1)
	{
//Open the current file
	filecolor = File.openAsString(Results_folder + File.separator + fileList[i]);
	data_color1 = data_color1 + filecolor;}

	else if(indexOf(fileList[i], "color_2")>-1)
		{
//Open the current file
	filecolor = File.openAsString(Results_folder + File.separator + fileList[i]);
	data_color2 = data_color2 + filecolor;}
	
}

//read file by row
	rows=split(data_color1, "\n");
				columns0=split(rows[0],"\t");
				//weights_col1[i_col1] = rows.length;
				x=newArray(columns0.length); Array.fill(x, 0);
				
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						x[k] = parseFloat(columns[k]) + x[k];
					 		}
					}
					
				// average value
				for(k=0; k<columns.length; k++){
							x[k] = x[k]/rows.length; // average value for a given position
					 		}
			
				// variance
				variance = newArray(columns0.length); Array.fill(variance, 0);
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						variance[k] = Math.sqr(parseFloat(columns[k]) - x[k]) + variance[k];
					 		}
					}
				for(k=0; k<columns.length; k++){
					variance[k] = variance[k]/(rows.length-1); // average value for a given position
					}
	color1_results = x;
	variance_color1 = variance;

	rows=split(data_color2, "\n");
				columns0=split(rows[0],"\t");
				//weights_col1[i_col1] = rows.length;
				x=newArray(columns0.length); Array.fill(x, 0);
				
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						x[k] = parseFloat(columns[k]) + x[k];
					 		}
					}
					
				// average value
				for(k=0; k<columns.length; k++){
							x[k] = x[k]/rows.length; // average value for a given position
					 		}
			
				// variance
				variance = newArray(columns0.length); Array.fill(variance, 0);
				for(m=0; m<rows.length; m++){
					columns=split(rows[m],"\t");
					for(k=0; k<columns.length; k++){ 
						variance[k] = Math.sqr(parseFloat(columns[k]) - x[k]) + variance[k];
					 		}
					}
				for(k=0; k<columns.length; k++){
					variance[k] = variance[k]/(rows.length-1); // average value for a given position
					}
	color2_results = x;
	variance_color2 = variance;
	

				
	
File.saveString("", Results_folder + File.separator + "Results_mean_2.txt"); 

   for (k=0; k<lengthOf(color1_results); k++)
	{if(k==lengthOf(color1_results)-1){File.append(toString(color1_results[k])+"\t"+toString(color2_results[k])+"\t"+toString(variance_color1[k])+"\t"+toString(variance_color2[k]), Results_folder + File.separator + "Results_mean_2.txt");}
	else{File.append(toString(color1_results[k])+"\t"+toString(color2_results[k])+"\t"+toString(variance_color1[k])+"\t"+toString(variance_color2[k])+"\r", Results_folder + File.separator + "Results_mean_2.txt");}
  	}

}
	


/*************************************************************************************************/

macro "Generate averaged image of planar vs apico basal Action Tool -  Cc00 T0709A T7709v Tb709g C0c0 T0g09I T2g09m Tag09g" {
a = File.openDialog("Choose file with planar distribution");
b = File.openDialog("Choose file with apico-basal distribution");

	planar_data = File.openAsString(a);

	rows_planar=split(planar_data, "\n"); 
	color1_planar=newArray(rows_planar.length); 
	color2_planar=newArray(rows_planar.length); 
	for(m=0; m<rows_planar.length; m++){ 
	columns_planar=split(rows_planar[m],"\t"); 
	color1_planar[m]=parseFloat(columns_planar[0]); 
	color2_planar[m]=parseFloat(columns_planar[1]); 
	}

	apico_basal_data = File.openAsString(b);

	rows_apico_basal=split(apico_basal_data, "\n"); 
	color1_apico_basal=newArray(rows_apico_basal.length); 
	color2_apico_basal=newArray(rows_apico_basal.length); 
	for(m=0; m<rows_apico_basal.length; m++){ 
	columns_apico_basal=split(rows_apico_basal[m],"\t"); 
	color1_apico_basal[m]=parseFloat(columns_apico_basal[0]); 
	color2_apico_basal[m]=parseFloat(columns_apico_basal[1]); 
	}


File.saveString("", File.getParent(a) + File.separator + "2D distribution_color1.txt");
f = File.open(File.getParent(a) + File.separator + "2D distribution_color1.txt");

   for (k=0; k<rows_apico_basal.length; k++)
	{
		string="";
		for (l=0; l<rows_planar.length; l++) {
			if (l==0) {
				string=string+color1_apico_basal[rows_apico_basal.length-k-1]*color1_planar[l];
			} else {
				string=string+"\t"+color1_apico_basal[rows_apico_basal.length-k-1]*color1_planar[l];
			}
		}
		print(f, string);
  	}
File.close(f);

File.saveString("", File.getParent(b) + File.separator + "2D distribution_color2.txt");
g = File.open(File.getParent(b) + File.separator + "2D distribution_color2.txt");

   for (k=0; k<rows_apico_basal.length; k++)
	{
		string="";
		for (l=0; l<rows_planar.length; l++) {
			if (l==0) {
				string=string+color2_apico_basal[rows_apico_basal.length-k-1]*color2_planar[l];
			} else {
				string=string+"\t"+color2_apico_basal[rows_apico_basal.length-k-1]*color2_planar[l];
			}
		}
		print(g, string);
  	}
File.close(g);

run("Text Image... ", "open=[" + File.getParent(a) + File.separator + "2D distribution_color1.txt]");
rename("color1");

run("Text Image... ", "open=[" + File.getParent(b) + File.separator + "2D distribution_color2.txt]");
rename("color2");

run("Merge Channels...", "c1=color1 c2=color2 create");
setVoxelSize(10, 10, 1, "nm");
makeRectangle(125, 140, 150, 150);
run("Crop");
run("Scale Bar...", "width=200 height=4 font=14 color=White background=None location=[Lower Right] bold hide overlay");

saveAs("Tiff", File.getParent(a) + File.separator + "2D distribution_color2.tif");

}


/*************************************************************************************************
macro "Red to Magenta and copy to system [F5] Action Tool -  C000 T0709C T6709o Tc709l" {
run("Replace Red with Magenta");
run("Copy to System");}

/*************************************************************************************************
macro "Red to Magenta and copy to system Action Tool [F5]" {
run("Replace Red with Magenta");
run("Copy to System");}

/*************************************************************************************************


macro "Save as jpeg with 200nm scale bar Action Tool -  C000 T0709S T6709a Tc709v Th709e T4f09j T6f09p Tbf09g" {

nameimg = getTitle();

image_folder_name = getDirectory("Please select the folder containing your image");

if (File.exists(image_folder_name + File.separator + "Presentation_images")!=1) {
	File.makeDirectory(image_folder_name + File.separator + "Presentation_images");
}

run("RGB Color");
run("Scale Bar...", "width=0.2 height=4 font=14 color=White background=None location=[Lower Right] bold hide");
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + nameimg);
run("Copy");
close();

/// color side by side

selectWindow(nameimg);
getDimensions(width1, height1, channels, slices, frames);
newImage(nameimg + "HyperStack", "RGB", 3*width1, height1, channels, slices, frames);
makeRectangle(2*width1, 0, width1, height1);
run("Paste");


selectWindow(nameimg);
run("Duplicate...", "duplicate channels=1");
run("RGB Color");
run("Scale Bar...", "width=0.2 height=4 font=14 color=White background=None location=[Lower Right] bold hide");
name_red = substring(nameimg, 0, lengthOf(nameimg)-4) + "_red"; 
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_red);
run("Copy");
close();

selectWindow(nameimg + "HyperStack");
makeRectangle(width1, 0, width1, height1);
run("Paste");

selectWindow(nameimg);
run("Duplicate...", "duplicate channels=2");
run("RGB Color");
run("Scale Bar...", "width=0.2 height=4 font=14 color=White background=None location=[Lower Right] bold hide");
name_green = substring(nameimg, 0, lengthOf(nameimg)-4) + "_green"; 
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_green);
run("Copy");
close();

selectWindow(nameimg + "HyperStack");
makeRectangle(0, 0, width1, height1);
run("Paste");
name_triple = substring(nameimg, 0, lengthOf(nameimg)-4) + "_triple";
saveAs("Jpeg", image_folder_name + File.separator + "Presentation_images" + File.separator + name_triple);
close();
}


/*************************************************************************************************/


macro "PLANAR: Fit junction on middle junction channel 300nm thick Action Tool - C0c0 T0709F T5709i T8709t Cc00 Tb709P Th709l C0c0 T0f093 T4f090 T7f090 Tcf09n Thf09m" {
	
	Stack.setChannel(2);
	
	getPixelSize(unit, pw, ph, pd);
	interval = 0.010/pw;
	
	run("Interpolate", "interval=" + 1 + " smooth");
 // the line obtained is sampled with 10 nm distance between pixels in order to avoid image to image difference - interval is given in pixel

	Roi.getCoordinates(x,y);

	lengthofprofile = 31;
	profile=newArray(lengthofprofile); 
	new_X=newArray(lengthOf(x)-1); 
	new_Y=newArray(lengthOf(x)-1); 
	
for (k=0; k<lengthOf(x)-1; k++)
	{
			norm = sqrt((x[k]-x[k+1])*(x[k]-x[k+1])+(y[k]-y[k+1])*(y[k]-y[k+1]));
			unit_perp_x = (-(y[k+1]-y[k])/norm);
			unit_perp_y = ((x[k+1]-x[k])/norm);

					for (l=0; l<lengthOf(profile); l++)
		{	//interpolation of the value of pixel along the profile line 
			xM = x[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_x;
			yM = y[k] + 0.010/pw*(l-(lengthOf(profile)-1)/2)*unit_perp_y;

			espilon_x = (xM-floor(xM));
			espilon_y = (yM-floor(yM));

						
			profile[l] = (1-espilon_x)*(1-espilon_y)*getPixel(floor(xM),floor(yM))
						+(espilon_x)*(1-espilon_y)*getPixel(floor(xM)+1,floor(yM))
						+(espilon_x)*(espilon_y)*getPixel(floor(xM)+1,floor(yM)+1)
						+(1-espilon_x)*(espilon_y)*getPixel(floor(xM),floor(yM)+1);
		}
		// finds the maximum along the junction
		maxLoc = Array.findMaxima(profile, 1);
        lmax = maxLoc[0];

        new_X[k] = x[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_x;
        new_Y[k] = y[k] + 0.010/pw*(lmax-(lengthOf(profile)-1)/2)*unit_perp_y;}

makeSelection("polyline", new_X, new_Y);
run("Fit Spline");}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////				Functions

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function createMatrix(dims) {
	size1D = 1;
	nDims = dims.length;
	for(i=0; i<nDims;i++) {
		size1D *= dims[i];
	}
	arr = newArray(size1D+1+nDims);
	arr[0] = nDims;
	for(i=0; i<nDims;i++) {
		arr[i+1] = dims[i];
	}

	return arr;
}

/* Returns the value at a given array index */
function getMatrixValue(mat, pos) {
	D = getDims(mat);
	pos = getPos(pos, D);
	return mat[pos+mat[0]+1];
}

/* Sets the value at the current Array index */
function setMatrixValue(mat,pos, val) {
	//Pos is an array of the same number of dims as the array
	D = getDims(mat);
	pos = getPos(pos, D);
	print("Position", pos);
	mat[pos+mat[0]+1] = val;

	return mat;
}

/* Convenience function to get the number of dimensions of the array */
function getDims(mat) {
	D = newArray(mat[0]);
	for(i=1;i<=mat[0];i++) {
		D[i-1] = mat[i];
	}
	return D;
}

/* returns the position of the nD index as a 1D index */
function getPos(posA, dims) {
	pos=0;
	for(i=0 ; i<dims.length ; i++) {
		fac = 1;
		for(j=i+1 ; j<dims.length ; j++) {
			fac *= dims[j];
		}
		pos+= fac*posA[i];
	}
	
	return pos;
}


/*
 * quick demo to see that it is filling them correctly.
 */
 
 
D = newArray(2,2,2,3);
mat = createMatrix(D);
Array.print(mat);
o=1;
for(i=0;i<2;i++) {
	for(j=0;j<2;j++) {
		for(k=0;k<2;k++) {
			for(l=0;l<3;l++) {
				P = newArray(i,j,k,l);
				
				mat = setMatrixValue(mat, P, o++);
				pos = getPos(P,D);
				print("Pos", pos);
				Array.print(P);Array.print(mat);
			}
		}	
	}
}