# Geocoding Notebooks

The objective of these notebooks is to assign a geographic coordinates to health facilities from national registries by matching column names to administrative boundaries, matching facilities to entries from alternative sources, and running queries with geocoding APIs.

Due to the hierarchical nature of the health facilities dataset, our strategy is to attempt to geo-locate facilities a the most disaggregated level possible, and where that's not possible, we assign a location based on lower levels of geographic boundaries (provinces or districts).

The process keeps track of what geocoding method is used to assign geo-location, with some methods yielding higher accuracy/precision than others.

## Methodology

1. Clean and format data from hierarchy lists.
2. Match administrative name to administrative polygon shapefile across various levels using fuzzy matching.
3. Match to locations from the Health Sites IO / RHINO using fuzzy matching based on facility name (orgunitlevel 5), ensuring the result falls within the right admin boundary.
4. Run geocoding process using OSM, Bing Maps and Google Maps, using several combination names, with the following priority:
   * Highest unit level (orgunitlevel 5) and highest admin boundary level (admin 3), ensuring the result falls within admin 3 polygon.
   * Highest unit level (orgunitlevel 5) and second highest admin name (admin 2/1), ensuring the result falls within admin 3 polygon.
   * Second-highest unit level (orgunitlevel 4), ensuring the result falls within admin 3 polygon, otherwise use polygon centroid.
   * Geocode based on second-highest unit level (orgunitlevel 4) and lowest boundary level (admin 2/1) ensuring the result falls within admin 2/1 polygon.

## Data Sources
* Health Facility Lists (queried from HMIS)
* Administrative Boundaries (Geoboundaries, complemented with FEWS NET if necessary)
* Health Sites IO
* RHINo Vision Master Facility List Decision Support System

## Environment

The following packages are needed to run the notebooks.

```
conda create -n health python=3
conda activate health
conda config --env --add channels conda-forge
conda config --env --set channel_priority strict
conda install geopandas matplotlib geopy contextily tqdm thefuzz
pip install python-dotenv jupyter ipykernel
python -m ipykernel install --user --name health --display-name "Python Health"
```

Alternatively, create the environment from .yml file:

```
conda env create --name health --file=environment.yml
```

## API Requirements

The geocoding workflow requires accounts with commercial APIs (Google Maps and Bing Maps). The open-source service Nominatim (from Open Street Map) is used first, but the other two are deployed as backup when town names are not available in OSM.  

 See links below to create keys for each service, and save them in a .env file a the root of this repository.

* [Google Maps Platform](https://developers.google.com/maps/documentation/geocoding/cloud-setup)
* [Bing Maps](https://www.microsoft.com/en-us/maps/create-a-bing-maps-key)

Note that Google Maps allows 200$ worth of credits per month, equivalent to 40K requests.  
Bing allows 125K free requests per month. 

The workflow to geocode pilot countries should be reproducible with free credits from both platforms. When working with a new country, please check if the number of facilities will surpass the free quotas.
