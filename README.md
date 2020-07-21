## IPX application on Ubuntu 16.04

Skeleton project files for building virtual machines on which to run ipx network applications with audio and video.

Uses ansible for configuring application virtual machine(s).

This may be of use to you? I hope so. The diagram is the basic setup for a non-routed ipx stand alone network.

Things may not work, are out of date, or just plain wrong. Running some of this software is a security nightmare. 

Please treat this as a development and application porting tool, not a production solution.

I have not tested this with ubuntu > 16.04, but it may work? No testing was done for 32-bit OS.

`video-capture.sh` is in a bit of state, it was a proof-of-concept and needs work.

## Usage:

1) Change ansible hosts and variables to suit.
2) Configure lighttpd to your purposes, and modify playbook accordingly.
3) Download required files from below
4) Create some archives for the playbook
5) Build!

## Links to files not included:

[VirtualGL](https://github.com/VirtualGL/virtualgl)
[RTSP-Simple-Server](https://github.com/aler9/rtsp-simple-server)
[ipx_ripd](http://launchpadlibrarian.net/1250387/ipxripd_0.7-13.1_amd64.deb)
[ipx](http://archive.ubuntu.com/ubuntu/pool/universe/n/ncpfs/ipx_2.2.6-8_amd64.deb)


## Contributing

Please don't. Fork away!


## License

MIT
