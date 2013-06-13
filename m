From: Harsha A Patankar <harsha.patankar@gmail.com>
Date: Thu, 13 Jun 2013 14:02:35 -0000
Subject: [Ocfs2-devel] Error: ocfs2_controld: Unable to open checkpoint
 "ocfs2:controld": Object does not exist
Message-ID: <CAPvr0qY2j7tr9wmBiSvHjPq90jyHC45gnLdv1xECCZf19iq3qg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

      We are facing error " ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist"

Please let me know, if I'm missing anything to configure or is there
something that need to be set.

cat /etc/ocfs2/cluster.conf
node:
        ip_port = 7700
        ip_address = 192.168.16.1
        number = 0
        name = MC0
        cluster = pacemaker

node:
        ip_port = 7700
        ip_address = 192.168.16.2
        number = 1
        name = MC1
        cluster = pacemaker

cluster:
        node_count = 2
        name = pacemaker


Snapshot of logs:

-----------------

Jun  7 12:18:08 MC1 lrmd: [1756]: info: RA output: (p_o2cb:1:start:stderr)
2013/06/07_12:18:08 INFO: Starting p_o2cb:1

Jun  7 12:18:08 MC1 kernel: : [   44.941275] ocfs2: Registered cluster
interface user

Jun  7 12:18:08 MC1 kernel: : [   44.951775] OCFS2 Node Manager 1.5.0

Jun  7 12:18:08 MC1 kernel: : [   44.962922] OCFS2 1.5.0

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: get_cluster_type: Cluster
type is: 'openais'

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info:
init_ais_connection_classic: Creating connection to our Corosync plugin

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info:
init_ais_connection_classic: AIS connection established

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: get_ais_nodeid: Server
details: id=420002 uname=MC1 cname=pcmk

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: init_ais_connection_once:
Connection to 'classic openais (with plugin)': established

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_new_peer: Node MC1
now has id: 420002

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_new_peer: Node 420002
is now known as MC1

Jun  7 12:18:08 MC1 corosync[1719]:   [pcmk  ] info: pcmk_notify: Enabling
node notifications for child 2871 (0x8c05e0)

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: notice: ais_dispatch_message:
Membership 16: quorum acquired

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_new_peer: Node MC0
now has id: 420001

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_new_peer: Node 420001
is now known as MC0

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_update_peer: Node
MC0: id=420001 state=member (new) addr=r(0) ip(192.168.16.1)  votes=1
born=4 seen=16 proc=00000000000000000000000000000000

Jun  7 12:18:08 MC1 ocfs2_controld: [2871]: info: crm_update_peer: Node
MC1: id=420002 state=member (new) addr=r(0) ip(192.168.16.2)  (new) votes=1
(new) born=16 seen=16 proc=0000000000000000000

0000000000000

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Attempted to read the cluster's
protocol versions 1 times, still trying

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Attempted to read the cluster's
protocol versions 2 times, still trying

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Attempted to read the cluster's
protocol versions 4 times, still trying

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Attempted to read the cluster's
protocol versions 8 times, still trying

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist

Jun  7 12:18:08 MC1 ocfs2_controld: Unable to open checkpoint
"ocfs2:controld": Object does not exist





regards,

Harsha
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130613/86c2231c/attachment-0001.html 
