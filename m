From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 13:26:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix check of return value
	of	ocfs2_start_trans()
In-Reply-To: <12245234424005-git-send-email-jack@suse.cz>
References: <12245234424005-git-send-email-jack@suse.cz>
Message-ID: <20081021202618.GC2871@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:51PM +0200, Jan Kara wrote:
> On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM).
> Thus checks for !handle are wrong. Fix them to use IS_ERR().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

This should go upstream.  There are two more in xattr.c (not in the
sources Jan had).

Joel

> ---
>  fs/ocfs2/file.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ec2ed15..89dc20e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -246,8 +246,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
>  	mlog_entry_void();
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (handle == NULL) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> @@ -311,8 +311,8 @@ static int ocfs2_simple_size_update(struct inode *inode,
>  	handle_t *handle = NULL;
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (handle == NULL) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> @@ -1209,8 +1209,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
>  		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (handle == NULL) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> @@ -1412,8 +1412,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
>  	}
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
> -	if (handle == NULL) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> @@ -1505,8 +1505,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>  		goto out;
>  
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (handle == NULL) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> -- 
> 1.5.2.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
