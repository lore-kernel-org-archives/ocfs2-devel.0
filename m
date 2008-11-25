From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:26 +0100
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Add missing initialization
In-Reply-To: <y>
References: <y>
Message-ID: <1227623495-16708-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add missing variable initialization to ocfs2_dquot_drop_slow().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d2a5bfa..7f561e4 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -873,7 +873,7 @@ out:
 
 static int ocfs2_dquot_drop_slow(struct inode *inode)
 {
-	int status;
+	int status = 0;
 	int cnt;
 	int got_lock[MAXQUOTAS] = {0, 0};
 	handle_t *handle;
-- 
1.6.0.4
