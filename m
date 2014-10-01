From: Andreas Dilger <adilger@dilger.ca>
Date: Wed, 1 Oct 2014 15:05:46 -0600
Subject: [Ocfs2-devel] [PATCH 04/12] fs: Generic infrastructure for
	optional inode fields
In-Reply-To: <1412191894-9113-5-git-send-email-jack@suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-5-git-send-email-jack@suse.cz>
Message-ID: <3BFF1023-E198-4797-A96A-EA158137157E@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu

On Oct 1, 2014, at 1:31 PM, Jan Kara <jack@suse.cz> wrote:
> There are parts of struct inode which are used only by a few filesystems
> (e.g. i_dquot pointers, i_mapping->private_list, ...). Thus all the
> other filesystems are just wasting memory with these fields. On the
> other hand it isn't simple to just move these fields to filesystem
> specific part of inode because there is generic code which needs to peek
> into the fields and it is cumbersome to provide helpers into which fs
> has to stuff the field it is storing elsewhere.
> 
> We create a simple infrastructure which allows for optional inode fields
> stored in the fs-specific part of the inode. Accessing these fields has
> a slightly worse performance as we have to lookup their offset in the
> offset table stored in the superblock but in most cases this is
> acceptable. Notably, this offset-table mechanism is faster than having
> fs-specific hook functions which would need to be called to provide
> pointers to desired fields.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> include/linux/fs.h | 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 94187721ad41..977f8fb6ca88 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -615,6 +615,11 @@ struct inode {
> 	void			*i_private; /* fs or device private pointer */
> };
> 
> +/* Optional inode fields (stored in filesystems inode if the fs needs them) */
> +enum {

This should be a named enum, like "enum inode_field" or similar, so it
can be referenced below.

> +	IF_FIELD_NR	/* Number of optional inode fields */
> +};
> +
> static inline int inode_unhashed(struct inode *inode)
> {
> 	return hlist_unhashed(&inode->i_hash);
> @@ -1236,6 +1241,11 @@ struct super_block {
> 	void 			*s_fs_info;	/* Filesystem private info */
> 	unsigned int		s_max_links;
> 	fmode_t			s_mode;
> +	/*
> +	 * We could have here just a pointer to the offsets array but this
> +	 * way we save one dereference when looking up field offsets
> +	 */
> +	int			s_inode_fields[IF_FIELD_NR];
> 
> 	/* Granularity of c/m/atime in ns.
> 	   Cannot be worse than a second */
> @@ -1286,6 +1296,20 @@ struct super_block {
> 	struct rcu_head		rcu;
> };
> 
> +static inline void *inode_field(const struct inode *inode, int field)

This should use "enum inode_field" instead of int, so the compiler could
warn about invalid parameter values.  It might make sense to add a check:

        if (field < IF_FIELD_NR)

but I'm not sure if the overhead is worthwhile, unless it can always be
resolved@compile time.  That might be possible since this is a static
inline function.

Cheers, Andreas

> +{
> +	int offset = inode->i_sb->s_inode_fields[field];
> +
> +	if (!offset)	/* Field not present? */
> +		return NULL;

> +	return ((char *)inode) + offset;
> +}
> +
> +static inline void sb_init_inode_fields(struct super_block *sb, int *fields)
> +{
> +	memcpy(sb->s_inode_fields, fields, sizeof(int) * IF_FIELD_NR);
> +}
> +
> extern struct timespec current_fs_time(struct super_block *sb);
> 
> /*
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 833 bytes
Desc: Message signed with OpenPGP using GPGMail
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20141001/67c9609c/attachment.bin 
