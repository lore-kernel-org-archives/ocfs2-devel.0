From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 08 Jul 2010 11:44:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: When zero extending,
	do it by page.
In-Reply-To: <1278501367-7710-2-git-send-email-joel.becker@oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
	<1278501367-7710-2-git-send-email-joel.becker@oracle.com>
Message-ID: <4C3549BB.2000906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

Hi Joel,

On 07/07/2010 07:16 PM, Joel Becker wrote:
> ocfs2_zero_extend() does its zeroing block by block, but it calls a
> function named ocfs2_write_zero_page().  Let's have
> ocfs2_write_zero_page() handle the page level.  From
> ocfs2_zero_extend()'s perspective, it is now page-at-a-time.
>
> Signed-off-by: Joel Becker<joel.becker@oracle.com>
> ---
>   fs/ocfs2/aops.c |   30 --------------
>   fs/ocfs2/file.c |  119 +++++++++++++++++++++++++++++++++++++++----------------
>   2 files changed, 85 insertions(+), 64 deletions(-)
>
<snip>
> -static int ocfs2_write_zero_page(struct inode *inode,
> -				 u64 size)
> +static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
> +				 u64 abs_to)
>   {
>   	struct address_space *mapping = inode->i_mapping;
>   	struct page *page;
> -	unsigned long index;
> -	unsigned int offset;
> +	unsigned long index = abs_from>>  PAGE_CACHE_SHIFT;
>   	handle_t *handle = NULL;
>   	int ret;
> +	unsigned zero_from, zero_to, block_start, block_end;
>
> -	offset = (size&  (PAGE_CACHE_SIZE-1)); /* Within page */
> -	/* ugh.  in prepare/commit_write, if from==to==start of block, we
> -	** skip the prepare.  make sure we never send an offset for the start
> -	** of a block
> -	*/
> -	if ((offset&  (inode->i_sb->s_blocksize - 1)) == 0) {
> -		offset++;
> -	}
> -	index = size>>  PAGE_CACHE_SHIFT;
> +	BUG_ON(abs_from>= abs_to);
> +	BUG_ON(abs_to>  ((index + 1)<<  PAGE_CACHE_SHIFT));
Sorry for not noticing this yesterday night. This can't work and will 
overflow and bug out. I met with a similar bug in reflink test. See 
commit d622b89.
> +	BUG_ON(abs_from&  (inode->i_blkbits - 1));
>
>   	page = grab_cache_page(mapping, index);
>   	if (!page) {
> @@ -754,31 +781,52 @@ static int ocfs2_write_zero_page(struct inode *inode,
>   		goto out;
>   	}
>
> -	ret = ocfs2_prepare_write_nolock(inode, page, offset, offset);
> -	if (ret<  0) {
> -		mlog_errno(ret);
> -		goto out_unlock;
> -	}
> +	/* Get the offsets within the page that we want to zero */
> +	zero_from = abs_from&  (PAGE_CACHE_SIZE - 1);
> +	zero_to = abs_to&  (PAGE_CACHE_SIZE - 1);
> +	if (!zero_to)
> +		zero_to = PAGE_CACHE_SIZE;
>
> -	if (ocfs2_should_order_data(inode)) {
> -		handle = ocfs2_start_walk_page_trans(inode, page, offset,
> -						     offset);
> -		if (IS_ERR(handle)) {
> -			ret = PTR_ERR(handle);
> -			handle = NULL;
> +	/* We know that zero_from is block aligned */
> +	for (block_start = zero_from;
> +	     (block_start<  PAGE_CACHE_SIZE)&&  (block_start<  zero_to);
> +	     block_start = block_end) {
Do we really need to check block_start < PAGE_CACHE_SIZE? I think just 
check block_start < zero_to is enough since you have limit zero_to with 
PAGE_CACHE_SIZE. What's more, it looks more natural(see below), does it?

	for (block_start = zero_form; block_start < zero_to; block_start = 
block_end) {

Regards,
Tao
