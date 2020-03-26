From: David Sterba <dsterba@suse.cz>
Date: Thu, 26 Mar 2020 17:53:56 +0100
Subject: [Ocfs2-devel] [PATCH v10 17/25] btrfs: Convert from readpages
	to readahead
In-Reply-To: <20200323202259.13363-18-willy@infradead.org>
References: <20200323202259.13363-1-willy@infradead.org>
	<20200323202259.13363-18-willy@infradead.org>
Message-ID: <20200326165356.GI5920@twin.jikos.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 23, 2020 at 01:22:51PM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Implement the new readahead method in btrfs using the new
> readahead_page_batch() function.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Sorry for late reply,

Reviewed-by: David Sterba <dsterba@suse.com>
