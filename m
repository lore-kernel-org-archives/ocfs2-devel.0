From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 12 May 2009 16:37:48 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode() call
In-Reply-To: <4A096203.2040806@telecom.by>
References: <4A096203.2040806@telecom.by>
Message-ID: <4A0A084C.4040402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Oleg Gawriloff wrote:
> After upgrading from 2.6.28.10 to 2.6.29.3 I've saw following new errors 
> in kernel log:
> May 12 14:46:41 falcon-cl5
> May 12 14:46:41 falcon-cl5 (6757,7):ocfs2_read_locked_inode:466 ERROR: 
> status = -22
>
> Only one node is mounted volumes in cluster:
> /dev/sde on /home/apache/users/D1 type ocfs2 
> (rw,_netdev,noatime,heartbeat=local)
> /dev/sdd on /home/apache/users/D2 type ocfs2 
> (rw,_netdev,noatime,heartbeat=local)
> /dev/sdc on /home/apache/users/D3 type ocfs2 
> (rw,_netdev,noatime,heartbeat=local)
> The error appears multiple times per second and only numbers is different.
> May 12 14:47:09 falcon-cl5 (6755,6):ocfs2_read_locked_inode:466 ERROR: 
> status = -22
> May 12 14:47:09 falcon-cl5
> May 12 14:47:09 falcon-cl5 (6755,2):ocfs2_read_locked_inode:466 ERROR: 
> status = -22
> May 12 14:47:09 falcon-cl5
> May 12 14:47:09 falcon-cl5 (6755,1):ocfs2_read_locked_inode:466 ERROR: 
> status = -22
>
> What does it means, any suggestions?

I went thru the relevant code in 2.6.29-3. There has to be another
message. That is, other than the one listed.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=blob;f=fs/ocfs2/inode.c;h=229e707bc050629c0ad372b14c75194bf4b97f3d;hb=e18346d68f807c62bb8e5de0f809d3a1a2f093de

Did you modify the code? Apply some patches?
