From: tristan <tristan.ye@oracle.com>
Date: Thu, 15 Jul 2010 09:15:24 +0800
Subject: [Ocfs2-devel] [PATCH v5] ocfs2: Don't duplicate page passes
 i_size during CoW.
In-Reply-To: <1279077572-9017-1-git-send-email-tao.ma@oracle.com>
References: <20100713183828.GA9468@mail.oracle.com>
	<1279077572-9017-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4C3E612C.30508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tested-by: Tristan Ye <tristan.ye@oracle.com>

Tao Ma wrote:
> During CoW, actually all the pages after i_size contains
> garbage data, so don't read and duplicate them.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/refcounttree.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 1cf9cda..5e03db2 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2931,6 +2931,12 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  
>  	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
>  	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
> +	/*
> +	 * We only duplicate pages until we reach the page contains i_size - 1.
> +	 * So trim 'end' to i_size.
> +	 */
> +	if (end > i_size_read(context->inode))
> +		end = i_size_read(context->inode);
>  
>  	while (offset < end) {
>  		page_index = offset >> PAGE_CACHE_SHIFT;
