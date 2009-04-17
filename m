From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:19 -0700
Subject: [Ocfs2-devel] [PATCH 06/26] ocfs2: add IO error check in
	ocfs2_get_sector()
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: wengang wang <wen.gang.wang@oracle.com>

Mainline commit 28d57d437786eb3e44f1ca3f0f41e7cfe29c6dd4

Check for IO error in ocfs2_get_sector().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 535ccb5..5f5cb0f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1203,6 +1203,13 @@ static int ocfs2_get_sector(struct super_block *sb,
 	unlock_buffer(*bh);
 	ll_rw_block(READ, 1, bh);
 	wait_on_buffer(*bh);
+	if (!buffer_uptodate(*bh)) {
+		mlog_errno(-EIO);
+		brelse(*bh);
+		*bh = NULL;
+		return -EIO;
+	}
+
 	return 0;
 }
 
-- 
1.5.6.3
