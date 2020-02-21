From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 21 Feb 2020 07:35:37 -0800
Subject: [Ocfs2-devel] [PATCH v7 11/24] mm: Move end_index check out of
	readahead loop
In-Reply-To: <e6ef2075-b849-299e-0f11-c6ee82b0a3c7@nvidia.com>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-12-willy@infradead.org>
	<e6ef2075-b849-299e-0f11-c6ee82b0a3c7@nvidia.com>
Message-ID: <20200221153537.GE24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:50:39PM -0800, John Hubbard wrote:
> This tiny patch made me pause, because I wasn't sure at first of the exact
> intent of the lines above. Once I worked it out, it seemed like it might
> be helpful (or overkill??) to add a few hints for the reader, especially since
> there are no hints in the function's (minimal) documentation header. What
> do you think of this?
> 
> 	/*
> 	 * If we can't read *any* pages without going past the inodes's isize
> 	 * limit, give up entirely:
> 	 */
> 	if (index > end_index)
> 		return;
> 
> 	/* Cap nr_to_read, in order to avoid overflowing the ULONG type: */
> 	if (index + nr_to_read < index)
> 		nr_to_read = ULONG_MAX - index + 1;
> 
> 	/* Cap nr_to_read, to avoid reading past the inode's isize limit: */
> 	if (index + nr_to_read >= end_index)
> 		nr_to_read = end_index - index + 1;

A little verbose for my taste ... How about this?

        end_index = (isize - 1) >> PAGE_SHIFT;
        if (index > end_index)
                return;
        /* Avoid wrapping to the beginning of the file */
        if (index + nr_to_read < index)
                nr_to_read = ULONG_MAX - index + 1;
        /* Don't read past the page containing the last byte of the file */
        if (index + nr_to_read >= end_index)
                nr_to_read = end_index - index + 1;
