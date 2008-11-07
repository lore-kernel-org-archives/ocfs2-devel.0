From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 7 Nov 2008 13:21:14 -0800
Subject: [Ocfs2-devel] [PATCH 0/13] ocfs2: xattr bucket API
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20081107212114.GN15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 27, 2008 at 06:20:15PM -0700, Joel Becker wrote:
> When the extended attribute namespace grows to a b-tree, the leaf
> clusters are organized by means of 'buckets'.  Each bucket is 4K in
> size, regardless of blocksize.  Thus, a bucket may be made of more than
> one block.
> 
> fs/ocfs2/xattr.c has a nice little abstraction to wrap this, struct
> ocfs2_xattr_bucket.  It contains a list of buffer_heads representing
> these blocks, and there is even an API to fill it or initialize it.
> 
> However, the majority of the code does not use this abstraction.
> Instead, it uses raw buffer_heads and jumps through other hoops.
> This has two consequences.  First, it's harder to read.  Second, it is
> less efficient.  Sometimes it reads the first and last block of a
> bucket, when reading and writing all blocks at once is a streaming I/O.
> 
> This series expands the bucket API in a fashion similar to
> fs/ocfs2/alloc.c's struct ocfs2_path.  The hope is that all bucket
> operations can use this API and mostly avoid raw buffer_head work.
> 
> This is also needed for checksums of buckets, as the checksum
> calculations need to read the entire bucket.  Since a 4K contig I/O is
> just as cheap as a single block, this causes no loss of efficiency.
> 
> This path series is on top of my xattr-28 fixes branch.  Before going
> upstream it will be rebased on top of at least the divide_bucket fix.
> It only touches the xattr_get() and xattr_list() paths, becuase I need
> Tao's single-transaction xattr_set() before I can do the xattr_set()
> path.
> 
> All comments and review welcome.  I hope it's mostly self-explanatory.

This looks great.

I rebased your branch and added my signoffs to start the new merge_window
branch. Tao, this includes your latest fixes. Once Tao and Tiger have an
updated set of acl / security attr patches, I'll drop those in right on top.

One thing though - your patches are built on top of our 'fixes' branch,
which is great for merging down the line. Right now, merge_window will just
live alone, until Linus pulls our fixes. Once that happens, I'll rebase
merge_window one more time and start pulling it into linux-next / ALL
branches.

Sound good?
	--Mark

--
Mark Fasheh
