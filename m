From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan 23 18:48:51 2008
Subject: [Ocfs2-devel] Re: [PATCH 13/30] ocfs2: Implement group add for
	online resize
In-Reply-To: <20080123140554.bf3981e5.akpm@linux-foundation.org>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-14-git-send-email-mark.fasheh@oracle.com>
	<20080123140554.bf3981e5.akpm@linux-foundation.org>
Message-ID: <20080124024844.GP23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, tao.ma@oracle.com

On Wed, Jan 23, 2008 at 02:05:54PM -0800, Andrew Morton wrote:
> > On Thu, 17 Jan 2008 14:35:39 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > From: Tao Ma <tao.ma@oracle.com>
> > 
> > This patch adds the ability for a userspace program to request that a
> > properly formatted cluster group be added to the main allocation bitmap for
> > an Ocfs2 file system. The request is made via an ioctl, OCFS2_IOC_GROUP_ADD.
> > On a high level, this is similar to ext3, but we use a different ioctl as
> > the structure which has to be passed through is different.
> > 
> > During an online resize, tunefs.ocfs2 will format any new cluster groups
> > which must be added to complete the resize, and call OCFS2_IOC_GROUP_ADD on
> > each one. Kernel verifies that the core cluster group information is valid
> > and then does the work of linking it into the global allocation bitmap.
> > 
> >  ...
> >
> > +/* Used to pass group descriptor data when online resize is done */
> > +struct ocfs2_new_group_input {
> > +	__u64 group;		/* Group descriptor's blkno. */
> > +	__u32 clusters;		/* Total number of clusters in this group */
> > +	__u32 frees;		/* Total free clusters in this group */
> > +	__u16 chain;		/* Chain for this group */
> > +	__u16 reserved1;
> > +	__u32 reserved2;
> > +};
> 
> Are we sure that all architectures will lay this out in the same way with
> both 32-bit and 64-bit userspace?

I looked it over several times and haven't been able to find a problem -
everything is aligned at 8 byte boundaries. Do you see anything that might
be problematic?


> > +/* Add a new group descriptor to global_bitmap. */
> > +int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
> > +{
> > +	int ret;
> > +	handle_t *handle;
> > +	struct buffer_head *main_bm_bh = NULL;
> > +	struct inode *main_bm_inode = NULL;
> > +	struct ocfs2_dinode *fe = NULL;
> > +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +	struct buffer_head *group_bh = NULL;
> > +	struct ocfs2_group_desc *group = NULL;
> > +	struct ocfs2_chain_list *cl;
> > +	struct ocfs2_chain_rec *cr;
> > +	u16 cl_bpc;
> > +
> > +	mlog_entry_void();
> > +
> > +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > +		return -EROFS;
> > +
> > +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> > +						    GLOBAL_BITMAP_SYSTEM_INODE,
> > +						    OCFS2_INVALID_SLOT);
> > +	if (!main_bm_inode) {
> > +		ret = -EINVAL;
> > +		mlog_errno(ret);
> > +		goto out;
> > +	}
> > +
> > +	mutex_lock(&main_bm_inode->i_mutex);
> > +
> > +	ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> > +	if (ret < 0) {
> > +		mlog_errno(ret);
> > +		goto out_mutex;
> > +	}
> > +
> > +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
> > +
> > +	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
> > +				 ocfs2_group_bitmap_size(osb->sb) * 8) {
> > +		mlog(ML_ERROR, "The disk is too old and small."
> > +		     " Force to do offline resize.");
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
> > +	if (ret < 0) {
> > +		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
> > +		     "from the device.", input->group);
> > +		goto out;
> 
> Bug: goto wrong_place.  (Points at fault-injection code)

Ooof, good catch - thanks. A fix for this is attached to this e-mail, and
of course will be in ocfs2.git.


> > +	}
> > +
> > +	ocfs2_set_new_buffer_uptodate(inode, group_bh);
> > +
> > +	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
> > +	if (ret) {
> > +		mlog_errno(ret);
> > +		goto out_unlock;
> > +	}
> > +
> > +	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
> > +	     input->group, input->chain, input->clusters);
> > +
> > +	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
> > +	if (IS_ERR(handle)) {
> > +		mlog_errno(PTR_ERR(handle));
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> > +	cl = &fe->id2.i_chain;
> > +	cr = &cl->cl_recs[input->chain];
> > +
> > +	ret = ocfs2_journal_access(handle, main_bm_inode, group_bh,
> > +				   OCFS2_JOURNAL_ACCESS_WRITE);
> > +	if (ret < 0) {
> > +		mlog_errno(ret);
> > +		goto out_commit;
> > +	}
> > +
> > +	group = (struct ocfs2_group_desc *)group_bh->b_data;
> > +	group->bg_next_group = cr->c_blkno;
> > +
> > +	ret = ocfs2_journal_dirty(handle, group_bh);
> > +	if (ret < 0) {
> > +		mlog_errno(ret);
> > +		goto out_commit;
> > +	}
> > +
> > +	ret = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
> > +				   OCFS2_JOURNAL_ACCESS_WRITE);
> 
> hm.  Do we need to do that again?

I think you're missing that those are two different buffers  :)


> > +	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
> > +	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> > +	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
> > +	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
> > +	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
> 
> Is i_mutex held?

Yes.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com


From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: fix goto error in ocfs2_group_add()

We were jumping to the wrong label on read error which would have caused us
to exit the function with locks held.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index a103698..261dabf 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -544,7 +544,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	if (ret < 0) {
 		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
 		     "from the device.", (unsigned long long)input->group);
-		goto out;
+		goto out_unlock;
 	}
 
 	ocfs2_set_new_buffer_uptodate(inode, group_bh);
-- 
1.5.3.6
