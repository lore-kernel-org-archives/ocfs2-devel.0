From: Julia Lawall <julia@diku.dk>
Date: Fri, 14 May 2010 19:30:57 -0000
Subject: [Ocfs2-devel] [PATCH 8/10] fs/ocfs2/dlm: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ocfs2/dlm/dlmdomain.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1523,7 +1523,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 		goto leave;
 	}
 
-	dlm->name = kmalloc(strlen(domain) + 1, GFP_KERNEL);
+	dlm->name = kstrdup(domain, GFP_KERNEL);
 	if (dlm->name == NULL) {
 		mlog_errno(-ENOMEM);
 		kfree(dlm);
@@ -1557,7 +1557,6 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	for (i = 0; i < DLM_HASH_BUCKETS; i++)
 		INIT_HLIST_HEAD(dlm_master_hash(dlm, i));
 
-	strcpy(dlm->name, domain);
 	dlm->key = key;
 	dlm->node_num = o2nm_this_node();
 
