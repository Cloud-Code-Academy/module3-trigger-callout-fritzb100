# This is a cheatsheet to get to things quickly without having to look it up

`show debug logs`
 sf apex tail log --color

`set remote site setting`
--> make sure to set that up

`Set up external credentials`
--> make sure to set that up

`Set up named credentials`
--> make sure to set that up

`Steps to authorize github`
1. clone the repo
2. sf org display --verbose --json > authFile.json
3. copy the auth url
4. go to github actions
5. under seccrets create a new Repository secret called DEV_HUB_AUTH_URL
6. paste the auth url in the secret value

`convert json to apex`
https://www.adminbooster.com/tool/json2apex
https://json2apex.github.io/ //didn't work
https://jsoneditoronline.org/  // edit json

`deserializedUtyped` = `JSON.deserializeUntyped(jsonString)` = you have to set them up separately
-- you have to create a map of string objects

`wrapper Class` - avoids the deserializedUntyped and makes it easier to work with the data
-- you can use the wrapper class to deserialize the json string into a class object