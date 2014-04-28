/**
 * Runs a Docker build using the docker-clone.sh script.
 */
module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-exec');
    grunt.registerMultiTask(
        'docker-clone',
        'Build docker to a special docs branch.',
        function () {
            if (!(this.data.inpath && this.data.branch)) {
                grunt.log.error('Missing required inpath and branch settings from config.');
            }

            var path = require.resolve('grunt-docker-clone');
            if (!path) {
                grunt.log.error('Cannot find grunt-docker.sh!');
                return false;
            }
console.log(grunt.template.process('<%= path %> <%= inpath %> <%= branch %>', {
                    path: path,
                    inpath: this.data.inpath,
                    branch: this.data.branch
                }));
            grunt.config.set('exec.docker-clone', {
                cmd: grunt.template.process('<%= path %> <%= inpath %> <%= branch %>', {
                    path: path,
                    inpath: this.data.inpath,
                    branch: this.data.branch
                })
            });
            grunt.task.run('exec:docker-clone');
            grunt.verbose.ok();
        }
    );
};
