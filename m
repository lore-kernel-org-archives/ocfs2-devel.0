From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:15 -0700
Subject: [Ocfs2-devel] [PATCH 0/13] ocfs2: xattr bucket API
Message-ID: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When the extended attribute namespace grows to a b-tree, the leaf
clusters are organized by means of 'buckets'.  Each bucket is 4K in
size, regardless of blocksize.  Thus, a bucket may be made of more than
one block.

fs/ocfs2/xattr.c has a nice little abstraction to wrap this, struct
ocfs2_xattr_bucket.  It contains a list of buffer_heads representing
these blocks, and there is even an API to fill it or initialize it.

However, the majority of the code does not use this abstraction.
Instead, it uses raw buffer_heads and jumps through other hoops.
This has two consequences.  First, it's harder to read.  Second, it is
less efficient.  Sometimes it reads the first and last block of a
bucket, when reading and writing all blocks at once is a streaming I/O.

This series expands the bucket API in a fashion similar to
fs/ocfs2/alloc.c's struct ocfs2_path.  The hope is that all bucket
operations can use this API and mostly avoid raw buffer_head work.

This is also needed for checksums of buckets, as the checksum
calculations need to read the entire bucket.  Since a 4K contig I/O is
just as cheap as a single block, this causes no loss of efficiency.

This path series is on top of my xattr-28 fixes branch.  Before going
upstream it will be rebased on top of at least the divide_bucket fix.
It only touches the xattr_get() and xattr_list() paths, becuase I need
Tao's single-transaction xattr_set() before I can do the xattr_set()
path.

All comments and review welcome.  I hope it's mostly self-explanatory.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=xattr-buckets
Pull:
git://oss.oracle.com/git/jlbec/linux-2.6.git xattr-buckets
