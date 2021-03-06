/**
 * Runs a Docker build using the docker-clone.sh script.
 */
module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-exec');
    grunt.registerMultiTask(
        'docker-clone',
        'Build docker to a special docs branch.',
        function () {
            if (!(this.data.dir && this.data.branch)) {
                grunt.log.error('Missing required dir and branch settings from config.');
                return false;
            }

            var path = require.resolve('grunt-docker-clone');
            if (!path) {
                grunt.log.error('Cannot find grunt-docker.sh!');
                return false;
            }

            var cmdStr = 'sh <%= path %> <%= dir %> <%= branch %> <%= index %>';
            grunt.config.set('exec.docker-clone', {
                cmd: grunt.template.process(cmdStr, {
                    data: {
                        path: path,
                        dir: this.data.dir,
                        branch: this.data.branch,
                        index: this.data.index || ''
                    }
                })
            });
            grunt.task.run('exec:docker-clone');
            grunt.verbose.ok();
        }
    );
};
