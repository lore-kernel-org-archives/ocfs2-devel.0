From: Chen, Yukun <yukun.chen@intel.com>
Date: Fri Jul 30 10:17:34 2004
Subject: [Ocfs2-devel] 
	System hang issue when access the same dir/file from 2 different
	nodes at the same time
Message-ID: <B44D37711ED29844BEA67908EAF36F037131E5@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All

 

         I met a bug on kernel 2.4.24, rev 1303,bi-node system. Steps to
duplicate(a bug #111 has been reported to the bugzilla of
oss.oracle.com)

 

1.Write to a file(or create files in a dir) on one node for a
while(write to 

 

the file 1000 times or create 1000 files in the dir)

 

2.Write to the same file ( or create files in the same dir) on another
node at 

 

the same time.

 

Then, the system will hang with following error messages

...

(5461) ERROR at vote.c, 921: inode 67643, vote_status=0, vote_state=1,
lockid=34633216, flags = 0x8000, asked type = 5 master = 1, state = 0x0,
type = 5

Jul 27 16:31:06 westvile2 kernel: (2035) ERROR at vote.c, 921: inode
67661, vote_status=0, vote_state=1, lockid=34642432, flags = 0x40000004,
asked type = 5 master = 1, state = 0x0, type = 5

Jul 27 16:31:36 westvile2 kernel: (5461) ERROR at vote.c, 921: inode
67643, vote_status=0, vote_state=1, lockid=34633216, flags = 0x8000,
asked type = 5 master = 1, state = 0x0, type = 5

 

...

 

I have tried net vote and disk vote but get the same error message on
screen.

 

Any ideas on it ?

 

Thanx.

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040730/53bf5c3f/attachment.htm
