From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Sun, 09 Feb 2014 13:14:28 -0000
Subject: [Ocfs2-devel] [PATCH 13/21] fs: Mark functions as static in
	ocfs2/ioctl.c
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Message-ID: <e3ae6254fabecb02418fd725055779aee7c6ae41.1391949868.git.rashika.kheria@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, josh@joshtriplett.org

Mark functions as static in ocfs/ioctl.c because they are not used
outside this file.

This eliminates the following warning in ocfs/ioctl.c:
fs/ocfs2/ioctl.c:145:5: warning: no previous prototype for ?ocfs2_info_handle_blocksize? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:169:5: warning: no previous prototype for ?ocfs2_info_handle_clustersize? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:194:5: warning: no previous prototype for ?ocfs2_info_handle_maxslots? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:219:5: warning: no previous prototype for ?ocfs2_info_handle_label? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:244:5: warning: no previous prototype for ?ocfs2_info_handle_uuid? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:269:5: warning: no previous prototype for ?ocfs2_info_handle_fs_features? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:296:5: warning: no previous prototype for ?ocfs2_info_handle_journal_size? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:321:5: warning: no previous prototype for ?ocfs2_info_scan_inode_alloc? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:368:5: warning: no previous prototype for ?ocfs2_info_handle_freeinode? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:463:6: warning: no previous prototype for ?ocfs2_info_update_ffg? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:470:5: warning: no previous prototype for ?ocfs2_info_freefrag_scan_chain? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:573:5: warning: no previous prototype for ?ocfs2_info_freefrag_scan_bitmap? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:653:5: warning: no previous prototype for ?ocfs2_info_handle_freefrag? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:724:5: warning: no previous prototype for ?ocfs2_info_handle_unknown? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:753:5: warning: no previous prototype for ?ocfs2_info_handle_request? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:812:5: warning: no previous prototype for ?ocfs2_get_request_ptr? [-Wmissing-prototypes]
fs/ocfs2/ioctl.c:850:5: warning: no previous prototype for ?ocfs2_info_handle? [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/ioctl.c |   80 +++++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 8ca3c29..055b20c 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -143,8 +143,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_blocksize(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_blocksize(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_blocksize oib;
@@ -167,8 +167,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_clustersize(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_clustersize(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_clustersize oic;
@@ -192,8 +192,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_maxslots(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_maxslots(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_maxslots oim;
@@ -217,8 +217,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_label(struct inode *inode,
-			    struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_label(struct inode *inode,
+				   struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_label oil;
@@ -242,8 +242,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_uuid(struct inode *inode,
-			   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_uuid(struct inode *inode,
+				  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_uuid oiu;
@@ -267,8 +267,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_fs_features(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_fs_features(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_fs_features oif;
@@ -294,8 +294,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_journal_size(struct inode *inode,
-				   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_journal_size(struct inode *inode,
+					  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_journal_size oij;
@@ -319,9 +319,9 @@ bail:
 	return status;
 }
 
-int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
-				struct inode *inode_alloc, u64 blkno,
-				struct ocfs2_info_freeinode *fi, u32 slot)
+static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
+				       struct inode *inode_alloc, u64 blkno,
+				       struct ocfs2_info_freeinode *fi, u32 slot)
 {
 	int status = 0, unlock = 0;
 
@@ -366,8 +366,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freeinode(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freeinode(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	u32 i;
 	u64 blkno = -1;
@@ -461,19 +461,19 @@ static void o2ffg_update_stats(struct ocfs2_info_freefrag_stats *stats,
 	stats->ffs_free_chunks_real++;
 }
 
-void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
-			   unsigned int chunksize)
+static void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
+				  unsigned int chunksize)
 {
 	o2ffg_update_histogram(&(ffg->iff_ffs.ffs_fc_hist), chunksize);
 	o2ffg_update_stats(&(ffg->iff_ffs), chunksize);
 }
 
-int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
-				   struct inode *gb_inode,
-				   struct ocfs2_dinode *gb_dinode,
-				   struct ocfs2_chain_rec *rec,
-				   struct ocfs2_info_freefrag *ffg,
-				   u32 chunks_in_group)
+static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
+					  struct inode *gb_inode,
+					  struct ocfs2_dinode *gb_dinode,
+					  struct ocfs2_chain_rec *rec,
+					  struct ocfs2_info_freefrag *ffg,
+					  u32 chunks_in_group)
 {
 	int status = 0, used;
 	u64 blkno;
@@ -571,9 +571,9 @@ bail:
 	return status;
 }
 
-int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
-				    struct inode *gb_inode, u64 blkno,
-				    struct ocfs2_info_freefrag *ffg)
+static int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
+					   struct inode *gb_inode, u64 blkno,
+					   struct ocfs2_info_freefrag *ffg)
 {
 	u32 chunks_in_group;
 	int status = 0, unlock = 0, i;
@@ -651,8 +651,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freefrag(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freefrag(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	u64 blkno = -1;
 	char namebuf[40];
@@ -722,8 +722,8 @@ out_err:
 	return status;
 }
 
-int ocfs2_info_handle_unknown(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_unknown(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -751,8 +751,8 @@ bail:
  * - distinguish different requests.
  * - validate size of different requests.
  */
-int ocfs2_info_handle_request(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_request(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -810,8 +810,8 @@ bail:
 	return status;
 }
 
-int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
-			  u64 *req_addr, int compat_flag)
+static int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
+				 u64 *req_addr, int compat_flag)
 {
 	int status = -EFAULT;
 	u64 __user *bp = NULL;
@@ -848,8 +848,8 @@ bail:
  * a better backward&forward compatibility, since a small piece of
  * request will be less likely to be broken if disk layout get changed.
  */
-int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
-		      int compat_flag)
+static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
+			     int compat_flag)
 {
 	int i, status = 0;
 	u64 req_addr;
-- 
1.7.9.5
