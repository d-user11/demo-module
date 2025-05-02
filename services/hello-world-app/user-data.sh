#!/bin/bash

INSTANCE_ID=$(ec2metadata --instance-id)

cat > index.html <<EOF
<h1>${server_text}</h1>
<p>instance_id: $INSTANCE_ID</p>
EOF

nohup busybox httpd -f -p ${server_port} &