From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Wed Apr  7 04:24:52 2004
Subject: [Ocfs2-devel] 
	Fail to mount an OCFS volume for the second time under kernel 2.6.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E51@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
