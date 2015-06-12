From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 12 Jun 2015 18:59:05 +0200
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: use swap() in
	swap_refcount_rec()
Message-ID: <1434128346-10521-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/refcounttree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6f66268..c8e1dce 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1402,11 +1402,9 @@ static int cmp_refcount_rec_by_cpos(const void *a, const void *b)
 
 static void swap_refcount_rec(void *a, void *b, int size)
 {
-	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
+	struct ocfs2_refcount_rec *l = a, *r = b;
 
-	tmp = *l;
-	*l = *r;
-	*r = tmp;
+	swap(*l, *r);
 }
 
 /*
-- 
2.4.2
