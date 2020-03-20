From: Namjae Jeon <linkinjeon@gmail.com>
Date: Sat, 21 Mar 2020 08:24:18 +0900
Subject: [Ocfs2-devel] [PATCH v9 16/25] fs: Convert mpage_readpages to
	mpage_readahead
In-Reply-To: <20200320142231.2402-17-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-17-willy@infradead.org>
Message-ID: <CAKYAXd-NGQvMoYg=TV1T=8OZdQcYwcncK_Hix8OkF0GqmYr9Wg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> diff --git a/drivers/staging/exfat/exfat_super.c
> b/drivers/staging/exfat/exfat_super.c
> index b81d2a87b82e..96aad9b16d31 100644
> --- a/drivers/staging/exfat/exfat_super.c
> +++ b/drivers/staging/exfat/exfat_super.c
Maybe, You should change fs/exfat instead of staging/exfat that is
gone from -next ?

> @@ -3002,10 +3002,9 @@ static int exfat_readpage(struct file *file, struct
> page *page)
>  	return  mpage_readpage(page, exfat_get_block);
>  }
>
> -static int exfat_readpages(struct file *file, struct address_space
> *mapping,
> -			   struct list_head *pages, unsigned int nr_pages)
> +static void exfat_readahead(struct readahead_control *rac)
>  {
> -	return  mpage_readpages(mapping, pages, nr_pages, exfat_get_block);
> +	mpage_readahead(rac, exfat_get_block);
>  }
>
>  static int exfat_writepage(struct page *page, struct writeback_control
> *wbc)
> @@ -3104,7 +3103,7 @@ static sector_t _exfat_bmap(struct address_space
> *mapping, sector_t block)
>
>  static const struct address_space_operations exfat_aops = {
>  	.readpage    = exfat_readpage,
> -	.readpages   = exfat_readpages,
> +	.readahead   = exfat_readahead,
>  	.writepage   = exfat_writepage,
>  	.writepages  = exfat_writepages,
>  	.write_begin = exfat_write_begin,
