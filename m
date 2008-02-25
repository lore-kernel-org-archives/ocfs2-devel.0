From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:18 2008
Subject: [Ocfs2-devel] [PATCH 01/18] ocfs2_dlm: Rename slabcache
	dlm_mle_cache to o2dlm_mle
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch renames dlm_mle_slabcache to prevent namespace
clashes with fs/dlm.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |    4 +++-
 fs/ocfs2/dlm/dlmmaster.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 1d854d5..502712b 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1648,8 +1648,10 @@ static int __init dlm_init(void)
 	dlm_print_version();
 
 	status = dlm_init_mle_cache();
-	if (status)
+	if (status) {
+		mlog(ML_ERROR, "Could not create o2dlm_mle slabcache\n");
 		return -1;
+	}
 
 	status = dlm_register_net_handlers();
 	if (status) {
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 42ea5af..cc4e624 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -506,7 +506,7 @@ static void dlm_mle_node_up(struct dlm_ctxt *dlm,
 
 int dlm_init_mle_cache(void)
 {
-	dlm_mle_cache = kapi_kmem_cache_create("dlm_mle_cache",
+	dlm_mle_cache = kapi_kmem_cache_create("o2dlm_mle",
 					  sizeof(struct dlm_master_list_entry),
 					  0, SLAB_HWCACHE_ALIGN,
 					  NULL);
-- 
1.5.2.5
