From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Jul 2009 16:07:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/quota: Release lock for error in
	ocfs2_quota_write.
Message-ID: <1248941230-9113-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_quota_write needs to release the lock if it fails to
read quota block. So use "goto out" instead of "return err".

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index edfa60c..e1c40e3 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -234,7 +234,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	}
 	if (err) {
 		mlog_errno(err);
-		return err;
+		goto out;
 	}
 	lock_buffer(bh);
 	if (new)
-- 
1.6.0.4
