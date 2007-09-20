From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 12:14:37 2007
Subject: [Ocfs2-devel] [PATCH 10/15] ocfs2: Cleanup dirent size check
In-Reply-To: <200709192012.l8JKCGOe029334@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCGOe029334@rgmgw2.us.oracle.com>
Message-ID: <20070920191400.GM30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 13, 2007 at 04:29:01PM -0700, Mark Fasheh wrote:
> The check to see if a new dirent would fit in an old one is pretty ugly, and
> it's done at least twice. Clean things up by putting this in it's own
> easier-to-read function.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

de_really_needed sounds like it's the new needed, which confused me
(de_really_needed + new_rec_len sounds like "new needed + new needed",
which of course makes no sense).  Can you rename de_really_needed to
de_really_used, de_old_used, or de_old_needed?  That captures the sense
of "how much space in the old dirent is actually used".

Signed-of-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dir.c |   36 ++++++++++++++++++++++++++++--------
>  1 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 31db7e3..4c36eae 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -343,6 +343,31 @@ bail:
>  	return status;
>  }
>  
> +/*
> + * Check whether 'de' has enough room to hold an entry of
> + * 'new_rec_len' bytes.
> + */
> +static inline int ocfs2_dirent_would_fit(struct ocfs2_dir_entry *de,
> +					 unsigned int new_rec_len)
> +{
> +	unsigned int de_really_needed;
> +
> +	/* Check whether this is an empty record with enough space */
> +	if (le64_to_cpu(de->inode) == 0 &&
> +	    le16_to_cpu(de->rec_len) >= new_rec_len)
> +		return 1;
> +
> +	/*
> +	 * Record might have free space at the end which we can
> +	 * use.
> +	 */
> +	de_really_needed = OCFS2_DIR_REC_LEN(de->name_len);
> +	if (le16_to_cpu(de->rec_len) >= (de_really_needed + new_rec_len))
> +	    return 1;
> +
> +	return 0;
> +}
> +
>  /* we don't always have a dentry for what we want to add, so people
>   * like orphan dir can call this instead.
>   *
> @@ -385,10 +410,8 @@ int __ocfs2_add_entry(handle_t *handle,
>  			retval = -EEXIST;
>  			goto bail;
>  		}
> -		if (((le64_to_cpu(de->inode) == 0) &&
> -		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
> -		    (le16_to_cpu(de->rec_len) >=
> -		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
> +
> +		if (ocfs2_dirent_would_fit(de, rec_len)) {
>  			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
>  			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
>  			if (retval < 0) {
> @@ -1078,10 +1101,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
>  			status = -EEXIST;
>  			goto bail;
>  		}
> -		if (((le64_to_cpu(de->inode) == 0) &&
> -		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
> -		    (le16_to_cpu(de->rec_len) >=
> -		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
> +		if (ocfs2_dirent_would_fit(de, rec_len)) {
>  			/* Ok, we found a spot. Return this bh and let
>  			 * the caller actually fill it in. */
>  			*ret_de_bh = bh;
> -- 
> 1.5.0.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
