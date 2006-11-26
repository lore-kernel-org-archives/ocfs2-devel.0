From: Tiger Yang <tiger.yang@oracle.com>
Date: Sun Nov 26 17:59:28 2006
Subject: [Ocfs2-devel] implement i_op->permission in ocfs2
Message-ID: <456A4679.8060203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch implement .permission() in ocfs2_file_iops, 
ocfs2_special_file_iops and ocfs2_dir_iops.

thanks,
tiger
-------------- next part --------------
A non-text attachment was scrubbed...
Name: permission.patch
Type: text/x-patch
Size: 1875 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20061127/35945c14/permission.bin
