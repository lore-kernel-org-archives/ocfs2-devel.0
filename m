From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Dec 2008 18:13:49 -0800
Subject: [Ocfs2-devel] [PATCH 12/13] ocfs2: Move buckets up
	into	ocfs2_add_new_xattr_bucket().
In-Reply-To: <1227744386-10502-13-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-13-git-send-email-joel.becker@oracle.com>
Message-ID: <20081211021349.GJ21455@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 26, 2008 at 04:06:25PM -0800, Joel Becker wrote:
> Lift the buckets from ocfs2_add_new_xattr_cluster() up into
> ocfs2_add_new_xattr_bucket().  Now ocfs2_add_new_xattr_cluster()
> doesn't deal with buffer_heads.  In fact, we no longer have to play
> get_bh() tricks at all.

	Tristan found a bug here, filed as
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1057.
Here's the fix, attached to the bugzilla entry.  I will be rebasing my
tree to include this in the original patch (the xattr-buckets-2 branch).

From 61d88e85c741430c15e4176abc99a5cf11435ff2 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 10 Dec 2008 14:11:34 -0800
Subject: [PATCH] ocfs2: Don't free buckets in ocfs2_add_new_xattr_cluster()

When I moved the buckets to the parent of ocfs2_add_new_xattr_cluster(),
I forgot to remove the ocfs2_xattr_bucket_free() calls at the bottom.
This causes garbage.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b75522e..f732e62 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4288,8 +4288,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		mlog_errno(ret);
 
 leave:
-	ocfs2_xattr_bucket_free(first);
-	ocfs2_xattr_bucket_free(target);
 	return ret;
 }
 
-- 
1.5.6.5

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
