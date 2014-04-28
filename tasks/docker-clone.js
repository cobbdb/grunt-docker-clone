/**
 * Runs a Docker build using the docker-clone.sh script.
 */
module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-exec');
    grunt.registerMultiTask(
        'docker-clone',
        'Build docker to a special docs branch.',
        function () {
            console.log(JSON.stringify(this.data, null, 4));
            if (!(this.data.src && this.data.branch)) {
                grunt.log.error('Missing required inpath and branch settings from config.');
            }

            var path = require.resolve('grunt-docker-clone');
            if (!path) {
                grunt.log.error('Cannot find grunt-docker.sh!');
                return false;
            }

            grunt.config.set('exec.docker-clone', {
                cmd: path + '<% src %> <% branch %>'
            });
            grunt.task.run('grunt-exec:docker-clone');
            this.requires('grunt-exec');

            grunt.verbose.ok();
        }
    );
};
