From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Sun Aug  1 21:20:24 2004
Subject: [Ocfs2-devel] 
	Patch to remove the code to zero buffer in ocfs_extend_file()
	completely.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E04D1DC67@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
Name: ocfs2-remove-zerobuf.patch
Type: application/octet-stream
Size: 2281 bytes
Desc: ocfs2-remove-zerobuf.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040802/2a4b7901/ocfs2-remove-zerobuf.obj
