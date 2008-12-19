From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:35 -0800
Subject: [Ocfs2-devel] [PATCH 16/45] ocfs2/xattr: Only extend xattr bucket
	in need.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-17-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

When the first block of a bucket is filled up with xattr
entries, we normally extend the bucket. But if we are
just replace one xattr with small length, we don't need
to extend it. This is important since we will calculate
what we need before the transaction and in this situation
no resources will be allocated.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d8fc714..4501c63 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4564,7 +4564,9 @@ try_again:
 	     free, need, max_free, le16_to_cpu(xh->xh_free_start),
 	     le16_to_cpu(xh->xh_name_value_len));
 
-	if (free < need || count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
+	if (free < need ||
+	    (xs->not_found &&
+	     count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb))) {
 		if (need <= max_free &&
 		    count < ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
 			/*
-- 
1.5.6
