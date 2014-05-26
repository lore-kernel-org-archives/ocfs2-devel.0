From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 26 May 2014 11:28:40 +0800
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: move_extents.c: Fix for
 possible null pointer dereference
In-Reply-To: <1400791604-12094-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400791604-12094-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <5382B4E8.7020806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi,

On 05/23/2014 04:46 AM, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  fs/ocfs2/move_extents.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 599eb4c..6a8e3c8 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -902,11 +902,13 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct inode *inode = context->inode;
>  	struct ocfs2_dinode *di;
>  	struct buffer_head *di_bh = NULL;
> -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_super *osb;
>  
>  	if (!inode)
>  		return -ENOENT;
>  
> +	osb = OCFS2_SB(inode->i_sb);
> +
>  	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
>  		return -EROFS;

Thanks for your patch, it looks reasonable if we consider it in the context
of above function only. However, the inode should not be NULL in any case
given that ocfs2_move_extents() is called by ocfs2_ioctl_move_extents() at
where the inode is already validated.

IMO, maybe we can just get rid of the useless inode pre-checkup, i.e,

if (!inode)
	return -ENOENT;


Thanks,
-Jeff
