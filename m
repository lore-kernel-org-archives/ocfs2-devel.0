From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Aug  2 04:14:49 2004
Subject: [Ocfs2-devel] Patch to remove the code to zero buffer in
	ocfs_extend_file()completely.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E04D1E0FB@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	After read the code of ocfs_setattr() and
ocfs_alloc_node_block(), I think the new allocated file data block
should be zeroed when the ocfs_extend_file() is called from these 2
routines. 

	So, I changed my solution. In this new patch, the zero data
block is written back immediately only for system file, for the other
files it is marked dirty and written back asynchronously.

	The performance improvement of ocfs_extend_file() for non-system
file is almost the same as the former solution.

	Any suggestion? 
	See the attachment.



-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: Monday, August 02, 2004 10:20 AM
To: Ocfs2-Devel
Subject: [Ocfs2-devel] Patch to remove the code to zero buffer in
ocfs_extend_file()completely.

Hi,

	We found the code to zero buffer in ocfs_extend_file() is
completely unnecessary for both directory creating and file writing. In
kernel routine block_read_full_page(), the unmapped buffer is retrieved
via ocfs_get_block() and set to zero immediately even if it is already
zeroed in the ocfs_extend_file().

	After remove this code, the performance of ocfs_extend_file()
increase greatly.

	So, we suggest remove it. See the attachment.




*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************  

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-skipzerobuf.patch
Type: application/octet-stream
Size: 1237 bytes
Desc: ocfs2-skipzerobuf.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040802/2de6ba75/ocfs2-skipzerobuf.obj
