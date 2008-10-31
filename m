From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:38:59 +0100
Subject: [Ocfs2-devel] [PATCH 09/27] quota: Remove compatibility function
	sb_any_quota_enabled()
In-Reply-To: <12254351582759-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
Message-ID: <12254351582523-git-send-email-jack@suse.cz>
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
1.5.2.4
