From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 14:31:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: adds mlogs to aops.c -V2
In-Reply-To: <200907210258.n6L2wJ54002382@acsinet15.oracle.com>
References: <200907210258.n6L2wJ54002382@acsinet15.oracle.com>
Message-ID: <20090721213127.GB19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 21, 2009 at 10:52:52AM +0800, Wengang Wang wrote:
> @@ -565,6 +603,8 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  	 * Any write past EOF is not allowed because we'd be extending.
>  	 */
>  	if (create && (iblock + max_blocks) > inode_blocks) {
> +		mlog(0, "writting to EOF(%llu/%llu)\n",
> +		     iblock + max_blocks, inode_blocks);
>  		ret = -EIO;
>  		goto bail;
>  	}

	iblock is a sector_t and requires a cast.

> @@ -1542,8 +1659,14 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
>  {
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  
> -	if (new_size <= le16_to_cpu(di->id2.i_data.id_count))
> +	mlog_entry("(%llu, %llu)\n",
> +		   di_bh->b_blocknr, (unsigned long long)new_size);

	b_blocknr is a sector_t and requires a cast.

> @@ -1655,6 +1786,10 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	handle_t *handle;
>  	struct ocfs2_extent_tree et;
>  
> +	mlog_entry("(0x%p, %lld, %u, %u, .., %llu, %lu)\n",
> +		   mapping, pos, len, flags, di_bh->b_blocknr,
> +		   mmap_page->index);

	b_blocknr is a sector_t and requies a cast.  Also, I'd rather you
printed the **pagep pointer instead of "..".  Sure, it's a pointer to a
pointer that we're going to fill, but it might be useful to know.  Please
do this all the places you are printing "..".

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
