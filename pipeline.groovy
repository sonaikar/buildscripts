pipelineJob('testpipeline') {
    definition {
        cps {
            scm {
                git {
                    remote {
                    // Sets credentials for authentication with the remote repository.
                    credentials ('d862a434-15e1-4689-9033-e712110f634f')

                    // Sets a remote URL for a GitHub repository.
                    github('sonaikar', 'https', 'github.com')

                    url('https://github.com/sonaikar/buildscripts.git')
                    }
                    branch('master')
                }
        }
          scriptPath('Jenkinsfile')
    }
}
}
