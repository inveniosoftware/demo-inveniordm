# InvenioRDM Demo Site

Available at <https://inveniordm.web.cern.ch>.

Further documentation on InvenioRDM available at <http://inveniordm.docs.cern.ch>.

## Development

To setup the instance locally:

```shell
pip install invenio-cli
invenio-cli check-requirements --development
invenio-cli install
invenio-cli services setup
invenio-cli run
```

See the [InvenioRDM Documentation](https://inveniordm.docs.cern.ch/install/) for further installation options.

### Update dependencies

To update dependencies you need to run `pipenv lock` in the target deployment
environment:

```shell
# Run the container with x86_64 architecture
docker run -it --platform="linux/amd64" --rm -v $(pwd):/app \
    registry.cern.ch/inveniosoftware/almalinux:1

# Inside the container update the Pipfile.lock
[root@3954486e4a37]# cd /app
[root@3954486e4a37]# pipenv lock
```
