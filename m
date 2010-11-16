From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Date: Tue, 16 Nov 2010 16:21:21 -0000
Subject: [Ocfs2-devel] [PATCH 4/6] Ext4: fail if we try to use hole punch
In-Reply-To: <1289840723-3056-5-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
Message-ID: <4CE2AF5B.7020500@draigBrady.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On 15/11/10 17:05, Josef Bacik wrote:
> Ext4 doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> be added later.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ext4/extents.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0554c48..35bca73 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits = inode->i_blkbits;
>  
> +	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> +	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_

So for older versions of ext4 or other filesystems, how do we know
that fallocate(...,FALLOC_FL_PUNCH_HOLE) is not supported.
I.E. how do we detect at runtime that the call succeeded
and didn't just do a normal fallocate()?

cheers,
P?draig.
