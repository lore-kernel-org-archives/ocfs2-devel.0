From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Apr  9 04:36:05 2004
Subject: [Ocfs2-devel] Fail to mount an OCFS volume for the second
	timeunder kernel 2.6.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E59@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	I tried to mount the OCFS volume under kernel 2.4 first. Then, turn to =
kernel 2.6 and mount for the second time. The OCFS driver under kernel =
2.6 works well in this cases. It seems the bug is in the journal =
creation code which is used during the first mount operation. But, I =
fail to locate which code caused the different behavior between kernel =
2.6 and 2.4 by now.=20

	Do you have any opinions?

	Thank you.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com =
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004=C4=EA4=D4=C28=C8=D5 13:40
To: Ocfs2-Devel
Subject: RE: [Ocfs2-devel] Fail to mount an OCFS volume for the second =
timeunder kernel 2.6.

Hi,

	I checked this bug on kernel 2.4. It doesn't occur.
	So, this bug is related to kernel 2.6 porting.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com =
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004=C4=EA4=D4=C27=C8=D5 17:25
To: Ocfs2-Devel
Subject: [Ocfs2-devel] Fail to mount an OCFS volume for the second time =
under kernel 2.6.

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
(1342) ERROR: status=3D-22, fs/ocfs2/osb.c, 407
(1342) ERROR: status=3D-22, fs/ocfs2/super.c, 1032


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
