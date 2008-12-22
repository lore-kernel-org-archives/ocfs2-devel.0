From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:50 -0800
Subject: [Ocfs2-devel] [PATCH 09/56] quota: Remove compatibility function
	sb_any_quota_enabled()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-10-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/quotaops.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 3b3346f..e840ca5 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -116,9 +116,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	       sb_has_quota_active(sb, GRPQUOTA);
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * Operations supported for diskquotas.
  */
@@ -267,9 +264,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	return 0;
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * NO-OP when quota not configured.
  */
-- 
1.5.6
