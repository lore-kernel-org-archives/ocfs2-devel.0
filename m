From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Jul 2009 19:14:23 +0200
Subject: [Ocfs2-devel] [PATCH 8/9] Change headers to reflect that quota is
	now fully supported.
In-Reply-To: <1248974064-29462-1-git-send-email-jack@suse.cz>
References: <1248974064-29462-1-git-send-email-jack@suse.cz>
Message-ID: <1248974064-29462-9-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2-kernel/ocfs2_fs.h |    4 +++-
 libocfs2/feature_string.c       |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
index f3c9b53..1650315 100644
--- a/include/ocfs2-kernel/ocfs2_fs.h
+++ b/include/ocfs2-kernel/ocfs2_fs.h
@@ -96,7 +96,9 @@
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR)
-#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
+#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
+					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
diff --git a/libocfs2/feature_string.c b/libocfs2/feature_string.c
index 18ae6e9..cf3a0dd 100644
--- a/libocfs2/feature_string.c
+++ b/libocfs2/feature_string.c
@@ -76,7 +76,9 @@ static ocfs2_fs_options feature_level_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_INLINE_DATA |
 	 OCFS2_FEATURE_INCOMPAT_META_ECC |
 	 OCFS2_FEATURE_INCOMPAT_XATTR,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN}, /* OCFS2_FEATURE_LEVEL_MAX_FEATURES */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_USRQUOTA |
+	 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA }, /* OCFS2_FEATURE_LEVEL_MAX_FEATURES */
 };
 
 /* These are the features we support in mkfs/tunefs via --fs-features */
-- 
1.6.0.2
