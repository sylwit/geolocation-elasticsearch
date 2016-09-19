# Geolocation and Elasticsearch

This repository is the POC of my [**Geolocation and Elasticsearch**][1] post

I recommend this nice chrome extension ["Sense"][2] to interact with your server

## Create Index

```
PUT /countries
{
  "mappings": {
    "country": {
      "properties": {
        "name": {
          "type": "string"
        },
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}
```

## Download JSON file and create file to import
The datasource comes from the excellent [restcountries.eu][3] API
that we will rewrite to match Elasticsearch Bulk import format and [geo_point format][4]

This task can be achieve by running `./download.sh`. You will need the [`jq` command-line JSON processor][5]

## Bulk import

`curl -s -XPOST localhost:9200/_bulk --data-binary "@countries";`

## List all countries


```
GET /countries/_search
{
   "size" : 100,
   "query": {
      "match_all": {}
   }
}
```


## Filter by geo distance

```
GET /countries/_search
{
   "size": 50,
   "query": {
      "bool": {
         "must": {
            "match_all": {}
         },
         "filter": {
            "geo_distance": {
               "distance": "3000km",
               "location": {
                  "lat": 60,
                  "lon": -95
               }
            }
         }
      }
   },
   "sort": [
      {
         "_geo_distance": {
            "location": {
               "lat": 60,
               "lon": -95
            },
            "order": "asc",
            "unit": "km",
            "distance_type": "sloppy_arc"
         }
      }
   ]
}
```

[1]: https://medium.com/@sylwit/geolocation-and-elasticsearch-e9208b1b3161
[2]: https://chrome.google.com/webstore/detail/sense-beta/lhjgkmllcaadmopgmanpapmpjgmfcfig
[3]: https://restcountries.eu/rest/v1/all
[4]: https://www.elastic.co/guide/en/elasticsearch/guide/current/lat-lon-formats.html
[5]: https://stedolan.github.io/jq/
