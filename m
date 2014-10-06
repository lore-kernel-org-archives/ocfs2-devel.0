From: Dave Chinner <david@fromorbit.com>
Date: Tue, 7 Oct 2014 07:30:28 +1100
Subject: [Ocfs2-devel] [PATCH 03/12] xfs: Set allowed quota types
In-Reply-To: <1412191894-9113-4-git-send-email-jack@suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
Message-ID: <20141006203028.GB2301@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
> We support user, group, and project quotas. Tell VFS about it.
> 
> CC: xfs at oss.sgi.com
> CC: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b194652033cd..b32e998e8cbc 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
>  	sb->s_export_op = &xfs_export_operations;
>  #ifdef CONFIG_XFS_QUOTA
>  	sb->s_qcop = &xfs_quotactl_operations;
> +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
> +				    (1 << PRJQUOTA);

Would it be better to define masks for these rather than open
coding these shifts everywhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
