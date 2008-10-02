From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:11:56 -0700
Subject: [Ocfs2-devel] [PATCH 10/39] ocfs2: Add helper function in
 uptodate.c for removing xattr clusters
In-Reply-To: <1222293680-15451-11-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-11-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231156.c52c98b5.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tao.ma@oracle.com

> On Wed, 24 Sep 2008 15:00:51 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +/* Called when we remove xattr clusters from an inode. */
> +void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
> +					    sector_t block,
> +					    u32 c_len)
> +{
> +	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
> +
> +	for (i = 0; i < b_len; i++, block++)
> +		ocfs2_remove_block_from_cache(inode, block);
> +}

I really really hope that `i' and `b_len' didn't really need to be
64-bit here.
