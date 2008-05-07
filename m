From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 May 2008 14:48:25 +0800
Subject: [Ocfs2-devel] [PATCH]ocfs2-1.2: Add dput for uuid entry.
Message-ID: <482150B9.3030002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2-1.2, when we mount a device, a debugfs dir will be created 
using its uuid. When 2 devices have the same uuid, after the 1st device 
is mounted, the 2nd one can't be mounted. This is OK. But the problem is 
that the dentry's reference is added. So when the 1st volume is 
umounted, none of these 2 volumes can be mounted then. So this fix 
solves this problem by dputting the entry(Copied from the latest debugfs 
code in Linux kernel).
-------------- next part --------------
A non-text attachment was scrubbed...
Name: debugfs.patch
Type: text/x-patch
Size: 446 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080507/ffa93e59/attachment.bin 
