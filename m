From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 14 Oct 2008 18:36:22 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 features for 2.6.28 (build
	errors)
In-Reply-To: <20081014182037.38503fd0.randy.dunlap@oracle.com>
References: <20081014200319.GK15154@wotan.suse.de>
	<20081014182037.38503fd0.randy.dunlap@oracle.com>
Message-ID: <20081015013622.GV15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Oct 14, 2008 at 06:20:37PM -0700, Randy Dunlap wrote:
> In 2.6.27-git5 I am seeing build errors as follow:
> 
> fs/ocfs2/xattr.c: In function 'ocfs2_xattr_bucket_find':
> fs/ocfs2/xattr.c:2352: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> fs/ocfs2/xattr.c:2352: error: (Each undeclared identifier is reported only once
> fs/ocfs2/xattr.c:2352: error: for each function it appears in.)
> fs/ocfs2/xattr.c: In function 'ocfs2_iterate_xattr_buckets':
> fs/ocfs2/xattr.c:2429: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> fs/ocfs2/xattr.c: In function 'ocfs2_xattr_update_xattr_search':
> fs/ocfs2/xattr.c:2697: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> fs/ocfs2/xattr.c: In function 'ocfs2_defrag_xattr_bucket':
> fs/ocfs2/xattr.c:2902: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> fs/ocfs2/xattr.c: In function 'ocfs2_read_xattr_bucket':
> fs/ocfs2/xattr.c:3157: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> fs/ocfs2/xattr.c: In function 'ocfs2_xattr_set_entry_in_bucket':
> fs/ocfs2/xattr.c:4104: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
> make[2]: *** [fs/ocfs2/xattr.o] Error 1

Argh, I must have forgotten to commit my merge fixes for that file. This
patch should fix things. Thanks for reporting this Randy.


The following patch can also be pulled:

Please pull from 'build_fix' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git build_fix
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: fix build error

I merged the latest ocfs2_read_blocks() changes in xattr.c wrong. This makes
Ocfs2 compile again.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c25780a..802c414 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2349,7 +2349,7 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 		 */
 		ret = ocfs2_read_blocks(inode, xs->bucket.bhs[0]->b_blocknr + 1,
 					blk_per_bucket - 1, &xs->bucket.bhs[1],
-					OCFS2_BH_CACHED);
+					0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2426,7 +2426,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 
 	for (i = 0; i < num_buckets; i++, blkno += blk_per_bucket) {
 		ret = ocfs2_read_blocks(inode, blkno, blk_per_bucket,
-					bucket.bhs, OCFS2_BH_CACHED);
+					bucket.bhs, 0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2694,7 +2694,7 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 			ret = ocfs2_read_blocks(inode,
 					xs->bucket.bhs[0]->b_blocknr + 1,
 					blk_per_bucket - 1, &xs->bucket.bhs[1],
-					OCFS2_BH_CACHED);
+					0);
 			if (ret) {
 				mlog_errno(ret);
 				return ret;
@@ -2898,8 +2898,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	if (!bhs)
 		return -ENOMEM;
 
-	ret = ocfs2_read_blocks(inode, blkno, blk_per_bucket, bhs,
-				OCFS2_BH_CACHED);
+	ret = ocfs2_read_blocks(inode, blkno, blk_per_bucket, bhs, 0);
 	if (ret)
 		goto out;
 
@@ -3153,8 +3152,7 @@ static int ocfs2_read_xattr_bucket(struct inode *inode,
 
 	if (!new)
 		return ocfs2_read_blocks(inode, blkno,
-					 blk_per_bucket, bhs,
-					 OCFS2_BH_CACHED);
+					 blk_per_bucket, bhs, 0);
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		bhs[i] = sb_getblk(inode->i_sb, blkno + i);
@@ -4101,7 +4099,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		ret = ocfs2_read_blocks(inode,
 					xs->bucket.bhs[0]->b_blocknr + 1,
 					blk_per_bucket - 1, &xs->bucket.bhs[1],
-					OCFS2_BH_CACHED);
+					0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.4.1
