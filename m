From: Chen, Yukun <yukun.chen@intel.com>
Date: Mon Jun 14 04:46:40 2004
Subject: [Ocfs2-devel] 
	System hang when delete file on the same dir from different node
	simultaneously
Message-ID: <B44D37711ED29844BEA67908EAF36F0315E236@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

   On kernel 2.4, I meet a system hang when delete file from different
node. Steps to duplicate

 

Node A

   1. load_ocfs2 mkfs.ocfs2 mount (/dev/sdc2 to /ocfs)

   2. create /ocfs/testdir

   3. create 1000 files(prefix of filename is FILE1) in /ocfs/testdir

    

Node B

   1. load_ocfs2 mkfs.ocfs2 mount (/dev/sdc2 to /ocfs)

   2. create /ocfs/testdir

   3. create 1000 files(prefix of filename is FILE2) in /ocfs/testdir 

 

Then delete such files whose prefixes are FILE1 on Node A and FILE2 on
Node B simultaneously. I get a system hang with error message from dmesg
as follows:

 

***************************************

(9932) ERROR at dlm.c, 1313: DISKVOTE!!: req_lock=2, flags=40001401,
offset=36237312, inode=36237312

(9932) ERROR at dlm.c, 1316: DISKVOTE!!: this=0, master=1, locktype=8,
ronode=-1, romap=00000000

Call Trace: 

.....

[<da225e0c>]   (0xda225e0c)

[<c0109b9f>]   (0xda225fc0)

......

 

(9932) ERROR at dlm.c, 1313: DISKVOTE!!: req_lock=2, flags=40001401,
offset=36237312, inode=36237312

(9932) ERROR at dlm.c, 1316: DISKVOTE!!: this=0, master=1, locktype=8,
ronode=-1, romap=00000000

Call Trace: 

[<da225e0c>]   (0xda225e0c)

[<c0109b9f>]   (0xda225fc0)

.....

 

(2) ocfs_process_vote: RELEASE request for lockid: 41586176, action: (3)
DELETE_RENAME_RELEASE, type: disk vote

(2) vote: lockid=41586176, node=1, seqnum=1760, response=1,
open_handle=no

(2) ocfs_process_vote: ACQUIRE request for lockid: 41485312, action: (2)
DELETE_RENAME_ACQUIRE, type: net vote

verifyupdate: setting nlink from 1 to 1 for 41485312

(2) vote: lockid=41485312, node=1, seqnum=242, response=1,
open_handle=no

<3>(9932) ERROR at dlm.c, 1313: DISKVOTE!!: req_lock=2, flags=40001401,
offset=36237312, inode=36237312

(9932) ERROR at dlm.c, 1316: DISKVOTE!!: this=0, master=1, locktype=8,
ronode=-1, romap=00000000

Call Trace: 

[<da225e0c>]   (0xda225e0c)

[<c0109b9f>]   (0xda225fc0)

......

 

(9932) ERROR at dlm.c, 1313: DISKVOTE!!: req_lock=2, flags=40001401,
offset=36237312, inode=36237312

(9932) ERROR at dlm.c, 1316: DISKVOTE!!: this=0, master=1, locktype=8,
ronode=-1, romap=00000000

Call Trace: 

[<da225e0c>]   (0xda225e0c)

[<c0109b9f>]   (0xda225fc0)

......

***********************************************

 

Any ideas for it?

 

Thanx.

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040614/59f8b033/attachment-0001.htm
