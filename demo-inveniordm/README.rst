======================
 InvenioRDM Demo Site
======================

.. image:: https://img.shields.io/travis/inveniosoftware/demo-inveniordm.svg
        :target: https://travis-ci.org/inveniosoftware/demo-inveniordm

.. image:: https://img.shields.io/coveralls/inveniosoftware/demo-inveniordm.svg
        :target: https://coveralls.io/r/inveniosoftware/demo-inveniordm

.. image:: https://img.shields.io/github/license/inveniosoftware/demo-inveniordm.svg
        :target: https://github.com/inveniosoftware/demo-inveniordm/blob/master/LICENSE

InvenioRDM Demo Instance

Further documentation is available on
http://inveniordm.docs.cern.ch

## Development

To setup the instance locally:

```
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
