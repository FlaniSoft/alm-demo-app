pipeline {
    agent any

    environment {
        APP_NAME   = 'alm-demo-app'
        VERSION    = "1.0.${env.BUILD_NUMBER}"
        DEPLOY_DIR = '/var/www/alm-demo-deploy'
    }

    stages {
        stage('1. Checkout & Info') {
            steps {
                echo "Starte Build #${env.BUILD_NUMBER} für Version ${env.VERSION}"
            }
        }

        stage('2. Automated Quality Gate (Test)') {
            steps {
                sh 'chmod +x test.sh && ./test.sh'
            }
        }

        stage('3. Build & Versionierung') {
            steps {
                sh '''
                    mkdir -p dist
                    cp index.html dist/index.html
                    sed -i "s/__BUILD_VERSION__/v${VERSION}/g" dist/index.html
                    sed -i "s/__DEPLOY_DATE__/$(date '+%d.%m.%Y %H:%M:%S')/g" dist/index.html
                '''
            }
        }

        stage('4. Package Artifact (Artifactory-Simulation)') {
            steps {
                sh '''
                    mkdir -p artifacts
                    tar -czf artifacts/${APP_NAME}-v${VERSION}.tar.gz -C dist .
                    sha256sum artifacts/${APP_NAME}-v${VERSION}.tar.gz > artifacts/${APP_NAME}-v${VERSION}.tar.gz.sha256
                '''
                archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
            }
        }

        stage('5. Deploy auf Webserver (aaPanel)') {
            steps {
                sh '''
                    rm -rf ${DEPLOY_DIR}/*
                    tar -xzf artifacts/${APP_NAME}-v${VERSION}.tar.gz -C ${DEPLOY_DIR}/
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment von v${env.VERSION} erfolgreich abgeschlossen!"
        }
        failure {
            echo "Pipeline fehlgeschlagen – Live-System blieb unverändert!"
        }
    }
}
