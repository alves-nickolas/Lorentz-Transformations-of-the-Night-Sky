from astroquery.vizier import Vizier # querying data
from astropy.coordinates import SkyCoord # converting spherical coordinate systems
import astropy.units as u # handling units

# we want to grab the right ascension (RAJ2000), the declination (DECJ2000), and the apparent magnitude (Vmag)
columns = ["RAJ2000", "DEJ2000", "+Vmag"] # sorts by Vmag
vizier = Vizier(columns=columns, column_filters={"Vmag":"!=","RAJ2000":"!=","DEJ2000":"!="}) # none of the fields should be empty!
vizier.ROW_LIMIT = -1  # get as many rows as available

# Yale Bright Star Catalogue -> "V/50"
ybsc = vizier.get_catalogs("V/50")[0]

# next step is to change the spherical coordinates to radians
coords = SkyCoord(ra=ybsc['RAJ2000'], dec=ybsc['DEJ2000'], unit=(u.hourangle, u.deg))
ra_rad = coords.ra.radian
dec_rad = coords.dec.radian
# rewrite the table
ybsc['RAJ2000'] = ra_rad
ybsc['DEJ2000'] = dec_rad

# export
ybsc.write("ybsc.csv", format="csv", overwrite=True)