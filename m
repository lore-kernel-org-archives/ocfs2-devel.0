From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 27 Jul 2010 13:27:31 -0700
Subject: [Ocfs2-devel] [PATCH V3] Fix the nested PR lock calling issue
	in ACL
In-Reply-To: <20100726103636.GA23889@linux-jjzhang>
References: <20100726043630.GA31856@linux-jjzhang>
	<20100726103636.GA23889@linux-jjzhang>
Message-ID: <20100727202731.GV20646@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 26, 2010 at 06:36:36PM +0800, Jiaju Zhang wrote:
> Oh, this is a slight change of the patch I just posted, since the
> original one may have wrongly processing of error return code. So
> please review this one instead;)
> 
> Thanks a lot,
> Jiaju
> 
> Signed-off-by: Jiaju Zhang <jjzhang@suse.de>

Acked-by: Mark Fasheh <mfasheh@suse.com>

Thanks for catching this.

You'll want to send with the original message from the first patch btw. Also
I guess you can then include Wengang's requested mlog_errno().
	--Mark


> ---
>  fs/ocfs2/acl.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index da70229..28a25b8 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -290,12 +290,28 @@ static int ocfs2_set_acl(handle_t *handle,
>  
>  int ocfs2_check_acl(struct inode *inode, int mask)
>  {
> -	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct buffer_head *di_bh = NULL;
> +	struct posix_acl *acl;
> +	int ret = -EAGAIN;
> +
> +	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
> +		return ret;
> +
> +	ret = ocfs2_read_inode_block(inode, &di_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +
> +	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, di_bh);
> +
> +	brelse(di_bh);
>  
>  	if (IS_ERR(acl))
>  		return PTR_ERR(acl);
>  	if (acl) {
> -		int ret = posix_acl_permission(inode, acl, mask);
> +		ret = posix_acl_permission(inode, acl, mask);
>  		posix_acl_release(acl);
>  		return ret;
>  	}
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
