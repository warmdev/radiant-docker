## Dockerfile for Radiant

Dockerfile for the `Radiant` business analytics tool developed by [Vincent Nijs](https://github.com/vnijs/radiant).

The Dockerfile is inspired by the `rocker/shiny` image and uses the `shiny-server.sh` startup script from https://github.com/rocker-org/shiny.

### Usage

```
git clone https://github.com/warmdev/radiant-docker.git
cd radiant-docker
sudo docker build -t radiant .
sudo docker run -d -p 3838:3838 radiant
```

`Radiant` will be live at `http://localhost:3838/radiant/inst/base`. Replace `base` with `quant`, `analytics` or `marketing` for other `Radiant` apps. See https://github.com/vnijs/radiant for details.

### Version information

* OS: CentOS 7
* R: Microsoft R Open 3.2.3
* Shiny Server: 1.4.2.786
