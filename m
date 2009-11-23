From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 23 Nov 2009 12:54:14 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid panic for local mounts on
 corruptions
In-Reply-To: <1259008859-27065-1-git-send-email-srinivas.eeda@oracle.com>
References: <1259008859-27065-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4B0AF676.3090405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;h=a2f2ddbf2bafdbc7e4f3bbf09439b42c8fee2747

This change was pushed to mainline few months ago.

Srinivas Eeda wrote:
> When a file system is mounted local, it may be enough to remount it read only
> on seeing corruptions.
>
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/super.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index a3f8871..c1ee5f0 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2487,10 +2487,12 @@ void __ocfs2_abort(struct super_block* sb,
>  	 * TODO: This should abort the journal and alert other nodes
>  	 * that our slot needs recovery. */
>  
> -	/* Force a panic(). This stinks, but it's better than letting
> -	 * things continue without having a proper hard readonly
> -	 * here. */
> -	OCFS2_SB(sb)->s_mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
> +	/* Force a panic() for clustered mounts. This stinks, but it's
> +	 * better than letting things continue withouthaving a proper
> +	 * hard readonly here.
> +	 * */
> +	if (!ocfs2_mount_local(OCFS2_SB(sb)))
> +		OCFS2_SB(sb)->s_mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
>  	ocfs2_handle_error(sb);
>  }
>  
>   
