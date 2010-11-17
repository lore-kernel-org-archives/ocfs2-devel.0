From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Nov 2010 15:21:49 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
 __ocfs2_page_mkwrite()
In-Reply-To: <201011050455.oA52fktp020706@rcsinet15.oracle.com>
References: <201011050455.oA52fktp020706@rcsinet15.oracle.com>
Message-ID: <20101117232149.GE25677@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 05, 2010 at 12:53:16PM +0800, Wengang Wang wrote:

	Here's review based on the assumption we need this change.

> @@ -1097,6 +1097,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  	unsigned long start, target_index, end_index, index;
>  	struct inode *inode = mapping->host;
>  	loff_t last_byte;
> +	int lockpg= !PageLocked(mmap_page);

	This change is not necessary.  If mmap_page exists, it came from
__ocfs2_page_mkwrite(), where you've locked it, so you know it is
locked.

>  
>  	target_index = user_pos >> PAGE_CACHE_SHIFT;
>  
> @@ -1133,11 +1134,15 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  			 * ocfs2_pagemkwrite() is a little different
>  			 * and wants us to directly use the page
>  			 * passed in.
> +			 * in ocfs2_page_mkwirte() path, the page is already
> +			 * locked, don't lock it again.
>  			 */
> -			lock_page(mmap_page);
> +			if (lockpg)
> +				lock_page(mmap_page);

	This block is only accessed when mmap_page is not NULL.  Thus
the page must exist and must be locked (as stated above).  You should
just BUG_ON(!PageLocked(mmap_page)) here.

Joel

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
