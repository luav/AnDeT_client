# AnDeT_client
Client Applications for AnDeT (Ant Development Tracker)

> To clone this repository with submodules use:
> ```
> $ git clone --recursive <repo_url>
> ```
> Anyway, all submodules are fetched automatically when installing requirements via the build script.

Components:
- leto (client: leto-cli) to watch live tracking video and configure the tracking itself;
- tag-layouter to draw tracking tags;
- studio to analyze tracking data.

## Requirements
Linux Debian 9+ / Ubuntu 18+

## Build
To build all components:
```
$ ./build.sh
```
