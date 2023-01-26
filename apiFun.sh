#!/bin/bash

# -s silent mod, jq '{index}' gets contex of given index, tr -d {symbols} removes given symbols
cat_response=$(curl -s "https://api.thecatapi.com/v1/images/search" | jq '[0].url' | tr -d \")
# -s silent mod, -o output
curl -s -o _tmp_img "$cat_response"
# show picture
catimg -l 0 _tmp_img
# remove picture
rm _tmp_img

chuck_response=$(curl -s "https://api.chucknorris.io/jokes/random" | jq '.value' | tr -d \")
echo ${chuck_response}