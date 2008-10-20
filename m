From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:42 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Remove compatibility function
	sb_any_quota_enabled()
In-Reply-To: y
References: y
Message-ID: <12245234411124-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quotaops.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f7dcc30..94f00ec 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -119,9 +119,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	       sb_has_quota_active(sb, GRPQUOTA);
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * Operations supported for diskquotas.
  */
@@ -265,9 +262,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	return 0;
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * NO-OP when quota not configured.
  */
-- 
1.5.2.4
