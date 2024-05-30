pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'meu-usuario/meu-repositorio' // Nome da imagem Docker
        DOCKER_TAG = 'latest' // Tag da imagem
    }

    stages {
        stage('Preparar Ambiente') {
            steps {
                script {
                    // Exemplo de preparação de ambiente, se necessário
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
