From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 13 Nov 2008 14:49:10 -0800
Subject: [Ocfs2-devel] [PATCH 0/11] Dedicated metadata read functions
Message-ID: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
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

Patch nine is the best - the validation calls are lifted into
ocfs2_read_blocks() via a callback.  If validation is requested, it is
only performed when the block is actually read from disk.  If the block
was in cache, no validation is performed.  Thus, we can do full
validation when a block is read yet not lose performance on subsequent
cached reads.

The last thing we do is turn ocfs2_bread() into a cleaner
ocfs2_read_virt_blocks(), which is like ocfs2_read_blocks() but with a
virtual block number.  Not only can ocfs2_read_dir_block() use this, the
quota read functions will be able to as well.

Joel Becker (11):
      ocfs2: Wrap inode block reads in a dedicated function.
      ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.
      ocfs2: Consolidate validation of group descriptors.
      ocfs2: Wrap group descriptor reads in a dedicated function.
      ocfs2: Morph the haphazard OCFS2_IS_VALID_GROUP_DESC() checks.
      ocfs2: Wrap extent block reads in a dedicated function.
      ocfs2: Wrap dirblock reads in a dedicated function.
      ocfs2: Wrap xattr block reads in a dedicated function
      ocfs2: Validate metadata only when it's read from disk.
      ocfs2: Wrap virtual block reads in ocfs2_read_virt_blocks()
      ocfs2: Convert ocfs2_read_dir_block() to ocfs2_read_virt_blocks()
