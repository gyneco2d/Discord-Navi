# Discord-Navi
A discord bot by gyneco2d using discordrb library.  
It's still under development.  

### implemented
- Notification when joining a voice channel.  

# Usage
- Clone this repository.  
  ```
  $ git clone https://github.com/gyneco2d/Discord-Navi.git
  $ cd Discord-Navi
  $ bundle install
  $ cp config.json.example config.json
  $ vim config.json  # fill in token &   client_id
  ```

- Prepare Google Cloud SDK  
  - Install Google Cloud SDK & Downloads key file.  
  - Specify Auth information.  
    `$ gcloud auth activate-service-account --key-file=<keyfile path>`  
  - Add keyfile path to environment variable.  
    `export GOOGLE_APPLICATION_CREDENTIALS=<keyfile path>`  

# LICENCE
[MIT](https://github.com/gyneco2d/Discord-Navi/blob/master/LICENSE)
