From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Oct 2014 16:55:45 -0700
Subject: [Ocfs2-devel] [PATCH 4/7 v4] ocfs2: add and remove inode in
 orphan dir in ocfs2_direct_IO
In-Reply-To: <20141015164244.ccb52bcde4b6e0a44d130b22@linux-foundation.org>
References: <54392294.4000102@huawei.com>
	<20141015164244.ccb52bcde4b6e0a44d130b22@linux-foundation.org>
Message-ID: <20141015165545.59d005032c88c888733a7346@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 15 Oct 2014 16:42:44 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 11 Oct 2014 20:29:08 +0800 WeiWei Wang <wangww631@huawei.com> wrote:
> 
> > Add the inode to orphan dir first, and then delete it once append
> > O_DIRECT finished.
> > This is to make sure block allocation and inode size are consistent.
> > 
> > ...
> >
> > +static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
> > +		struct iov_iter *iter,
> > +		loff_t offset)
> > +{
> > +	ssize_t ret = 0;
> > +	int orphan = 0;
> > +	int is_overwrite = 0;
> > +	struct file *file = iocb->ki_filp;
> > +	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
> > +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +	struct buffer_head *di_bh = NULL;
> > +	size_t count = iter->count;
> > +	journal_t *journal = osb->journal->j_journal;
> > +	u32 p_cpos = 0;
> > +	u32 v_cpos = ocfs2_clusters_for_bytes(osb->sb, offset);
> > +	u32 zero_len = offset % (1 << osb->s_clustersize_bits);
> 
> On i386 this generates a call to _moddi3, which doesn't exist.  You'll
> need to use do_div() or something similar.
> 
> > +	int cluster_align = offset % (1 << osb->s_clustersize_bits) ? 0 : 1;
> 
> Similar here.  Why not just do cluster_align = !!zero_len?
> 

Something like this...

--- a/fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix
+++ a/fs/ocfs2/aops.c
@@ -29,6 +29,7 @@
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
+#include <linux/math64.h>
 
 #include <cluster/masklog.h>
 
@@ -640,13 +641,20 @@ static ssize_t ocfs2_direct_IO_write(str
 	journal_t *journal = osb->journal->j_journal;
 	u32 p_cpos = 0;
 	u32 v_cpos = ocfs2_clusters_for_bytes(osb->sb, offset);
-	u32 zero_len = offset % (1 << osb->s_clustersize_bits);
-	int cluster_align = offset % (1 << osb->s_clustersize_bits) ? 0 : 1;
+	u32 zero_len;
+	int cluster_align;
+	loff_t final_size = offset + count;
 	int append_write = offset >= i_size_read(inode) ? 1 : 0;
 	unsigned int num_clusters = 0;
 	unsigned int ext_flags = 0;
 
-	loff_t final_size = offset + count;
+	{
+		loff_t o = offset;
+
+		zero_len = do_div(o, 1 << osb->s_clustersize_bits);
+		cluster_align = !!zero_len;
+	}
+
 	/*
 	 * when final_size > inode->i_size, inode->i_size will be
 	 * updated after direct write, so add the inode to orphan
_
