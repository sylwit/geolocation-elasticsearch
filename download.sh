#!/usr/bin/env bash

FILE='countries'

curl https://restcountries.eu/rest/v1/all | jq -c '.[] | {"index": {"_index": "countries", "_type": "country", "_id": .alpha3Code}}, {name: .name, location: [.latlng[1], .latlng[0]] }' > $FILE
