From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu May 20 18:30:45 2004
Subject: [Ocfs2-devel] 
	[IA64] Dead lock is found in OCSF2 (svn 929) on IPF under kernel
	2.6.6.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65EC8@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	After I mount ocfs2 volume successfully on IPF, I fail to copy
files and create folders because of some dead lock problems. I submitted
the issues as OCFS2 bug 73 and 74. The dead locks cause these file
system operations stop in kernel journaling code.

	Please refer to the bugzilla for details.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=73
http://oss.oracle.com/bugzilla/show_bug.cgi?id=74


In addition, bug 72 is invalidated, because I made a mistake to format
the volume in OCFS v1 format. But, the driver should exit in a polite
manner even in this case.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
