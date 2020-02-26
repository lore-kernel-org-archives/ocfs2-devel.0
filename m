From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 26 Feb 2020 09:01:19 -0800
Subject: [Ocfs2-devel] [PATCH v8 05/25] mm: Add new readahead_control API
In-Reply-To: <20200225214838.30017-6-willy@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
	<20200225214838.30017-6-willy@infradead.org>
Message-ID: <20200226170119.GA22837@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 01:48:18PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Filesystems which implement the upcoming ->readahead method will get
> their pages by calling readahead_page() or readahead_page_batch().
> These functions support large pages, even though none of the filesystems
> to be converted do yet.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
