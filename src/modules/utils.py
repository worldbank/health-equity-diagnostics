from pathlib import Path
import shutil
import zipfile
from datetime import datetime
import requests

def download_osm_shapefiles(region, country, outdir):
    """Downloads OSM latest shapefile from http://download.geofabrik.de/
    Parameters
    ----------
    region : str
        Continent/region where country is located as used on Geofrabrik website. For example, Africa, Asia, 
        South America (south-america)
    country : str
        Country name in full _description_
    outdir : str
        Directory to save the data.
    Returns
    --------
    Saves and unzips downloaded files in directory: outdir + country-latest-free-shp
    """
    start = datetime.now()
    geofabrick_url = 'http://download.geofabrik.de/{}/{}-latest-free.shp.zip'.format(
        region.lower(), country.lower())
    r = requests.get(geofabrick_url, allow_redirects=True)
    try:
        assert r.status_code == 200
    except AssertionError:
        print('ENSURE THERE IS INTERNET AND/OR REGION AND COUNTRY NAMES ARE CORRECT')
        return

    assert outdir.exists(), 'ENSURE OUTPUT DIRECTORY EXISTS'
    outfile = Path(outdir).joinpath(geofabrick_url.split("/")[-1])
    print('Saving file .............')
    open(outfile, 'wb').write(r.content)

    # print()
    # print('Unzipping file .............')
    # extract_outdir = Path(outdir).joinpath(
    #     outfile.parts[-1].split(".")[0] + "-shp").mkdir(parents=True, exist_ok=True)
    # with zipfile.ZipFile(outfile, "r") as zip_ref:
    #     zip_ref.extractall(extract_outdir)

    # # Delete zipfile
    # file_size = outfile.stat()[6]/1000000
    # shutil.rmtree(outfile)

    # end = datetime.now()
    # time_taken = (end - start).total_seconds/60

    # print()
    # print('Downloading {} MB took {} minutes'.format(
    #     int(file_size)), int(time_taken))

    # return extract_outdir