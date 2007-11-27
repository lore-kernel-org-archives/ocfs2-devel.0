From: Tao Ma <tao.ma@oracle.com>
Date: Tue Nov 27 00:12:50 2007
Subject: [Ocfs2-devel] [PATCH 1/3] Add online resize support for ocfs2,
	take 2
Message-ID: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Modification from V1 to V2:
Divide the whole processes into 2 steps like ext3.
1) If the last group isn't full, tunefs.ocfs2 will call
   OCFS2_IOC_GROUP_EXTEND first to extend it. All the main work is
   done in kernel.
2) For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
   to add them one by one. The new group descriptor is initialized
   in userspace, we only check it in the kernel and update the
   global_bitap, super blocks etc.

User can do offline resize using tunefs.ocfs2 when a volume isn't
mounted. Now the support for online resize is added into ocfs2.

Please note that the node where online resize goes must already
has the volume mounted. We don't mount it behind the user and the
operation would fail if we find it isn't mounted. As for other
nodes, we don't care whether the volume is mounted or not.

global_bitmap, super block and all the backups will be updated
in the kernel. And if super block or backup's update fails, we
just output some error message in dmesg and continue the work.
