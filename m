From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 17:35:39 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in super.c
In-Reply-To: <20040219233755.GA24928@penguin.co.intel.com>
References: <200402180312.i1I3CH7Y015248@penguin.co.intel.com>
	<20040219233755.GA24928@penguin.co.intel.com>
Message-ID: <20040223233523.GA1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2004 at 03:37:55PM -0800, Rusty Lynch wrote:
> On Tue, Feb 17, 2004 at 07:12:17PM -0800, Rusty Lynch wrote:
> > The following patch fixes 2.6 port issues in super.c (which
> > spills into ocfs.h)
> > 
> > Specifically:
> > * The module inc/dec stuff is out for 2.6
> > * small changes in super_operations like the
> >   use of the new kstatfs struct
> > 
> 
> Here is a new patch against svn version 32.

<snip>

> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
>  
>  /*
>   * ocfs_statfs()
>   *
>   */
> +static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf)
> +{
> +        ocfs_super *osb = NULL;
> +        __u32 numbits, freebits = 0;
> +        // ocfs_lock_res *pLockResource;
> +        int status = 0;
> +        ocfs_bitmap_lock *bm_lock = NULL;
> +	struct buffer_head *bh = NULL;
> +
> +        LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", sb, buf);
> +
> +        osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
> +        numbits = osb->cluster_bitmap.validbits;
> + 
> +	status = ocfs_read_bh (osb, OCFS_BITMAP_LOCK_OFFSET, &bh, 0, NULL);
> +	if (status < 0) {
> +		LOG_ERROR_STR("failed to read bitmap data");
> +		return -EIO;
> +	}
> +	bm_lock = (ocfs_bitmap_lock *)OCFS_BH_GET_DATA_READ(bh); /* read */
> +
> +        if (numbits >= bm_lock->used_bits)
> +            freebits = numbits - bm_lock->used_bits;
> +
> +	/* take out the space reserved for system files */
> +	freebits -= (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size);	
> +
> +        buf->f_type = OCFS_MAGIC;
> +        buf->f_bsize = sb->s_blocksize;
> +        buf->f_namelen = OCFS_MAX_FILENAME_LENGTH;
> +        buf->f_blocks =
> +            (sector_t) ((unsigned long) (numbits) *
> +			(unsigned long) (osb->vol_layout.cluster_size >> 9) -
> +			(8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
> +        buf->f_bfree =
> +            (sector_t) (freebits * (osb->vol_layout.cluster_size >> 9));
> +        buf->f_bavail = buf->f_bfree;
> +        buf->f_files = (sector_t) (numbits);
> +        buf->f_ffree = (sector_t) (numbits) - freebits;
> +
> +	OCFS_BH_PUT_DATA(bh);
> +	lock_buffer(bh);
> +	clear_buffer_uptodate(bh);
> +	unlock_buffer(bh);
> +	brelse(bh);
> +
> +        LOG_EXIT_LONG (0);
> +        return 0;
> +}                               /* ocfs_statfs */
> +
> +#else /* 2.4.x kernel */
> +
> +/*
> + * ocfs_statfs()
> + *
> + */
>  static int ocfs_statfs (struct super_block *sb, struct statfs *buf)
>  {
>          ocfs_super *osb = NULL;

Is there a reason why we can't just combine the 2.4 / 2.6 versions of these
functions? From a cursory glance, they seem mostly the same...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
