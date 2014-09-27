# grunt-docker-clone [![NPM version](https://badge.fury.io/js/grunt-docker-clone.svg)](http://badge.fury.io/js/grunt-docker-clone)

Run a Docker build to a special branch.

    $ npm install grunt-docker-clone

-------------
Docker-clone runs a Docker build into a branch of the same repo.
Think GitHub's gh-pages, where there is a special branch of the same
repo just for documentation/website data.

## Task Configuration
There are only three options to configure your docker build:

    'docker-clone': {
        build: {
            dir: 'src',
            branch: 'my-pages',
            index: 'optional/source.file.html'
        }
    }

#### dir
Required. Directory of source files to run your Docker build against.

#### branch
Required. Branch name on origin to push your docs to.

#### [index]
Optional. Path relative to the `docs-clone` directory that leads to the
rendered html file that will become your `index.html` file.
This is useful when posting docs to the web as a landing page.

The task can be loaded like any other grunt contrib:

    grunt.loadNpmTasks('grunt-docker-clone');

---------
* See: https://www.npmjs.org/package/grunt-docker-clone
* See: http://github.com/cobbdb/grunt-docker-clone
* License: MIT
