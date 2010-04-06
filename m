From: Mark Fasheh <mfasheh@suse.com>
Date: Mon,  5 Apr 2010 18:17:13 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: clean up localalloc mount option
	size parsing
In-Reply-To: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
References: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
Message-ID: <1270516636-12180-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch pulls the local alloc sizing code into localalloc.c and provides
a callout to it from ocfs2_fill_super(). Behavior is essentially unchanged
except that I correctly calculate the maximum local alloc size. The old code
in ocfs2_parse_options() calculated the max size as:

ocfs2_local_alloc_size(sb) * 8

which is correct, in bits. Unfortunately though the option passed in is in
megabytes. Ultimately, this bug made no real difference - the shrink code
would catch a too-large size and bring it down to something reasonable.
Still, it's less than efficient as-is.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |   28 ++++++++++++++++++++++++++++
 fs/ocfs2/localalloc.h |    2 ++
 fs/ocfs2/ocfs2.h      |    6 ++++++
 fs/ocfs2/super.c      |   10 +++++-----
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 18fc176..9dc34a6 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -75,6 +75,34 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 					  struct inode *local_alloc_inode);
 
+void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
+{
+	struct super_block *sb = osb->sb;
+	unsigned int la_default_mb = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
+	unsigned int la_max_mb;
+
+	la_max_mb = ocfs2_clusters_to_megabytes(sb,
+						ocfs2_local_alloc_size(sb) * 8);
+
+	mlog(0, "requested: %dM, max: %uM, default: %uM\n",
+	     requested_mb, la_max_mb, la_default_mb);
+
+	if (requested_mb == -1) {
+		/* No user request - use defaults */
+		osb->local_alloc_default_bits =
+			ocfs2_megabytes_to_clusters(sb, la_default_mb);
+	} else if (requested_mb > la_max_mb) {
+		/* Request is too big, we give the maximum available */
+		osb->local_alloc_default_bits =
+			ocfs2_megabytes_to_clusters(sb, la_max_mb);
+	} else {
+		osb->local_alloc_default_bits =
+			ocfs2_megabytes_to_clusters(sb, requested_mb);
+	}
+
+	osb->local_alloc_bits = osb->local_alloc_default_bits;
+}
+
 static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
 {
 	return (osb->local_alloc_state == OCFS2_LA_THROTTLED ||
diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
index ac5ea9f..04195c6 100644
--- a/fs/ocfs2/localalloc.h
+++ b/fs/ocfs2/localalloc.h
@@ -30,6 +30,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb);
 
 void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb);
 
+void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb);
+
 int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 				     int node_num,
 				     struct ocfs2_dinode **alloc_copy);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 4a6f00e..44b95a9 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -765,6 +765,12 @@ static inline unsigned int ocfs2_megabytes_to_clusters(struct super_block *sb,
 	return megs << (20 - OCFS2_SB(sb)->s_clustersize_bits);
 }
 
+static inline unsigned int ocfs2_clusters_to_megabytes(struct super_block *sb,
+						       unsigned int clusters)
+{
+	return clusters >> (20 - OCFS2_SB(sb)->s_clustersize_bits);
+}
+
 static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
 {
 	spin_lock(&osb->osb_lock);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index db354d1..6dfcb4e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -93,7 +93,7 @@ struct mount_options
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
 	signed short	slot;
-	unsigned int	localalloc_opt;
+	int		localalloc_opt;
 	unsigned int	resv_level;
 	char		cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
 };
@@ -1027,8 +1027,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
 	osb->osb_commit_interval = parsed_options.commit_interval;
-	osb->local_alloc_default_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
-	osb->local_alloc_bits = osb->local_alloc_default_bits;
+
+	ocfs2_la_set_sizes(osb, parsed_options.localalloc_opt);
 	osb->osb_resv_level = parsed_options.resv_level;
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
@@ -1288,7 +1288,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->mount_opt = 0;
 	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 	mopt->slot = OCFS2_INVALID_SLOT;
-	mopt->localalloc_opt = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
+	mopt->localalloc_opt = -1;
 	mopt->cluster_stack[0] = '\0';
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 
@@ -1381,7 +1381,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 				status = 0;
 				goto bail;
 			}
-			if (option >= 0 && (option <= ocfs2_local_alloc_size(sb) * 8))
+			if (option >= 0)
 				mopt->localalloc_opt = option;
 			break;
 		case Opt_localflocks:
-- 
1.6.4.2
