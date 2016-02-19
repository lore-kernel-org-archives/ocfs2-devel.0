From: Eric Sandeen <sandeen@sandeen.net>
Date: Fri, 19 Feb 2016 11:31:58 -0600
Subject: [Ocfs2-devel] [PATCH 1/3] quota: Add support for
 ->get_nextdqblk() for VFS quota
In-Reply-To: <1454596087-6814-2-git-send-email-jack@suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
Message-ID: <56C7518E.4020204@sandeen.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com



On 2/4/16 8:28 AM, Jan Kara wrote:
> Add infrastructure for supporting get_nextdqblk() callback for VFS
> quotas. Translate the operation into a callback to appropriate
> filesystem and consequently to quota format callback.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c          |  1 +
>  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
>  fs/reiserfs/super.c      |  1 +
>  include/linux/quota.h    |  3 +++
>  include/linux/quotaops.h |  3 +++
>  5 files changed, 47 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f1b56ff01208..51649f442bf6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
>  	.write_info	= ext4_write_info,
>  	.alloc_dquot	= dquot_alloc,
>  	.destroy_dquot	= dquot_destroy,
> +	.get_next_id	= dquot_get_next_id,
>  };

Hi Jan, doesn't this also need to set:


+       .get_nextdqblk  = dquot_get_next_dqblk,

in ext4_qctl_sysfile_operations?

Thanks,
-Eric
