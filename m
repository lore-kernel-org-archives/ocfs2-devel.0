From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 20 Oct 2008 19:08:17 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Specify appropriate journal access
	for new xattr buckets.
In-Reply-To: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
References: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224554898-3928-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are a couple places that get an xattr bucket that may be reading
an existing one or may be allocating a new one.  They should specify the
correct journal access mode depending.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 90cd7d0..5f11db2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3218,7 +3218,9 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
-					   OCFS2_JOURNAL_ACCESS_CREATE);
+					   new_bucket_head ?
+					   OCFS2_JOURNAL_ACCESS_CREATE :
+					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3380,6 +3382,8 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+					   t_is_new ?
+					   OCFS2_JOURNAL_ACCESS_CREATE :
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret)
 			goto out;
-- 
1.5.6.5
