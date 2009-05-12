From: Oleg Gawriloff <barzog@telecom.by>
Date: Tue, 12 May 2009 14:48:19 +0300
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode() call
Message-ID: <4A096203.2040806@telecom.by>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After upgrading from 2.6.28.10 to 2.6.29.3 I've saw following new errors 
in kernel log:
May 12 14:46:41 falcon-cl5
May 12 14:46:41 falcon-cl5 (6757,7):ocfs2_read_locked_inode:466 ERROR: 
status = -22

Only one node is mounted volumes in cluster:
/dev/sde on /home/apache/users/D1 type ocfs2 
(rw,_netdev,noatime,heartbeat=local)
/dev/sdd on /home/apache/users/D2 type ocfs2 
(rw,_netdev,noatime,heartbeat=local)
/dev/sdc on /home/apache/users/D3 type ocfs2 
(rw,_netdev,noatime,heartbeat=local)
The error appears multiple times per second and only numbers is different.
May 12 14:47:09 falcon-cl5 (6755,6):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 12 14:47:09 falcon-cl5
May 12 14:47:09 falcon-cl5 (6755,2):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 12 14:47:09 falcon-cl5
May 12 14:47:09 falcon-cl5 (6755,1):ocfs2_read_locked_inode:466 ERROR: 
status = -22

What does it means, any suggestions?
