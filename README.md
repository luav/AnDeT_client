# AnDeT_client
This is a collection of client applications for AnDeT (Ant Development Tracker) at the Department of Biology of the UNIFR.  
AnDeT is an extension of [FORT (Formicidae Tracker)](https://github.com/formicidae-tracker) of the UNIL.

Website: https://www3.unifr.ch/bio/en/groups/leboeuf-group/  
Author of the extensions: Artem Lutov <lutov.analytics@gmail.com>

> To clone this repository with submodules use:
> ```
> $ git clone --recursive <repo_url>
> ```
> Anyway, all submodules are fetched automatically when installing requirements via the `build` script.

Components:
- `leto-cli` to watch live tracking video and configure the tracking itself;
- `tag-layouter` to draw tracking tags;
- `studio` to analyze tracking data.

## Requirements
Linux Debian 9+ / Ubuntu 18+.
> All required libraries are installed automatically during the initial build: `./build -i`.

## Build
To build all components for the first time, installing all requirements:
```
$ ./build.sh -i
```

For the subsequent builds of all components, or of the specified one:
```
$ ./build.sh [<component>]
```

Details:
```
$ ./build.sh [-h,--help] | [-i,--init] [<component>=ALL]
  -h,--help  - help, show this usage description
  -i,--init  - initialize the build environment, which should be done only when building the project for the first time
  <component>  - {leto-cli, tag-layouter, studio, ALL}

  Examples:
  $ ./build.sh -i
  $ ./build.sh tag-layouter
```
