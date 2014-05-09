From: George Spelvin <linux@horizon.com>
Date: 9 May 2014 18:45:08 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove some redundant casting
Message-ID: <20140509224508.27912.qmail@ns.horizon.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are two standard techniques for dereferencing structures pointed
to by void *: cast to the right type each time they're used, or assign
to local variables of the right type.

But there's no need to do *both*.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Obviously, this makes zero difference to the generated code, but
it's prettier.


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6ba4bcbc47..714e53b9cc 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1408,10 +1408,9 @@ static void swap_refcount_rec(void *a, void *b, int size)
 {
 	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
 
-	tmp = *(struct ocfs2_refcount_rec *)l;
-	*(struct ocfs2_refcount_rec *)l =
-			*(struct ocfs2_refcount_rec *)r;
-	*(struct ocfs2_refcount_rec *)r = tmp;
+	tmp = *l;
+	*l = *r;
+	*r = tmp;
 }
 
 /*
