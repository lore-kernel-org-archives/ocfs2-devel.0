From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue May 25 04:17:49 2004
Subject: [Ocfs2-devel] 
	Hang issue when change the dir attribute in a cluster enviornment 
Message-ID: <941A6821ACE16D4BBB8A958A0EB047F7388A0D@pdsmsx404.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All

         On kernel 2.6.6, I get a system hang when change dir attribute.
Steps to reproduce:

         On node 1:

1.       mount to /ocfs2

2.       create dir /ocfs2/foo in mode 0666

 

On node 2:

1.       mount to /ocfs2

2.       chmod 0766 /ocfs2/foo

 

Then, get a system hang on node 2. The error log is as follows:

Oracle Cluster FileSystem x y (build z)
ocfs2: hostname is westvile2
sectbits=9, clusterbits=12, dirbits=17, filebits=9
ocfs2: Adding west1 (node 0) to clustered device (8,34)
(3356) ERROR at /root/ocfs/ocfs2/src/dlm.c, 1395: DISKVOTE!!:
req_lock=2, flags=40000401, offset=1532416, inode=3
(3356) ERROR at /root/ocfs/ocfs2/src/dlm.c, 1398: DISKVOTE!!: this=1,
master=0, locktype=0, ronode=-1, romap=00000000
Call Trace: 
[<dd189bf4>]   (0xdd189bf4)
[<ffffffff>]   (0xdd189c04)
..........

JBD: Ignoring recovery information on journal
(fs/jbd/recovery.c, 302): journal_skip_recovery: JBD: ignoring 0
transactions from the journal.
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status 0,
recovered transactions 1 to 1
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 0 and revoked
0/0 blocks
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (8,34) on west2 (node 1)
 

It seems there is a lock error when change the dir attribute. Any idea
on it?

Thanx.

Bstr,.rgds

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040525/736d9dad/attachment.htm
