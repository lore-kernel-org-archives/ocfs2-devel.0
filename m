From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Mar  2 03:02:04 2004
Subject: [Ocfs2-devel] 
	unknown symbol mark_buffer_clean found when compile OCFSv2 under
	kernel 2.6.0
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi Rusty and Mark,

	I checked out the latest source code from the svn tree. And I
also compile the source code under kernel 2.6 successfully with Rusty's
makefile.	But I failed to insert the ocfs2 module into the kernel
2.6.

My operation:
[host1]> insmod ocfs2.o node_name=westvile2 ip_address=192.168.1.14
cs=1793 guid=6B359212647D8D256E190007E903E0ED
ocfs2: Unknown symbol mark_buffer_clean
Error inserting 'ocfs2.o': -1 Unknown symbol in module

	Routine mark_buffer_clean exits in file include/linux/fs.h of
kernel 2.4.x, but it is removed in kernel 2.6.x. 

	Thanks.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
