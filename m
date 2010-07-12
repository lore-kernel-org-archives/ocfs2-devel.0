From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 02:14:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't duplicate page passes i_size
	during CoW.
In-Reply-To: <1278919188-4119-1-git-send-email-tao.ma@oracle.com>
References: <1278919188-4119-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100712091412.GA19583@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 12, 2010 at 03:19:48PM +0800, Tao Ma wrote:
> During CoW, actually all the pages after i_size contains
> garbage data, so don't read and duplicate them.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/refcounttree.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 1cf9cda..e082623 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2921,7 +2921,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
>  	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
>  	struct page *page;
> -	pgoff_t page_index;
> +	pgoff_t page_index, last_page;
>  	unsigned int from, to;
>  	loff_t offset, end, map_end;
>  	struct address_space *mapping = context->inode->i_mapping;
> @@ -2932,12 +2932,20 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
>  	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
>  
> +	last_page = i_size_read(context->inode) >> PAGE_CACHE_SHIFT;
>  	while (offset < end) {

	Why trigger on both index and byte offset?  Why not just adjust
end?

	if (end < i_size_read(context->inode))
		end = i_size_read(inode);
	
	Then you don't need the last_page variable at all, because
you're guaranteed never to go past i_size.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
