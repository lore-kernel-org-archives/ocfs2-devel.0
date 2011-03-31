From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 31 Mar 2011 14:06:43 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Teach local-mounted ocfs2 to
 handle unwritten_extents correctly.
In-Reply-To: <1301556866-8460-2-git-send-email-tristan.ye@oracle.com>
References: <1301556866-8460-1-git-send-email-tristan.ye@oracle.com>
	<1301556866-8460-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <4D94ECE3.2020906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

BTW, this affects the o2cb stack too. Not just local mounts.

Also, cc stable at kernel.org as this problem was introduced in
2.6.38 by 2fe17c10.

On 03/31/2011 12:34 AM, Tristan Ye wrote:
> Oops, local-mounted of 'ocfs2_fops_no_plocks' is just missing the support
> of unwritten_extents/punching-hole due to no func pointer was given correctly
> to '.follocate' field.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/file.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 41565ae..cce8c2b 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2658,6 +2658,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
>   	.flock		= ocfs2_flock,
>   	.splice_read	= ocfs2_file_splice_read,
>   	.splice_write	= ocfs2_file_splice_write,
> +	.fallocate	= ocfs2_fallocate,
>   };
>
>   const struct file_operations ocfs2_dops_no_plocks = {
