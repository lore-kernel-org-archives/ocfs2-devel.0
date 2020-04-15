From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 14 Apr 2020 18:17:05 -0700
Subject: [Ocfs2-devel] [PATCH v11 05/25] mm: Add new readahead_control
	API
In-Reply-To: <20200414150233.24495-6-willy@infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-6-willy@infradead.org>
Message-ID: <20200414181705.bfc4c0087092051a9475141e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, William Kucharski <william.kucharski@oracle.com>

On Tue, 14 Apr 2020 08:02:13 -0700 Matthew Wilcox <willy@infradead.org> wrote:

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Filesystems which implement the upcoming ->readahead method will get
> their pages by calling readahead_page() or readahead_page_batch().
> These functions support large pages, even though none of the filesystems
> to be converted do yet.
> 
> +static inline struct page *readahead_page(struct readahead_control *rac)
> +static inline unsigned int __readahead_batch(struct readahead_control *rac,
> +		struct page **array, unsigned int array_sz)

These are large functions.  Was it correct to inline them?

The batching API only appears to be used by fuse?  If so, do we really
need it?  Does it provide some functional need, or is it a performance
thing?  If the latter, how significant is it?

The code adds quite a few (inlined!) VM_BUG_ONs.  Can we plan to remove
them at some stage?  Such as, before Linus shouts at us :)
