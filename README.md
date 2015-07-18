# docker plex

This is a Dockerfile to set up (https://plex.tv/ "Plex Media Server") - (https://plex.tv/)

For alternative version that someone is running that may not work for everyone but if it does is a simpler system look at https://registry.hub.docker.com/u/wernight/plex-media-server/

Build from docker file

```
git clone git@github.com:chosenken/docker-plex.git
cd docker-plex
docker build -t plex .
```

You can also obtain it via:

```
docker pull chosenken/plex
```

---
Instructions to run:

```
docker run -d -h *your_host_name* -v /*your_config_location*:/config -v /*your_videos_location*:/mnt/Downloads -p 32400:32400  plex
```
or for auto detection to work add --net="host". Though be aware this more insecure and not best practice with docker images.

The only reason for doing it is to allow Avahi to work (As it uses broadcasts will not cross network boundries). If anyone knows of a better method please shout and we can get it added.

See https://docs.docker.com/articles/networking/#how-docker-networks-a-container

```
docker run -d --net="host" -v /*your_config_location*:/config -v /*your_videos_location*:/Downloads -p 32400:32400  plex
```

The first time it runs, it will initialize the config directory and terminate. (This most likely won't happen if you've used the --net="host")

You will need to modify the auto-generated config file to allow connections from your local IP range (This should not be needed if you've used the --net="host"). This can be done by modifying the file:

*your_config_location*/Library/Application Support/Plex Media Server/Preferences.xml

and adding ```allowedNetworks="192.168.1.0/255.255.255.0" ``` as a parameter in the <Preferences ...> section. (Or what ever your local range is)

Start the docker instance again and it will stay as a daemon and listen on port 32400.

Browse to: ```http://*ipaddress*:32400/web``` to run through the setup wizard.

