Vagrant.configure("2") do |config|
    config.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: [".git/", ".vagrant/", '.repo/', '.idea/']

	config.vm.provider :virtualbox do |v|
        v.memory = 4096
        v.cpus = 4
		
		config.vm.box = "ubuntu/xenial64"
		config.disksize.size = '100GB'
    end

    config.vm.provider :aws do |aws, override|
        config.vm.box = "dummy"

        aws.region = "us-east-1"
        aws.ami = "ami-bcdc16c6"
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 100 }]
        aws.terminate_on_shutdown = true
        aws.elastic_ip = true
        aws.instance_type = "m3.xlarge"

        aws.tags = {
            'Name' => 'Jolla Builder'
        }
        pub_key = File.read('aws_key.pub')
        aws.user_data = "#!/bin/bash\necho '#{pub_key}' >> /home/ubuntu/.ssh/authorized_keys\nchown ubuntu /home/ubuntu/.ssh/authorized_keys\nchown go= /home/ubuntu/.ssh -R"

        override.ssh.username = "ubuntu"
        override.ssh.private_key_path = 'aws_key.pem'
    end

    config.vm.provision "shell", path: "build.sh", privileged: false
end
