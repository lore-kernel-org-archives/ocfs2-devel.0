From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Mar 11 01:59:11 2004
Subject: [Ocfs2-devel] 
	FW: A patch to remove compile warnings and errors if enable memory
	debugging(OCFS_LINUX_MEM_DEBUG).
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E5A30DD@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi,

	If I turn on memory debugging by "configure --enable-memdebug",
the make process fails. So I revised several code lines in file ocfs.h
and proc.c and generate this patch file.

	Could you please take a look at this patch and tell me if it is
suitable to be applied to the source tree.

	Thank you.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-enable-memdebug.patch
Type: application/octet-stream
Size: 1308 bytes
Desc: ocfs2-enable-memdebug.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040311/d12d8d87/ocfs2-enable-memdebug.obj
