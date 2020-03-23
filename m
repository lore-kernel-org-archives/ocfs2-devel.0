From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Sun, 22 Mar 2020 20:53:46 -0700
Subject: [Ocfs2-devel] [f2fs-dev] [PATCH v9 23/25] f2fs: Pass the inode
 to f2fs_mpage_readpages
In-Reply-To: <20200320142231.2402-24-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-24-willy@infradead.org>
Message-ID: <20200323035346.GA147648@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/20, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This function now only uses the mapping argument to look up the inode,
> and both callers already have the inode, so just pass the inode instead
> of the mapping.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  fs/f2fs/data.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 237dff36fe73..c8b042979fc4 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2159,12 +2159,11 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   * use ->readpage() or do the necessary surgery to decouple ->readpages()
>   * from read-ahead.
>   */
> -static int f2fs_mpage_readpages(struct address_space *mapping,
> +static int f2fs_mpage_readpages(struct inode *inode,
>  		struct readahead_control *rac, struct page *page)
>  {
>  	struct bio *bio = NULL;
>  	sector_t last_block_in_bio = 0;
> -	struct inode *inode = mapping->host;
>  	struct f2fs_map_blocks map;
>  #ifdef CONFIG_F2FS_FS_COMPRESSION
>  	struct compress_ctx cc = {
> @@ -2276,7 +2275,7 @@ static int f2fs_read_data_page(struct file *file, struct page *page)
>  	if (f2fs_has_inline_data(inode))
>  		ret = f2fs_read_inline_data(inode, page);
>  	if (ret == -EAGAIN)
> -		ret = f2fs_mpage_readpages(page_file_mapping(page), NULL, page);
> +		ret = f2fs_mpage_readpages(inode, NULL, page);
>  	return ret;
>  }
>  
> @@ -2293,7 +2292,7 @@ static void f2fs_readahead(struct readahead_control *rac)
>  	if (f2fs_has_inline_data(inode))
>  		return;
>  
> -	f2fs_mpage_readpages(rac->mapping, rac, NULL);
> +	f2fs_mpage_readpages(inode, rac, NULL);
>  }
>  
>  int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
> -- 
> 2.25.1
> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel at lists.sourceforge.net
> https://urldefense.com/v3/__https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel__;!!GqivPVa7Brio!IJbTU5z5fcF0j904x5GKv8Aa9GLezjWPPUGuz_efqEqqGi1HjuvrQWqR4ZDYvbjeGc8ZlQ$ 
