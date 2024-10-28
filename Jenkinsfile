pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/KhaledGs5/FixProsthoPipeline.git'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                sh """
                ${SCANNER_HOME}/bin/sonar-scanner \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.login=squ_d66f2cf5974623f1f25acc4cdb19159a38a592e7 \
                -Dsonar.projectName=FixProstho \
                -Dsonar.java.binaries=. \
                -Dsonar.projectKey=FixProstho \
                -X
                """
            }
        }
        stage('OWASP SCAN') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker build -t khaledgs/fixprostho ."
                        sh "docker push khaledgs/fixprostho"
                    }
                }
            }
        }
    }
}

