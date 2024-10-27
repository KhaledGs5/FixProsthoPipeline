pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/KhaledGs5/Fixprostho.git'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                sh """
                ${SCANNER_HOME}/bin/sonar-scanner \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.login=squ_05dc2fcafbc8abc4870094ea690acd6962787829 \
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
    }
}

