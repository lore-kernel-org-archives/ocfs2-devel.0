From: Mark Fasheh <mfasheh@suse.com>
Date: Tue,  9 Mar 2010 18:29:08 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: allocate btree internal block
	groups from the global bitmap
In-Reply-To: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
References: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
Message-ID: <1268188148-5253-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Otherwise, the need for a very large contiguous allocation tends to
wreak havoc on many inode allocation reservations on the local alloc, thus
ruining any chances for contiguousness.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/suballoc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 7b76926..62c570c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -659,7 +659,8 @@ int ocfs2_reserve_new_metadata_blocks(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
 					     EXTENT_ALLOC_SYSTEM_INODE,
-					     slot, NULL, ALLOC_NEW_GROUP);
+					     slot, NULL,
+					     ALLOC_GROUPS_FROM_GLOBAL|ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -1821,6 +1822,8 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 	       && ac->ac_which != OCFS2_AC_USE_MAIN);
 
 	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
+		WARN_ON(min_clusters > 1);
+
 		status = ocfs2_claim_local_alloc_bits(osb,
 						      handle,
 						      ac,
-- 
1.6.4.2
