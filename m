From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Mar 2020 10:42:56 +0100
Subject: [Ocfs2-devel] [PATCH v10 24/25] fuse: Convert from readpages to
	readahead
In-Reply-To: <20200323202259.13363-25-willy@infradead.org>
References: <20200323202259.13363-1-willy@infradead.org>
	<20200323202259.13363-25-willy@infradead.org>
Message-ID: <CAJfpegu7EFcWrg3bP+-2BX_kb52RrzBCo_U3QKYzUkZfe4EjDA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 23, 2020 at 9:23 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Use the new readahead operation in fuse.  Switching away from the
> read_cache_pages() helper gets rid of an implicit call to put_page(),
> so we can get rid of the get_page() call in fuse_readpages_fill().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  fs/fuse/file.c | 46 +++++++++++++++++++---------------------------
>  1 file changed, 19 insertions(+), 27 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 9d67b830fb7a..5749505bcff6 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -923,9 +923,8 @@ struct fuse_fill_data {
>         unsigned int max_pages;
>  };
>
> -static int fuse_readpages_fill(void *_data, struct page *page)
> +static int fuse_readpages_fill(struct fuse_fill_data *data, struct page *page)
>  {
> -       struct fuse_fill_data *data = _data;
>         struct fuse_io_args *ia = data->ia;
>         struct fuse_args_pages *ap = &ia->ap;
>         struct inode *inode = data->inode;
> @@ -941,10 +940,8 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>                                         fc->max_pages);
>                 fuse_send_readpages(ia, data->file);
>                 data->ia = ia = fuse_io_alloc(NULL, data->max_pages);
> -               if (!ia) {
> -                       unlock_page(page);
> +               if (!ia)
>                         return -ENOMEM;
> -               }
>                 ap = &ia->ap;
>         }
>
> @@ -954,7 +951,6 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>                 return -EIO;
>         }
>
> -       get_page(page);
>         ap->pages[ap->num_pages] = page;
>         ap->descs[ap->num_pages].length = PAGE_SIZE;
>         ap->num_pages++;
> @@ -962,37 +958,33 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>         return 0;
>  }
>
> -static int fuse_readpages(struct file *file, struct address_space *mapping,
> -                         struct list_head *pages, unsigned nr_pages)
> +static void fuse_readahead(struct readahead_control *rac)
>  {
> -       struct inode *inode = mapping->host;
> +       struct inode *inode = rac->mapping->host;
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_fill_data data;
> -       int err;
> +       struct page *page;
>
> -       err = -EIO;
>         if (is_bad_inode(inode))
> -               goto out;
> +               return;
>
> -       data.file = file;
> +       data.file = rac->file;
>         data.inode = inode;
> -       data.nr_pages = nr_pages;
> -       data.max_pages = min_t(unsigned int, nr_pages, fc->max_pages);
> -;
> +       data.nr_pages = readahead_count(rac);
> +       data.max_pages = min_t(unsigned int, data.nr_pages, fc->max_pages);
>         data.ia = fuse_io_alloc(NULL, data.max_pages);
> -       err = -ENOMEM;
>         if (!data.ia)
> -               goto out;
> +               return;
>
> -       err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
> -       if (!err) {
> -               if (data.ia->ap.num_pages)
> -                       fuse_send_readpages(data.ia, file);
> -               else
> -                       fuse_io_free(data.ia);
> +       while ((page = readahead_page(rac))) {
> +               if (fuse_readpages_fill(&data, page) != 0)

Shouldn't this unlock + put page on error?

Otherwise looks good.

Thanks,
Miklos
