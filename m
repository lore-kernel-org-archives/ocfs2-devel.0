From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 16 Oct 2008 02:38:44 -0700
Subject: [Ocfs2-devel] [PATCH 0/8] Dedicated metadata read functions
Message-ID: <1224149932-24381-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch series builds on top of the read_block cleanups to
provide dedicated functions to read the various types of ocfs2 metadata.
Rather than calling ocfs2_read_block[s]() directly, functions wanting an
inode now call ocfs2_read_inode_block().  The same is true for extent
blocks, group descriptors, and dirblocks.  I will get to xattr blocks
later.

The older the metadata type, the more inconsistent the block validation
was.  Sometimes we didn't even check the signature, other times we
checked everything.  As part of the changes, we make sure all validation
happens inside the dedicated function.  The rest of the code no longer
has to check for valid blocks.

The last patch is the best - the validation calls are lifted into
ocfs2_read_blocks() via a callback.  If validation is requested, it is
only performed when the block is actually read from disk.  If the block
was in cache, no validation is performed.  Thus, we can do full
validation when a block is read yet not lose performance on subsequent
cached reads.

Joel
