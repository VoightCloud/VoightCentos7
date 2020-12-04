def label = "ImageBuildPod-${UUID.randomUUID().toString()}"

podTemplate(label: label,
        containers: [
                containerTemplate(name: 'git', image: 'alpine/git', ttyEnabled: true, command: 'cat'),
                containerTemplate(name: 'packer', image: 'hashicorp/packer:latest', ttyEnabled: true, command: 'cat'),
                containerTemplate(name: 'amazoncli', image: 'amazon/aws-cli', ttyEnabled: true, command: 'cat')
        ],
        nodeSelector: 'role=workers')
        {
            node(label) {
                branch = env.BRANCH_NAME.replaceAll("/", "-")
                base_ami_id = "ami-06cf02a98a61f9f5e" // Base Centos 7.8 x86_64
                base_OS = "CentOS 7.9.2009 x86_64"
                region = "us-east-1"
                owner_id = "125523088429"

                echo "Branch name is '${branch}'"
                if (branch == "main") {
                    echo "Branch is main so renaming to gold."
                    branch = "gold"
                }
                stage('Checkout Code') {
                    cleanWs()
                    checkout scm
                }
                stage('Delete branch image if it exists') {
                    container('amazoncli') {
                        withCredentials([usernamePassword(credentialsId: 'JeffAWS', usernameVariable: 'AWS_ACCESS_KEY_ID',
                                passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                            echo "Checking for image."
                            awsID = sh(
                                    script: "aws ec2 describe-images --region ${region} " +
                                            "--filters \"Name=name,Values=packer-ami-centos7-${branch}\" " +
                                            "--query 'Images[*].[ImageId]' --output text",
                                    returnStdout: true
                            ).trim()
                            if (awsID?.trim()) {
                                echo "Removing existing image"
                                sh("aws ec2 deregister-image --region ${region} --image-id $awsID")
                            }
                            echo "Collecting base image id."
                            // Collect the base image while we're in the container for it.
                            base_ami_id = sh(
                                    script: "aws ec2 describe-images --region ${region} " +
                                            "--filters \"Name=owner-id,Values=${owner_id}\" " +
                                            "\"Name=architecture,Values=x86_64\" \"Name=name,Values=${base_OS}\" " +
                                            "--query 'Images[*].[ImageId]' --output text",
                                    returnStdout: true
                            ).trim()
                        }
                    }
                }

                stage('Create image') {
                    container('packer') {
                        withCredentials([usernamePassword(credentialsId: 'JeffAWS', usernameVariable: 'AWS_ACCESS_KEY_ID',
                                passwordVariable: 'AWS_SECRET_ACCESS_KEY'),
                                string(credentialsId: 'ansible_vault_password', variable: 'VAULT_PASSWORD')]) {
                            ansiColor('xterm') {
                                sh("packer build -var 'branch=${branch}' -var base_ami_id='${base_ami_id}' -var ansible_vault_password='${VAULT_PASSWORD}' packer/template.json")
                                archiveArtifacts artifacts: '*report.html'
                            }
                        }
                    }
                }
            }
        }
