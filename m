From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 Oct 2009 12:08:52 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] Quota support for disabling
	inline-data feature
In-Reply-To: <1255543739-23844-4-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
	<1255543739-23844-4-git-send-email-jack@suse.cz>
Message-ID: <20091020190852.GA15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 14, 2009 at 08:08:57PM +0200, Jan Kara wrote:
> When disabling inline-data feature, space occupied by files changes
> and thus we have to update quota information accordingly.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  tunefs.ocfs2/feature_inline_data.c |   42 +++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/tunefs.ocfs2/feature_inline_data.c b/tunefs.ocfs2/feature_inline_data.c
> index 77ddb42..9e1d07f 100644
> --- a/tunefs.ocfs2/feature_inline_data.c
> +++ b/tunefs.ocfs2/feature_inline_data.c
> @@ -170,31 +170,63 @@ static void empty_inline_data_context(struct inline_data_context *ctxt)
>  static errcode_t expand_inline_data(ocfs2_filesys *fs,
>  				    struct inline_data_context *ctxt)
>  {
> -	errcode_t ret = 0;
> +	errcode_t ret = 0, err;
>  	struct list_head *pos;
>  	struct inline_data_inode *idi;
>  	ocfs2_cached_inode *ci = NULL;
>  	struct tools_progress *prog;
> +	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
> +	ocfs2_quota_hash *usrhash = NULL, *grphash = NULL;
> +	uint32_t uid, gid;
> +	long long change;
>  
>  	prog = tools_progress_start("Expanding inline files", "expanding",
>  				    ctxt->more_clusters);
>  	if (!ctxt->prog)
>  		return TUNEFS_ET_NO_MEMORY;
>  
> +	ret = ocfs2_load_fs_quota_info(fs);
> +	if (ret)
> +		goto out;
> +
> +	ret = ocfs2_init_quota_change(fs, &usrhash, &grphash);
> +	if (ret)
> +		goto out;

	This is so much nicer!

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
