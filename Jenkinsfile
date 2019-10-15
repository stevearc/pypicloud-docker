#!/usr/bin/env groovy

@Library('aaptivPipelineLib') _

/* Multipurpose vars defined here */
def ProjectName = 'pypi'

pipeline {
    agent {
        label 'build1'
    }
    options {
        buildDiscarder(
            logRotator(
                artifactDaysToKeepStr: '',
                artifactNumToKeepStr: '',
                daysToKeepStr: '30',
                numToKeepStr: '',
                )
        )
    }
    stages {
        stage('Get ECR Repo URI') {
            steps {
                script {
                    repoUri = getEcrRepo(ProjectName)
                }
            }
        }
        stage('Build Image') {
            environment {
                BRANCH_NAME = 'master'
            }
            steps {
                buildImage(ProjectName:ProjectName,repoUri:repoUri)
            }
        }
    }
    post {
        always {
            deleteDir() /* clean up our workspace */
        }
        success {
            slackSend channel: 'jenkins-deployments',
                    color: 'good',
                    message: "Pipeline ${currentBuild.fullDisplayName} completed successfully: ${currentBuild.absoluteUrl}"
        }
        failure {
            slackSend channel: 'jenkins-deployments',
                    color: 'bad',
                    message: "Pipeline ${currentBuild.fullDisplayName} has failed: ${currentBuild.absoluteUrl}"
        }
    }
}
