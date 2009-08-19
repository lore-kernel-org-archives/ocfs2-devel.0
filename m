From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 19 Aug 2009 15:16:01 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: __ocfs2_abort() should not enable
	panic for local mounts
Message-ID: <1250720161-29360-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a clustered setup, we have to panic the box on journal abort. This is
because we don't have the facility to go hard readonly. With hard ro, another
node would detect node failure and initiate recovery.

Having said that, we shouldn't force panic if the volume is mounted locally.
This patch defers the handling to the mount option, errors.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b0ee0fd..44a0388 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2486,7 +2486,8 @@ void __ocfs2_abort(struct super_block* sb,
 	/* Force a panic(). This stinks, but it's better than letting
 	 * things continue without having a proper hard readonly
 	 * here. */
-	OCFS2_SB(sb)->s_mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
+	if (!ocfs2_mount_local(OCFS2_SB(sb)))
+		OCFS2_SB(sb)->s_mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
 	ocfs2_handle_error(sb);
 }
 
-- 
1.6.0.4
