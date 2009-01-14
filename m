From: Bret Palsson <bret@getjive.com>
Date: Wed, 14 Jan 2009 13:34:07 -0700
Subject: [Ocfs2-devel] Transport endpoint is not connected while mounting....
Message-ID: <37791C54-243B-403A-A38D-7EC35101A9AA@getjive.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Does anyone have any idea what to try next? Here are the steps I have  
taken and the problem:     (I wanted to post my question on the first  
line before I explained the problem and what I have tried)

----------

Node 0 has the file system mounted just fine and works great.

When trying to mount on Node 1: `mount.ocfs2 /dev/mapper/data /cluster/ 
data`  I get this error after about 30 seconds: mount.ocfs2: Transport  
endpoint is not connected while mounting /dev/mapper/data on /cluster/ 
data. Check 'dmesg' for more information on this error.


Here is the output of dmesg:
(3130,1):o2net_connect_expired:1659 ERROR: no connection established  
with node 0 after 30.0 seconds, giving up and returning errors.
(4670,1):dlm_request_join:1033 ERROR: status = -107
(4670,1):dlm_try_to_join_domain:1207 ERROR: status = -107
(4670,1):dlm_join_domain:1485 ERROR: status = -107
(4670,1):dlm_register_domain:1732 ERROR: status = -107
(4670,1):o2cb_cluster_connect:302 ERROR: status = -107
(4670,1):ocfs2_dlm_init:2753 ERROR: status = -107
(4670,1):ocfs2_mount_volume:1274 ERROR: status = -107
ocfs2: Unmounting device (253,2) on (node 0)
(3130,0):o2net_connect_expired:1659 ERROR: no connection established  
with node 0 after 30.0 seconds, giving up and returning errors.
(5558,1):dlm_request_join:1033 ERROR: status = -107
(5558,1):dlm_try_to_join_domain:1207 ERROR: status = -107
(5558,1):dlm_join_domain:1485 ERROR: status = -107
(5558,1):dlm_register_domain:1732 ERROR: status = -107
(5558,1):o2cb_cluster_connect:302 ERROR: status = -107
(5558,1):ocfs2_dlm_init:2753 ERROR: status = -107
(5558,1):ocfs2_mount_volume:1274 ERROR: status = -107
ocfs2: Unmounting device (253,2) on (node 0)


So I figured that It must be a firewall issue. I first disabled  
iptables on both machines and got the same results so I started ip  
talbes adding an exception on both machines: `iptables -A INPUT -p tcp  
--dport 7777 -j ACCEPT ; service iptables save`

The machines can ping each other. and they have the exact same config:
cluster:
	node_count = 2
	name = ocfs2
node:
	ip_port = 7777
	ip_address = 10.128.255.3
	number = 0
	name = m3.c12.jiveip.net
	cluster = ocfs2
node:
	ip_port = 7777
	ip_address = 10.128.7.33
	number = 1
	name = pbx_33.c12.jiveip.net
	cluster = ocfs2


I then decided to use tcpdump to see what's up (on both machines):
`tcpdump -i eth0 port 7777 -v`

Here is a TCP dump showing port 7777 is not blocked (I added an  
exception in IP tables)
(Node 0)
13:13:11.711539 IP (tos 0x0, ttl  64, id 18286, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.47601 > 10.128.255.3.cbt: S,  
cksum 0xd272 (correct), 3820380795:3820380795(0) win 5840 <mss  
1460,sackOK,timestamp 4294911253 0,nop,wscale 6>
13:13:14.710703 IP (tos 0x0, ttl  64, id 18287, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.47601 > 10.128.255.3.cbt: S,  
cksum 0xc6ba (correct), 3820380795:3820380795(0) win 5840 <mss  
1460,sackOK,timestamp 4294914253 0,nop,wscale 6>
13:13:14.711213 IP (tos 0x0, ttl  64, id 2241, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.54763 > 10.128.255.3.cbt: S,  
cksum 0xd2ae (correct), 3862378508:3862378508(0) win 5840 <mss  
1460,sackOK,timestamp 4294914253 0,nop,wscale 6>

(Node 1)
13:13:09.956999 IP (tos 0x0, ttl  64, id 18286, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.47601 > 10.128.255.3.cbt: S,  
cksum 0xd272 (correct), 3820380795:3820380795(0) win 5840 <mss  
1460,sackOK,timestamp 4294911253 0,nop,wscale 6>
13:13:12.956999 IP (tos 0x0, ttl  64, id 18287, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.47601 > 10.128.255.3.cbt: S,  
cksum 0xc6ba (correct), 3820380795:3820380795(0) win 5840 <mss  
1460,sackOK,timestamp 4294914253 0,nop,wscale 6>
13:13:12.956999 IP (tos 0x0, ttl  64, id 2241, offset 0, flags [DF],  
proto: TCP (6), length: 60) 10.128.7.33.54763 > 10.128.255.3.cbt: S,  
cksum 0xd2ae (correct), 3862378508:3862378508(0) win 5840 <mss  
1460,sackOK,timestamp 4294914253 0,nop,wscale 6>
