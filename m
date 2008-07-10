From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 9 Jul 2008 18:24:56 -0700
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: reserve inline space for
	extended attribute v2
In-Reply-To: <1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080710012456.GM28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for breaking this patch up even smaller.

On Fri, Jun 27, 2008 at 03:27:34PM +0800, Tiger Yang wrote:
> This patch reserve some space in inode block for extended attribute.
> That space used to store extent list or inline data.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/alloc.c    |   31 +++++++++++++++++++++++--------
>  fs/ocfs2/ocfs2.h    |    3 +++
>  fs/ocfs2/ocfs2_fs.h |   36 ++++++++++++++++++++++++++++++++++--
>  fs/ocfs2/super.c    |    2 ++
>  4 files changed, 62 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 3a06271..2df5a7f 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6417,26 +6417,40 @@ out:
>  	return ret;
>  }
>  
> -static void ocfs2_zero_dinode_id2(struct inode *inode, struct ocfs2_dinode *di)
> +static void ocfs2_zero_dinode_id2_with_xattr(struct super_block *sb,
> +					     struct ocfs2_dinode *di,
> +					     int xattrsize)
>  {
> -	unsigned int blocksize = 1 << inode->i_sb->s_blocksize_bits;
> -
> -	memset(&di->id2, 0, blocksize - offsetof(struct ocfs2_dinode, id2));
> +	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
> +		memset(&di->id2, 0, sb->s_blocksize -
> +				    offsetof(struct ocfs2_dinode, id2) -
> +				    xattrsize);
> +	else
> +		memset(&di->id2, 0, sb->s_blocksize -
> +				    offsetof(struct ocfs2_dinode, id2));
>  }

Wasn't the plan to also store inline xattr size on the inode, when it has
OCFS2_INLINE_XATTR_FL set and only use s_xattr_inline_size when figuring out
if a non-inline-xattr inode has enough space?

struct ocfs2_dinode {
	...
	__u16 i_xattr_inline_size;
	...
};


This way ocfs2_zero_dinode_id2_with_xattr becomes:

static void ocfs2_zero_dinode_id2_with_xattr(struct super_block *sb,
					     struct ocfs2_dinode *di)
{
	unsigned int xattrsize = le16_to_cpu(di->i_xattr_inline_size);

	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
		memset(&di->id2, 0, sb->s_blocksize -
				    offsetof(struct ocfs2_dinode, id2) -
				    xattrsize);
	else
		memset(&di->id2, 0, sb->s_blocksize -
				    offsetof(struct ocfs2_dinode, id2));
}


Think of this in terms of l_count on the in-inode extent list. We could have
just stored that on the superblock, because lets face it - l_count hasn't
changed for a particular block size, ever. But if we did that, then making
space for inline xattrs wouldn't be as simple as just shrinking l_count
because tons of code which iterates the extent list would assume "oh, every
inode has exactly this many inline extents" instead of just _looking at the
inode_ to see how many inline extents it contains. And really, I think it's
just good practice to have our structures be self-referencial.

It's not enough to just change ocfs2_zero_dinode_id2_with_xattr() by the way
- you need to get this correct for all functions which take inline xattr
size into account. Luckily, your code is written well enough that this
shouldn't be a big deal.


Functions like ocfs2_xattr_has_space_inline() change too, but in a slightly
different way. Those functions deal an inode that does _not_ have inline
xattrs, but instead try to figure out whether they'll fit. In those cases,
you use s_xattr_inline_size as a guideline:


static int ocfs2_xattr_has_space_inline(struct inode *inode,
					struct ocfs2_dinode *di)
{
	struct ocfs2_inode_info *oi = OCFS2_I(inode);
	int xattrsize = OCFS2_SB(inode->i_sb)->s_xattr_inline_size;
	int free;

	if (xattrsize < OCFS2_MIN_XATTR_INLINE_SIZE)
		return 0;

	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
		struct ocfs2_inline_data *idata = &di->id2.i_data;
		free = le16_to_cpu(idata->id_count) - le64_to_cpu(di->i_size);
	} else {
		struct ocfs2_extent_list *el = &di->id2.i_list;
		free = (le16_to_cpu(el->l_count) -
			le16_to_cpu(el->l_next_free_rec)) *
			sizeof(struct ocfs2_extent_rec);
	}
	if (free >= xattrsize)
		return 1;

	return 0;
}


And then, of course when you're *setting* inline xattrs for the first time
(generally, this just means "when you set the INLINE_XATTR_FL"), you need to
populate i_xattr_inline_size with something meaningful. I _think_ this
happens in ocfs2_xattr_set_entry() - I haven't gotten to that patch yet:


	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
	    (flag & OCFS2_INLINE_XATTR_FL)) {
		/*
		 * Adjust extent record count or inline data size
		 * to reserve space for extended attribute.
		 */
		if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
			struct ocfs2_inline_data *idata = &di->id2.i_data;
			le16_add_cpu(&idata->id_count, -xattrsize);
		} else {
			struct ocfs2_extent_list *el = &di->id2.i_list;
			le16_add_cpu(&el->l_count, -(xattrsize /
				     sizeof(struct ocfs2_extent_rec)));
		}
		di->i_xattr_inline_size = cpu_to_le16(osb->s_xattr_inline_size);
	}


The test you should use, to figure out what some code should do is ask
yourself "will this break, if the admin changes xattr_inline_size on a
NON-empty file system?" If the answer is "no, i_xattr_inline_size on an
inode with OCFS2_INLINE_XATTR_FL set is independent of the current value of
s_xattr_inline_size" then you got it correct.

Let me know if any of this is unclear!
	--Mark


--
Mark Fasheh
