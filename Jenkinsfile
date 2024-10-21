pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-cre'
        DOCKER_IMAGE = 'rofakvkm837/m-cart-service'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:Rofak/m-cart-service.git'
            }
        }

       stage('Build Application') {
            steps {
//                 script {
// //                     // Use OpenJDK 8 Docker image for this stage
// //                     docker.image('openjdk:8-jdk-alpine').inside {
// //                         sh 'chmod +x mvnw'
// //                         sh './mvnw clean package -DskipTests'
// //                     }
//                     // Run the Maven build inside a Docker container using OpenJDK 8
//                     // Map the .m2 directory to avoid permission issues
//                     sh '''
//                         docker run --rm \
//                         -v "$PWD":/app \
//                         -v "$HOME/.m2":/root/.m2 \
//                         -w /app openjdk:8-jdk-alpine sh -c "chmod +x mvnw && ./mvnw clean package -DskipTests"
//                     '''
//                 }
                script {
                    // Run the Maven build inside a Docker container using OpenJDK 17
                    sh '''
                        docker run --rm \
                        -v "$PWD":/app \
                        -v "$HOME/.m2":/root/.m2 \
                        -w /app openjdk:17-jdk bash -c "chmod +x mvnw && ./mvnw clean package -DskipTests"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
//                     docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}:latest").push()
//                         docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }

       stage('Deploy Docker Container') {
           steps {
               script {
                   // Check if the container is already running
                    def containerExists = sh(script: "docker ps -q -f name=m-cart-service", returnStdout: true).trim()

                    if (containerExists) {
                        echo "Container 'm-cart-service' is already running. Restarting the container."
                        sh 'docker restart m-cart-service'
                    } else {
                        echo "No existing container named 'm-eureka-server' found. Proceeding with deployment."
                        sh 'docker run -d -p 9008:9008 --name m-cart-service ${DOCKER_IMAGE}:latest'
                    }
               }
           }
       }


        stage('Cleanup Docker Images') {
             steps {
                 script {
                     sh 'docker image prune -f'
                     sh 'docker container prune -f'
                     }
                 }
             }
        }

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
