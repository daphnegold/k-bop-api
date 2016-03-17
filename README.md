# k-bop-api

[![Code Climate](https://codeclimate.com/github/daphnegold/k-bop-api/badges/gpa.svg)](https://codeclimate.com/github/daphnegold/k-bop-api)

## Contents
- [General information & dependencies](#information)
- [Product Plan](#product-plan)
- [How to contribute](#contributing)
- [Configuration & testing](#configuration)

## Information
This API:  
- Serves up song recommendations
- Manages Spotify playlists & database interactions
- [Product Plan](https://github.com/daphnegold/k-bop-api/blob/master/product-plan.md)
- [Trello Board](https://trello.com/b/sn0PXJ4Z/k-bop)

### Dependencies
- Ruby Version 2.2.3
- Spotify OAuth & REST API

## Contributing
1. Fork & clone the repo
2. `cd k-bop-api`
3. Checkout a new branch
4. `gem install bundler`
5. `bundle install`
6. `rake db:migrate`
7. Win!

## Configuration
Register an app with Spotify and set your callback to `http://localhost:3000/auth/spotify`.  

Visit `http://localhost:3000/auth/spotify`  and authenticate to generate user data.  

Create a .env file in the root directory with the following:
```
SPOTIFY_CLIENT_ID=<your client id>
SPOTIFY_CLIENT_SECRET=<your client secret>
TEST_TOKEN=<sample user token from database>
TEST_REFRESH=<sample user refresh token from database>
```

### Testing
Testing with RSpec requires TEST_TOKEN & TEST_REFRESH environment variables in your `.env`.  

For VCR configuration, create a `spec/vcr` directory.
