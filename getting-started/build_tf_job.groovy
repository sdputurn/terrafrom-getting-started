pipelineJob('build-tf-job') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/sdputurn/terrafrom-getting-started.git')
          }
          branch('HEAD')
        }
      }
      lightweight()
      scriptPath 'getting-started/Jenkinsfile'
    }
  }
}