size(6cm); // size of the picture
import three; // 3D graphics
import graph3; // more 3D graphics

// First we configure the overall parameters for the image

// graphical options
bool dark_background = false; // plot on a dark or light background
bool orange = false; // orange frame for the big dipper
bool antipodal = true; // whether to apply an antipodal map to adhere to celestial globe conventions

// parameters for the Möbius transformation (you can set a four-screw with vel and ang, or mess around with the Möbius transformation directly)
real vel = 0; // velocity for a z-axis boost
real ang = 0; // angle for a z-axis rotation

pair a = (1,0); // Möbius transformation z -> (az+b)/(cz+d)
pair b = (0,0);
pair c = (0,0);
pair d = (1,0);

// cutoff on which stars to show (based on magnitude)
real m_cutoff = 4.5; // maximum magnitude allowed

usersetting(); // user can input other values for Möbius and for the configuration variables (dark_background, antipodal)

// Next we use the inputted variables above to set up the remaining configuration we will need

// if user changed vel and ang, but not the a parameter in the Möbius transformation, we update a
if (a == (1,0)) {
    a = sqrt((1+vel)/(1-vel))*expi(ang);
}

// implement (or not) the antipodal map by defining a single sign to be used throughout the code
int antipodal_sign = 1;
if (antipodal) {
    antipodal_sign = -1; 
}

// set projection for the camera view
triple spherical(real theta, real phi) {
    return antipodal_sign*(sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta));
} // function converting spherical angles to Cartesian coordinates

currentprojection = perspective(camera=spherical(pi/5, pi), up=antipodal_sign*Z); // point of view at Ursa Major, including "upwards" direction to account for antipodal map

pen starpen; // how to color background and stars depending on light or dark background
pen big_dipper;
if (dark_background) {
    draw(unitsphere,surfacepen=material(diffusepen=darkgray,emissivepen=darkgray, specularpen=black));
    starpen = white;
    big_dipper = white;
} else {
    draw(unitsphere,surfacepen=material(diffusepen=darkgray,emissivepen=lightgray, specularpen=black));
    starpen = black;
    if (orange) {
        big_dipper = rgb(223,45,22);
    } else {
        big_dipper = black;
    }
}

// Now we get to the mathematics. We work with three different coordinate systems: spherical (data inputs from astronomical catalogues), stereographic (useful for conformal transformations), and Cartesian (used in plotting). Let us set up the necessary conversions

real cot(real x) {
    return cos(x)/sin(x);
}

pair stereographic(real theta, real phi) {
    return cot(theta/2)*expi(phi); 
} // converts spherical coordinates to stereographic

triple cart_from_ste(pair z) {
    real x = z.x;
    real y = z.y;
    real r2 = x*x + y*y;
    real denom = 1 + r2;
    return antipodal_sign*(2*x/denom,2*y/denom,(r2-1)/denom);
} // function converting spherical angles to Cartesian coordinates

// conformal transformations are implemented in stereographic coordinates with Möbius transformations
pair mobius(pair z, pair a, pair b, pair c, pair d){
    pair num = a*z + b;
    pair denom = c*z + d;
    return num/denom;
} // generic Möbius transformation

// at last, we ensure magnitude is mapped to point size (brighter stars are larger)
real magscale(real m) {
    return 1 * exp(-0.4 * (m - 1)); 
}


// Show time. Let us import the catalogue and make the plot

file in = input("ybsc.csv");
string titlelabel = in.line(); // drops the header of the .csv file
real[][] stars = in.csv().dimension(0,0); // array with the remaining .csv data
stars = transpose(stars);
real[] rarad = stars[0]; // right ascent
real[] decrad = stars[1]; // declination
real[] mag = stars[2]; // apparent magnitude

int Ntot = decrad.length; // number of stars to loop over

for (int i = 0; i < Ntot; ++i){ // loop over each star
    if (mag[i] > m_cutoff) {
        break; // drop stars that are not bright enough
    }

    // change coordinates to standard spherical coordinates for plotting
    real theta = -decrad[i] + pi/2;
    real phi = rarad[i];

    triple p = cart_from_ste(mobius(stereographic(theta,phi), a, b, c, d)); // spherical -> stereographic -> Möbius transformation -> Cartesian

    dot(p, starpen + linewidth(magscale(mag[i]))); // draws the star
}

// adding the Big Dipper drawing by manually linking the stars
real[][] bigdipper = { // RA, Dec, Vmag
  {2.8960611888602736, 1.0777553575169319, 1.79}, // α UMa (Dubhe)
  {2.8878290525550345, 0.9840602655057029, 2.37}, // β UMa (Merak)
  {3.11467094987778,   0.9371496937215441, 2.44}, // γ UMa (Phecda)
  {3.208904185075041,  0.995404905643666,  3.31}, // δ UMa (Megrez)
  {3.3773357300977107, 0.9766814012792158, 1.77}, // ε UMa (Alioth)
  {3.507784547273853,  0.9586269397946965, 2.27}, // ζ UMa (Mizar)
  {3.6108244229884687, 0.8606800318001371, 1.86}  // η UMa (Alkaid)
}; // manually taken from YBSC

for (int i = 1; i < bigdipper.length; ++i){
    // change coordinates to standard spherical coordinates for plotting
    real theta0 = -bigdipper[i-1][1] + pi/2;
    real phi0 = bigdipper[i-1][0];
    real theta1 = -bigdipper[i][1] + pi/2;
    real phi1 = bigdipper[i][0];

    triple star0 = cart_from_ste(mobius(stereographic(theta0,phi0), a, b, c, d));
    triple star1 = cart_from_ste(mobius(stereographic(theta1,phi1), a, b, c, d));

    draw(Arc((0,0,0), star0, star1), big_dipper+linewidth(magscale(5))); // draws an arc connecting two consecutive stars
}