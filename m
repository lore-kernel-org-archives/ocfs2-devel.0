From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 15:47:21 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] adds mlogs to aops.c
In-Reply-To: <200907130339.n6D3d7pB018215@rgminet15.oracle.com>
References: <200907130339.n6D3d7pB018215@rgminet15.oracle.com>
Message-ID: <20090720224720.GC7768@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 13, 2009 at 11:37:39AM +0800, Wengang Wang wrote:
> @@ -217,11 +219,16 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  	void *kaddr;
>  	loff_t size;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	int status = 0;
> +
> +	mlog_entry("(%llu, %lu, %llu)\n", OCFS2_I(inode)->ip_blkno,
> +		   page->index, (unsigned long long)di_bh->b_blocknr);

	You're printing OCFS2_I(inode)->ip_blkno with %llu but not
casting it to unsigned long long.  It needs those casts for stricter
platforms.  Make sure all your u64 mlog additions have the cast.

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
