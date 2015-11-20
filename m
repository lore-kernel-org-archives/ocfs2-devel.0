From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 20 Nov 2015 11:00:38 +0000
Subject: [Ocfs2-devel] File system is read-only review
Message-ID: <2015112019003413274371@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


File system is read-only when deleting the inode, So I try fsck.ocfs2 -f and success,
Anybody ever see this, how to avoid this, Thanks

Nov 18 11:04:30 cvk110 kernel: [144411.362978] OCFS2: ERROR (device dm-2): ocfs2_commit_truncate: Inode 24772873 has empty extent block at 24772873
Nov 18 11:04:30 cvk110 kernel: [144411.362978]
Nov 18 11:04:30 cvk110 kernel: [144411.362986] File system is now read-only due to the potential of on-disk corruption. Please run fsck.ocfs2 once the file system is unmounted.
Nov 18 11:04:30 cvk110 kernel: [144411.362991] (kworker/u129:0,32928,0):ocfs2_truncate_for_delete:574 ERROR: status = -30
Nov 18 11:04:30 cvk110 kernel: [144411.362993] (kworker/u129:0,32928,0):ocfs2_wipe_inode:743 ERROR: status = -30
Nov 18 11:04:30 cvk110 kernel: [144411.362996] (kworker/u129:0,32928,0):ocfs2_delete_inode:1022 ERROR: status = -30
Nov 18 11:04:30 cvk110 kernel: [144411.434249] OCFS2: ERROR (device dm-2): ocfs2_commit_truncate: Inode 1445125 has empty extent block at 1445125
Nov 18 11:04:30 cvk110 kernel: [144411.434249]
Nov 18 11:04:30 cvk110 kernel: [144411.434256] (kworker/u129:0,32928,1):ocfs2_truncate_for_delete:574 ERROR: status = -30
Nov 18 11:04:30 cvk110 kernel: [144411.434258] (kworker/u129:0,32928,1):ocfs2_wipe_inode:743 ERROR: status = -30
Nov 18 11:04:30 cvk110 kernel: [144411.434261] (kworker/u129:0,32928,1):ocfs2_delete_inode:1022 ERROR: status = -30
________________________________
zhangguanghui
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151120/2a70eeb5/attachment.html 
