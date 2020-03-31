def ORG = "mayadataio"
def REPO = "mysqld-exporter"
def ONPREM_TAG = ""
def RELEASE_TAG = ""
pipeline {
    agent any
    stages {
        stage('Dependencies'){
            steps {   
                script {
                    //   sh """    
                    //   wget "https://raw.githubusercontent.com/mayadata-io/maya-io-release/master/utils/version_override?token=AHE72NEVS6LPUBOKK7LN5N26JTYYE"
                    //   mv version_override?token=AHE72NEVS6LPUBOKK7LN5N26JTYYE version_override
                    //   chmod +x version_override

                          
                    //   """
                    sh """
                        git clone git@github.com:mayadata-io/maya-io-release.git
                        cd maya-io-release/utils/
                        ls
                        echo $RELEASE_TAG
                        echo $ONPREM_TAG
                        
                    """
                    //   TAG = sh (returnStdout: true,script: "./tag_fetch.sh mysqld-exporter ${env.BRANCH_NAME}").trim()
                    TAG = sh (returnStdout: true,script: "pwd && ./tag_fetch.sh master").trim()
                      echo "$TAG"
                 }
            }
        }    

        stage('Build Image') {
            steps {
                script {
                  GIT_SHA = sh(
                            returnStdout: true,
                            script: "git log -n 1 --pretty=format:'%h'"
                            ).trim()
                  echo "Building MySQL Exporter"
                  sh "docker build -t ${ORG}/${REPO}:ci-${GIT_SHA} ."
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
		             withCredentials([usernamePassword( credentialsId: 'docke_cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            if (env.BRANCH_NAME == 'master')  {
                               echo "Pushing the image with the tag..."
                               sh "docker login -u${USERNAME} -p${PASSWORD} "

			                         sh "docker tag ${ORG}/${REPO}:ci-${GIT_SHA} ${ORG}/${REPO}:${TAG} docker push ${ORG}/${REPO}:ci-${TAG}"
                            } else {
			                   echo "WARNING: Not pushing Image"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'This will always run'
            deleteDir()
        }
        success {
            echo 'This will run only if successful'
            slackSend channel: '#jenkins-builds',
                   color: 'good',
                   message: "The pipeline ${currentBuild.fullDisplayName} completed successfully :dance: :thumbsup: "
        }
        failure {
            echo 'This will run only if failed'
            slackSend channel: '#jenkins-builds',
                  color: 'RED',
                  message: "The pipeline ${currentBuild.fullDisplayName} failed. :scream_cat: :japanese_goblin: "
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
            slackSend channel: '#jenkins-builds',
                   color: 'good',
                   message: "The pipeline ${currentBuild.fullDisplayName} is unstable :scream_cat: :japanese_goblin: "
        }
        changed {
/*            slackSend channel: '#jenkins-builds',
                   color: 'good',
                   message: "Build ${currentBuild.fullDisplayName} is now stable :dance: :thumbsup: "
            echo 'This will run only if the state of the Pipeline has changed'
*/            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
