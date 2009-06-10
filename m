From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 11 Jun 2009 05:03:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Prevent mount with "-o acl" if acl
	isn't supported.
Message-ID: <1244667835-16907-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, if we don't enable CONFIG_OCFS2_FS_POSIX_ACL, ocfs2
will not support acl. That is OK.

But in the following case:
1. kernel isn't built to support acl.
2. mount -t ocfs2 -o acl /dev/sdx /mnt/ocfs2.
It sucesses. And what's more, if I do "mount|grep sdx" will get
/dev/sdx on /mnt/ocfs2 type ocfs2 (rw,acl,heartbeat=none)

So a normal user will just think acl now is ok for the volume and
he will surely be puzzled when he tries setfacl and fails with
"Operation not supported".

The good thing is that the kernel already printk some useful
information, so this patch just tries to prevent the user from
mounting the volume.

Cc: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 035af49..f570a24 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1206,7 +1206,8 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_acl:
 		case Opt_noacl:
 			printk(KERN_INFO "ocfs2 (no)acl options not supported\n");
-			break;
+			status = 0;
+			goto bail;
 #endif
 		default:
 			mlog(ML_ERROR,
-- 
1.5.5
