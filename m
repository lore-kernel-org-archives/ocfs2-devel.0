From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Wed Apr 14 11:27:05 2004
Subject: [Ocfs2-devel] Fail to mount an OCFS volume for
	thesecondtimeunderkernel 2.6.
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E03EA03C6@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There seems to be more to this bug that I can't totally get my hands around.  For the longest time I could not reproduce this bug, and then a few days ago I started seeing it again on both of my test machines, and now (after toggling various kernel hacker options) I can no longer reproduce the bug (using the exact same code base.)

Sonic, when you get in tonight (your morning) log on to IRC and lets try nail this thing down.  I suspect (a gut feeling really) that we have bigger problem that the 2.6 debug code (maybe the stack checking or alloc checking options) has done something to trigger the crash (like the alloc debugging code has poisoned memory that we shouldn't be touching, but we are.) 

    --rusty

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: Wednesday, April 14, 2004 2:35 AM
To: Ocfs2-Devel
Subject: RE: [Ocfs2-devel] Fail to mount an OCFS volume for thesecondtimeunderkernel 2.6.

Hi,

	After changing the journal creation code under kernel 2.4 and 2.6. I think the second mount bug of OCFS2 is caused in function ocfs_journal_create(), which call Linux Journaling function journal_create(). I guess this bug is actually in JBD code of the kernel 2.6.

Steps:
1. Leave the ocfs_journal_create() code and remove the ocfs_journal_update_config() code in routine ocfs_check_volume() when mount a ocfs volume for the first time under kernel 2.4. 
2. Remove the ocfs_journal_create() code and leave the ocfs_journal_update_config() code in routine ocfs_check_volume() when redo the first mount under kernel 2.6. These 2 operations work together to complete the first mount successfully. 
3. Mount the ocfs volume for the second time under kernel 2.6. It completes successfully. That means the bug is in routine ocfs_journal_create().


	Do you have any idea?
	Thanks


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004?4?12? 15:50
To: Ocfs2-Devel
Subject: RE: [Ocfs2-devel] Fail to mount an OCFS volume for thesecondtimeunder kernel 2.6.

Hi,

	I checked some original svn versions of the OCFS2 source code, rev.810, 815, 818, 819, 820, 821 and 823. All versions have the same bug under kernel 2.6 as the latest version.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004?4?9? 17:36
To: Ocfs2-Devel
Subject: RE: [Ocfs2-devel] Fail to mount an OCFS volume for the secondtimeunder kernel 2.6.

Hi,

	I tried to mount the OCFS volume under kernel 2.4 first. Then, turn to kernel 2.6 and mount for the second time. The OCFS driver under kernel 2.6 works well in this cases. It seems the bug is in the journal creation code which is used during the first mount operation. But, I fail to locate which code caused the different behavior between kernel 2.6 and 2.4 by now. 

	Do you have any opinions?

	Thank you.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004?4?8? 13:40
To: Ocfs2-Devel
Subject: RE: [Ocfs2-devel] Fail to mount an OCFS volume for the second timeunder kernel 2.6.

Hi,

	I checked this bug on kernel 2.4. It doesn't occur.
	So, this bug is related to kernel 2.6 porting.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004?4?7? 17:25
To: Ocfs2-Devel
Subject: [Ocfs2-devel] Fail to mount an OCFS volume for the second time under kernel 2.6.

Hi,

	After check out the latest svn source, I found I fail to mount
an OCFS volume for the second time under kernel 2.6. The system will
halt if I do so. But, I remember I did it successfully in the former
version. I submitted it into the bugzilla.

See following details.

Steps:
1. create ocfs volume.
2. mount this volume.
3. umount this volume.
4. mount this volume again.

Results:
System halt with error information.
JBD: no valid journal superblock found
(1342) ERROR: status=-22, fs/ocfs2/osb.c, 407
(1342) ERROR: status=-22, fs/ocfs2/super.c, 1032


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
