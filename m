From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 02:30:47 -0700
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <4A9CDFAD.5060603@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-7-git-send-email-joel.becker@oracle.com>
	<4A9CCE33.2070506@oracle.com>
	<20090901083047.GC3826@mail.oracle.com>
	<4A9CDFAD.5060603@oracle.com>
Message-ID: <20090901093046.GF3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 04:47:41PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Tue, Sep 01, 2009 at 03:33:07PM +0800, Tao Ma wrote:
> >>Joel Becker wrote:
> >>>+	rc = ocfs2_xa_has_space(loc, xi);
> >>>+	if (rc)
> >>>+		goto out;
> >>could you please add some comments here or change the function name.
> >>when I read ocfs2_xa_has_space, I always think that "if we have
> >>space, goto out". But actually we get 0 here if we have space.
> >
> >	A very good point.  It really should be ocfs2_xa_space_needed().
> >Does that work?
> actually your function just return either -ENOSPC, -EIO or 0.
> And we go ahead when we get 0. so maybe ocfs2_xa_check_space? So <0
> means we meet with some errors and 0 means OK.

How's this?

Joel


diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2e8f5c6..b1d05ef 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -156,8 +156,8 @@ struct ocfs2_xa_loc_operations {
 			     struct ocfs2_xattr_info *xi);
 
 	/* How much space is needed for the new value? */
-	int (*xlo_has_space)(struct ocfs2_xa_loc *loc,
-			     struct ocfs2_xattr_info *xi);
+	int (*xlo_check_space)(struct ocfs2_xa_loc *loc,
+			       struct ocfs2_xattr_info *xi);
 
 	/*
 	 * Return the offset of the first name+value pair.  This is
@@ -1519,8 +1519,8 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_xa_has_space_helper(int needed_space, int free_start,
-				     int num_entries)
+static int ocfs2_xa_check_space_helper(int needed_space, int free_start,
+				       int num_entries)
 {
 	int free_space;
 
@@ -1569,10 +1570,10 @@ static int ocfs2_xa_can_reuse_entry(struct ocfs2_xa_loc *loc,
 }
 
 /* How much free space is needed to set the new value */
-static int ocfs2_xa_has_space(struct ocfs2_xa_loc *loc,
-			      struct ocfs2_xattr_info *xi)
+static int ocfs2_xa_check_space(struct ocfs2_xa_loc *loc,
+				struct ocfs2_xattr_info *xi)
 {
-	return loc->xl_ops->xlo_has_space(loc, xi);
+	return loc->xl_ops->xlo_check_space(loc, xi);
 }
 
 static void ocfs2_xa_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
@@ -1639,8 +1639,8 @@ static int ocfs2_xa_block_get_free_start(struct ocfs2_xa_loc *loc)
 	return free_start;
 }
 
-static int ocfs2_xa_block_has_space(struct ocfs2_xa_loc *loc,
-				    struct ocfs2_xattr_info *xi)
+static int ocfs2_xa_block_check_space(struct ocfs2_xa_loc *loc,
+				      struct ocfs2_xattr_info *xi)
 {
 	int count = le16_to_cpu(loc->xl_header->xh_count);
 	int free_start = ocfs2_xa_get_free_start(loc);
@@ -1660,7 +1660,7 @@ static int ocfs2_xa_block_has_space(struct ocfs2_xa_loc *loc,
 	}
 	if (needed_space < 0)
 		needed_space = 0;
-	return ocfs2_xa_has_space_helper(needed_space, free_start, count);
+	return ocfs2_xa_check_space_helper(needed_space, free_start, count);
 }
 
 /*
@@ -1720,7 +1720,7 @@ static void ocfs2_xa_block_add_namevalue(struct ocfs2_xa_loc *loc, int size)
  */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
 	.xlo_offset_pointer	= ocfs2_xa_block_offset_pointer,
-	.xlo_has_space		= ocfs2_xa_block_has_space,
+	.xlo_check_space	= ocfs2_xa_block_check_space,
 	.xlo_can_reuse		= ocfs2_xa_block_can_reuse,
 	.xlo_get_free_start	= ocfs2_xa_block_get_free_start,
 	.xlo_wipe_namevalue	= ocfs2_xa_block_wipe_namevalue,
@@ -1770,8 +1768,8 @@ static int ocfs2_bucket_align_free_start(struct super_block *sb,
 	return free_start;
 }
 
-static int ocfs2_xa_bucket_has_space(struct ocfs2_xa_loc *loc,
-				     struct ocfs2_xattr_info *xi)
+static int ocfs2_xa_bucket_check_space(struct ocfs2_xa_loc *loc,
+				       struct ocfs2_xattr_info *xi)
 {
 	int count = le16_to_cpu(loc->xl_header->xh_count);
 	int free_start = ocfs2_xa_get_free_start(loc);
@@ -1796,7 +1794,7 @@ static int ocfs2_xa_bucket_has_space(struct ocfs2_xa_loc *loc,
 	BUG_ON(needed_space < 0);
 
 	free_start = ocfs2_bucket_align_free_start(sb, free_start, size);
-	return ocfs2_xa_has_space_helper(needed_space, free_start, count);
+	return ocfs2_xa_check_space_helper(needed_space, free_start, count);
 }
 
 static void ocfs2_xa_bucket_wipe_namevalue(struct ocfs2_xa_loc *loc)
@@ -1859,7 +1857,7 @@ static void ocfs2_xa_bucket_add_namevalue(struct ocfs2_xa_loc *loc, int size)
 /* Operations for xattrs stored in buckets. */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
-	.xlo_has_space		= ocfs2_xa_bucket_has_space,
+	.xlo_check_space	= ocfs2_xa_bucket_check_space,
 	.xlo_can_reuse		= ocfs2_xa_bucket_can_reuse,
 	.xlo_get_free_start	= ocfs2_xa_bucket_get_free_start,
 	.xlo_wipe_namevalue	= ocfs2_xa_bucket_wipe_namevalue,
@@ -1916,7 +1914,7 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 		goto out;
 	}
 
-	rc = ocfs2_xa_has_space(loc, xi);
+	rc = ocfs2_xa_check_space(loc, xi);
 	if (rc)
 		goto out;
 
-- 

"Drake!  We're LEAVING!"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
