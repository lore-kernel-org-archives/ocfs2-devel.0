From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 18 Jun 2020 18:40:15 +0200
Subject: [Ocfs2-devel] [Cluster-devel] [PATCH v11 16/25] fs: Convert
	mpage_readpages to mpage_readahead
In-Reply-To: <20200618150309.GP8681@bombadil.infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-17-willy@infradead.org>
	<CAHc6FU4m1M7Tv4scX0UxSiVBqkL=Vcw_z-R7SufL8k7Bw=qPOw@mail.gmail.com>
	<20200617003216.GC8681@bombadil.infradead.org>
	<CAHpGcMK6Yu0p-FO8CciiySqh+qcWLG-t3hEaUg-rqJnS=2uhqg@mail.gmail.com>
	<20200617022157.GF8681@bombadil.infradead.org>
	<CAHc6FU7NLRHKRJJ6c2kQT0ig8ed1n+3qR-YcSCWzXOeJCUsLbA@mail.gmail.com>
	<20200618150309.GP8681@bombadil.infradead.org>
Message-ID: <CAHc6FU6TYTiQ0a0GkN1dhh3VeQKVKrL+eALvuYzZ8nq5jvNHjg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel <cluster-devel@redhat.com>, Linux-MM <linux-mm@kvack.org>, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, Bob Peterson <rpeterso@redhat.com>

On Thu, Jun 18, 2020 at 5:03 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jun 18, 2020 at 02:46:03PM +0200, Andreas Gruenbacher wrote:
> > On Wed, Jun 17, 2020 at 4:22 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > On Wed, Jun 17, 2020 at 02:57:14AM +0200, Andreas Gr??nbacher wrote:
> > > > Right, the approach from the following thread might fix this:
> > > >
> > > > https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20191122235324.17245-1-agruenba at redhat.com/T/*t__;Iw!!GqivPVa7Brio!OQW6RpbfPbj1Ov_G7IFgDMsNvz3u9-AxL2C-B5NVzGgeFS-5th97UOFsvz4eGOx7CkkhCA$ 
> > >
> > > In general, I think this is a sound approach.
> > >
> > > Specifically, I think FAULT_FLAG_CACHED can go away.  map_pages()
> > > will bring in the pages which are in the page cache, so when we get to
> > > gfs2_fault(), we know there's a reason to acquire the glock.
> >
> > We'd still be grabbing a glock while holding a dependent page lock.
> > Another process could be holding the glock and could try to grab the
> > same page lock (i.e., a concurrent writer), leading to the same kind
> > of deadlock.
>
> What I'm saying is that gfs2_fault should just be:
>
> +static vm_fault_t gfs2_fault(struct vm_fault *vmf)
> +{
> +       struct inode *inode = file_inode(vmf->vma->vm_file);
> +       struct gfs2_inode *ip = GFS2_I(inode);
> +       struct gfs2_holder gh;
> +       vm_fault_t ret;
> +       int err;
> +
> +       gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
> +       err = gfs2_glock_nq(&gh);
> +       if (err) {
> +               ret = block_page_mkwrite_return(err);
> +               goto out_uninit;
> +       }
> +       ret = filemap_fault(vmf);
> +       gfs2_glock_dq(&gh);
> +out_uninit:
> +       gfs2_holder_uninit(&gh);
> +       return ret;
> +}
>
> because by the time gfs2_fault() is called, map_pages() has already been
> called and has failed to insert the necessary page, so we should just
> acquire the glock now instead of trying again to look for the page in
> the page cache.

Okay, that's great.

Thanks,
Andreas
