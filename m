From: alex chen <alex.chen@huawei.com>
Date: Sat, 16 Dec 2017 16:55:27 +0800
Subject: [Ocfs2-devel] [patch 02/11] ocfs2: give an obvious tip for
 mismatched cluster names
In-Reply-To: <5a20850b.3jaW0Z+eNZzGEhkV%akpm@linux-foundation.org>
References: <5a20850b.3jaW0Z+eNZzGEhkV%akpm@linux-foundation.org>
Message-ID: <5A34DF7F.7020300@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Alex Chen <alex.chen@huawei.com>

On 2017/12/1 6:24, akpm at linux-foundation.org wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: give an obvious tip for mismatched cluster names
> 
> Add an obvious error message, due to mismatched cluster names between
> on-disk and in the current cluster.  We can meet this case during OCFS2
> cluster migration.
> 
> If we can give the user an obvious tip for why they can not mount the file
> system after migration, they can quickly fix this mismatch problem. 
> 
> Second, also move printing ocfs2_fill_super() errno to the front of
> ocfs2_dismount_volume(), since ocfs2_dismount_volume() will also print
> its own message.
> 
> I looked through all the code of OCFS2 (include o2cb); there is not any
> place which returns this error.  In fact, the function calling path
> ocfs2_fill_super -> ocfs2_mount_volume -> ocfs2_dlm_init ->
> dlm_new_lockspace is a very specific one.  We can use this errno to give
> the user a more clear tip, since this case is a little common during
> cluster migration, but the customer can quickly get the failure cause if
> there is a error printed.  Also, I think it is not possible to add this
> errno in the o2cb path during ocfs2_dlm_init(), since the o2cb code has
> been stable for a long time.  
> 
> We only print this error tip when the user uses pcmk stack, since using
> the o2cb stack the user will not meet this error.
> 
> [ghe at suse.com: v2]
>   Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495419305-2D3780-2D1-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Anizi3o0ZEwILAnq8iiH7ZUxVKzFDRuYLdiaRHpC4Vs&s=d_OaUpYR5I06nrTowJ7vyCrdVacgZFzsh9Kt6L8fud0&e=
> Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495089336-2D19312-2D1-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Anizi3o0ZEwILAnq8iiH7ZUxVKzFDRuYLdiaRHpC4Vs&s=tHiMEtYMT-cxwBE5pjdrOew8mDXm92NHTa1vbbdVb0M&e=
> Signed-off-by: Gang He <ghe@suse.com>
> Reviewed-by: Mark Fasheh <mfasheh@versity.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Joseph Qi <jiangqi903@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/super.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff -puN fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names fs/ocfs2/super.c
> --- a/fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names
> +++ a/fs/ocfs2/super.c
> @@ -1208,14 +1208,15 @@ static int ocfs2_fill_super(struct super
>  read_super_error:
>  	brelse(bh);
>  
> +	if (status)
> +		mlog_errno(status);
> +
>  	if (osb) {
>  		atomic_set(&osb->vol_state, VOLUME_DISABLED);
>  		wake_up(&osb->osb_mount_event);
>  		ocfs2_dismount_volume(sb, 1);
>  	}
>  
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  }
>  
> @@ -1843,6 +1844,9 @@ static int ocfs2_mount_volume(struct sup
>  	status = ocfs2_dlm_init(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> +		if (status == -EBADR && ocfs2_userspace_stack(osb))
> +			mlog(ML_ERROR, "couldn't mount because cluster name on"
> +			" disk does not match the running cluster name.\n");
>  		goto leave;
>  	}
>  
> _
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 
