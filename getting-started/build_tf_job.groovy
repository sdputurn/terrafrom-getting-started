pipelineJob('build-tf-job') {
  description("build tf code")
  properties {
        pipelineTriggers {
            triggers {
              cron {
                spec('@midnight or MM HH DOM MONTH DAYOFWEEK(0-7)')
              }
            }
        }
    }
  parameters {
    stringParam('name','value','desc')
  }
  definition {
    // can be defined in 2 ways using cps and cpsScm.
    // in cps you need to define the script of the pipeline like Jenkinsfile. or you can write whole script or reference to a file
    // cps example
    // cps {
    //   script('''
    //     pipeline {
    //         agent any
    //             stages {
    //                 stage('Stage 1') {
    //                     steps {
    //                         echo 'logic'
    //                     }
    //                 }
    //                 stage('Stage 2') {
    //                     steps {
    //                         echo 'logic'
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //   '''.stripIndent())
    //   sandbox()
    // }
    // example2 
    // cps {
    //   script(readFileFromWorkspace('file-seedjob-in-workspace.jenkinsfile'))
    //   sandbox()     
    // }
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/sdputurn/terrafrom-getting-started.git')
          }
          branch('main')
        }
      }
      lightweight()
      scriptPath 'getting-started/Jenkinsfile'
    }
  }
}