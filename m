From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Oct 2008 13:42:11 +0800
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2/xattr: Only extend xattr bucket
	in need.
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225345335-11527-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When the first block of a bucket is filled up with xattr
entries, we normally extend the bucket. But if we are
just replace one xattr with small length, we don't need
to extend it. This is important since we will calculate
what we need before the transaction and in this situation
no resources will be allocated.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b0a73c2..dc90ffb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4569,7 +4569,9 @@ try_again:
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
1.5.4.GIT
