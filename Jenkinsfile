pipeline{

    agent{ node{ label 'master' } }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }
    triggers { cron('H * * * *')
    }

    stages{
        stage('build'){
            steps{
                sh 'echo Hello!, "${PERSON}" '
            }
        }
    }

    post {
        always {
            echo 'I will always say Hello again!'
        }
    }

}
