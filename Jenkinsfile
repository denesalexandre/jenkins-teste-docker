pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'meu-usuario/meu-repositorio'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Preparar Ambiente') {
            steps {
                script {
                    echo "Preparando ambiente..."
                }
            }
        }
        
        stage('Checkout Código Fonte') {
            steps {
                checkout scm
            }
        }

        stage('Construir Imagem Docker') {
            steps {
                script {
                    echo "Construindo a imagem Docker..."
                    sh 'docker build -t $DOCKER_IMAGE_NAME:$DOCKER_TAG .'
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Limpando recursos temporários..."
                sh 'docker system prune -f'
            }
        }

        success {
            echo "Pipeline concluído com sucesso!"
        }

        failure {
            echo "Pipeline falhou!"
        }
    }
}
