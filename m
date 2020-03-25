From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Mar 2020 15:43:02 +0100
Subject: [Ocfs2-devel] [PATCH v10 24/25] fuse: Convert from readpages to
	readahead
In-Reply-To: <20200325120254.GA22483@bombadil.infradead.org>
References: <20200323202259.13363-1-willy@infradead.org>
	<20200323202259.13363-25-willy@infradead.org>
	<CAJfpegu7EFcWrg3bP+-2BX_kb52RrzBCo_U3QKYzUkZfe4EjDA@mail.gmail.com>
	<20200325120254.GA22483@bombadil.infradead.org>
Message-ID: <CAJfpegshssCJiA8PBcq2XvBj3mR8dufHb0zWRFvvKKv82VQYsw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 25, 2020 at 1:02 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Mar 25, 2020 at 10:42:56AM +0100, Miklos Szeredi wrote:
> > > +       while ((page = readahead_page(rac))) {
> > > +               if (fuse_readpages_fill(&data, page) != 0)
> >
> > Shouldn't this unlock + put page on error?
>
> We're certainly inconsistent between the two error exits from
> fuse_readpages_fill().  But I think we can simplify the whole thing
> ... how does this look to you?

Nice, overall.

>
> -       while ((page = readahead_page(rac))) {
> -               if (fuse_readpages_fill(&data, page) != 0)
> +               nr_pages = min(readahead_count(rac), fc->max_pages);

Missing fc->max_read clamp.

> +               ia = fuse_io_alloc(NULL, nr_pages);
> +               if (!ia)
>                         return;
> +               ap = &ia->ap;
> +               __readahead_batch(rac, ap->pages, nr_pages);

nr_pages = __readahead_batch(...)?

This will give consecutive pages, right?

Thanks,
Miklos
