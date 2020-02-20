From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 20 Feb 2020 07:54:52 -0800
Subject: [Ocfs2-devel] [PATCH v7 14/24] btrfs: Convert from readpages to
	readahead
In-Reply-To: <20200220154658.GA19577@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-15-willy@infradead.org>
	<SN4PR0401MB35987D7B76007B93B1C5CE5E9B130@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20200220134849.GV24185@bombadil.infradead.org>
	<20200220154658.GA19577@infradead.org>
Message-ID: <20200220155452.GX24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Thu, Feb 20, 2020 at 07:46:58AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 05:48:49AM -0800, Matthew Wilcox wrote:
> > btrfs: Convert from readpages to readahead
> >   
> > Implement the new readahead method in btrfs.  Add a readahead_page_batch()
> > to optimise fetching a batch of pages at once.
> 
> Shouldn't this readahead_page_batch heper go into a separate patch so
> that it clearly stands out?

I'll move it into 'Put readahead pages in cache earlier' for v8 (the
same patch where we add readahead_page())
