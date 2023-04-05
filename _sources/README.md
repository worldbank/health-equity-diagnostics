# GFF Health Equity

This repository contains scripts developed by GOST to map health facilities and understand differences in population access in support of the GFF Country Equity Diagnostic and other projects.

## Country Equity Diagnostic

**Health access indicators at the sub-national level**
- Percentage of health facilities with direct access to an all-season road.
- Percentage of health facilities within 2km of an all-season road.
- Percentage of population within 2h of driving to the nearest primary care facility (population level, and by SES quintile).
- Percentage of population within 2h of driving to the nearest district hospital (population, and by SES quintile).

### Data Sources
- *Health facilities*: National Registry Master List / or HMIS
- *Administrative Boundaries*: World Bank GAUL Level 1/2
- [*Global Friction Surface (2019)*](https://developers.google.com/earth-engine/datasets/catalog/Oxford_MAP_friction_surface_2019)
- *Population 2020*: WorldPop 1km Grid Unconstrained

### Results

🔖 [**Liberia**](notebooks/diagnostic/liberia.ipynb)
🔖 [**Ghana**](notebooks/diagnostic/ghana.ipynb)
🔖 [**Sierra Leone**](notebooks/diagnostic/sierra-leone.ipynb)
🔖 [**Mali**](notebooks/diagnostic/mali.ipynb)
🔖 [**Bangladesh**](notebooks/diagnostic/bangladesh.ipynb)

These pages are generated from the following python notebooks:
> notebooks/diagnostic/country

## Geocoding

The objective of these notebooks is to assign geographic coordinates to health facilities from HMIS database by matching column names to administrative boundaries, matching facility names to entries from alternative sources, and running queries with geocoding APIs.

Due to the hierarchical nature of the health facilities dataset, our strategy is to attempt to geo-locate facilities a the most disaggregated level possible. Where a match is not possible, we assign a location based on lower levels of geographic boundaries (provinces or districts).

The process keeps track of what geocoding method is used to assign geo-location, with some methods yielding higher accuracy/precision than others.

See latest run at:
> notebooks/geocoding/country

### Data Sources
* Health Facility Lists (queried from HMIS)
* Administrative Boundaries (Geoboundaries, complemented with FEWS NET if necessary)
* Health Sites IO
* RHINo Vision Master Facility List Decision Support System

### Methodology

1. Clean and format data from hierarchy lists.

2. Match administrative name to administrative polygon shapefile across various levels using fuzzy match.

3. Match to locations from the Health Sites IO / RHINO using fuzzy match based on facility name, ensuring the result falls within the right admin boundary,

4. Geocode with APIs (OSM, Bing Maps, and Google) based on highest unit level (orgunitlevel 5), and highest admin boundary level (admin 3), ensuring the result falls within polygon.

5. Geocode with APIs (OSM, Bing Maps, and Google) based on highest unit level (orgunitlevel 5), and second highest admin boundary level (admin 2), ensuring the result falls within polygon.

6. Geocode based on second-highest unit level (orgunitlevel 4), ensuring the result falls within polygon (admin 3), otherwise use polygon centroid.

7. Geocode based on second-highest unit level (orgunitlevel 4) and lowest boundary level (admin 2) ensuring the result falls within polygon.

### Environment

The following packages are needed to run these notebooks.

```
conda create -n health python=3
conda activate health
conda config --env --add channels conda-forge
conda config --env --set channel_priority strict
conda install geopandas matplotlib geopy contextily tqdm thefuzz
pip install python-dotenv jupyter ipykernel
python -m ipykernel install --user --name health --display-name "Python Health"
```

### API Requirements

The geocoding workflow requires accounts with commercial APIs (Google Maps and Bing Maps). The open-source service Nominatim (from Open Street Map) is used first, but the other two are deployed as backup when town names are not available in OSM.  

 See links below to create keys for each service, and save them in a .env file a the root of this repository.

* [Google Maps Platform](https://developers.google.com/maps/documentation/geocoding/cloud-setup)
* [Bing Maps](https://www.microsoft.com/en-us/maps/create-a-bing-maps-key)

Note that Google Maps allows 200$ worth of credits per month, equivalent to 40K requests. Bing allows 125K free requests per month. 

## Other notebooks

- liberia_analysis
    > Proof of concept notebooks for Liberia.

- liberia_data_inspection
    > Initial notebooks to explore data sources.

## License

The <span style="color:#3EACAD">template</span> is licensed under the [**World Bank Master Community License Agreement**](LICENSE).