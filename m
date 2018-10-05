From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Fri, 5 Oct 2018 10:21:59 -0700
Subject: [Ocfs2-devel] [PATCH 02/15] xfs: refactor clonerange
 preparation into a separate helper
In-Reply-To: <20181005090242.GF12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870028762.29072.5369530877410002226.stgit@magnolia>
	<20181005070228.GE12041@dastard> <20181005090242.GF12041@dastard>
Message-ID: <20181005172159.GV19324@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Fri, Oct 05, 2018 at 07:02:42PM +1000, Dave Chinner wrote:
> On Fri, Oct 05, 2018 at 05:02:28PM +1000, Dave Chinner wrote:
> > On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Refactor all the reflink preparation steps into a separate helper that
> > > we'll use to land all the upcoming fixes for insufficient input checks.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > .....
> > 
> > > +xfs_reflink_remap_range(
> > > +	struct file		*file_in,
> > > +	loff_t			pos_in,
> > > +	struct file		*file_out,
> > > +	loff_t			pos_out,
> > > +	u64			len,
> > > +	bool			is_dedupe)
> > > +{
> > > +	struct inode		*inode_in = file_inode(file_in);
> > > +	struct xfs_inode	*src = XFS_I(inode_in);
> > > +	struct inode		*inode_out = file_inode(file_out);
> > > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > > +	struct xfs_mount	*mp = src->i_mount;
> > > +	xfs_fileoff_t		sfsbno, dfsbno;
> > > +	xfs_filblks_t		fsblen;
> > > +	xfs_extlen_t		cowextsize;
> > > +	ssize_t			ret;
> > > +
> > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (XFS_FORCED_SHUTDOWN(mp))
> > > +		return -EIO;
> > > +
> > > +	/* Prepare and then clone file data. */
> > > +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> > > +			len, is_dedupe);
> 
> More than one bug. vfs_clone_file_prep_inodes() modifes the length
> parameter in the case of whole file reflink by way of "len == 0"
> on a non-zero length file. So I fixed this, too.

Did your patch look something like the attached?

--D

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 80ca9b6793cd..53158bdb1105 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1219,6 +1219,7 @@ xfs_reflink_remap_unlock(
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
  * will be truncated, and any leases on the out file will have been broken.
+ * Returns negative for error, 0 for nothing to do, and 1 for success.
  */
 STATIC int
 xfs_reflink_remap_prep(
@@ -1226,7 +1227,7 @@ xfs_reflink_remap_prep(
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			len,
+	u64			*len,
 	bool			is_dedupe)
 {
 	struct inode		*inode_in = file_inode(file_in);
@@ -1257,7 +1258,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
-			&len, is_dedupe);
+			len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1284,8 +1285,8 @@ xfs_reflink_remap_prep(
 
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
-	return 0;
+				   PAGE_ALIGN(pos_out + *len) - 1);
+	return 1;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	return ret;
@@ -1321,8 +1322,8 @@ xfs_reflink_remap_range(
 
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
-			len, is_dedupe);
-	if (ret)
+			&len, is_dedupe);
+	if (ret <= 0)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> -Dave.
> -- 
> Dave Chinner
> david at fromorbit.com
