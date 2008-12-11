From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 11 Dec 2008 10:46:33 +0800
Subject: [Ocfs2-devel] [PATCH 0/18] ocfs2: Add metadata ECC - almost
	there.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <49407F09.8030403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> These patches add the metadata ECC code to ocfs2.  They have one
> limitation - they do not ECC directory blocks yet.  However, that will
> only take a simple insertion of the dirblock trailer.  With xattr ECC
> completed, the patches are approaching a final form and are ready for
> initial review.  They are atop my xattr-buckets-2 branch.
> 
> The first patch adds buffer triggers to JDB2.  This allows us to only
> calculate the ECC code when JBD2 is about to write a block to disk.
> 
> Next, we add the actual blockcheck functions.  These are the functions
> that compute the checksum (using the kernel's crc32_le()) and the ECC
> bits (this is hamming code, implemented in blockcheck.c).
> 
> Then we create metadata-type specific ocfs2_journal_access_*() functions
> to make sure each metadata type uses its own checksum field.  These are
> hooked up to the regular metadata types.
> 
> We add ecc calculation to xattr buckets.  Because buckets can be
> multiple blocks, they cannot use journal triggers.  However, they are
> rarely updated, so the loss of efficiency isn't very important.
> 
> Last, we refactor the xattr value setting code to make sure we know
> which metadata type an xattr value belongs to.  That way we can call the
> appropriate ocfs2_journal_access_*() function.
> 
> The code is also available in my repository.
> 
> [View]
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=metaecc
> [Pull]
> git://oss.oracle.com/git/jlbec/linux-2.6.git metaecc
> 
> Joel Becker (18):
>       jbd2: Add buffer triggers
>       ocfs2: Add the on-disk structures for metadata checksums.
>       ocfs2: Add the underlying blockcheck code.
>       ocfs2: Add a validation hook for quota block reads.
>       ocfs2: block read meta ecc.
>       ocfs2: Add journal_access functions with jbd2 triggers.
>       ocfs2: Wrap up the common use cases of ocfs2_new_path().
>       ocfs2: Use metadata-specific ocfs2_journal_access_*() functions.
>       ocfs2: Add ecc and checksums to ocfs2 xattr buckets.
>       ocfs2: Create ocfs2_xattr_value_buf.
>       ocfs2: Pull ocfs2_xattr_value_buf up from __ocfs2_remove_xattr_range().
>       ocfs2: Pull ocfs2_xattr_value_buf up into ocfs2_xattr_value_truncate().
>       ocfs2: Pass ocfs2_xattr_value_buf into ocfs2_xattr_value_truncate().
>       ocfs2: Pass value buf to ocfs2_xattr_update_entry().
>       ocfs2: Use ocfs2_xattr_value_buf in ocfs2_xattr_set_entry().
>       ocfs2: Pass value buf to ocfs2_remove_value_outside().
>       ocfs2: Use proper journal_access function in xattr.c
>       ocfs2: Enable metadata checksums.

Acked-by: Tao Ma <tao.ma@oracle.com>
> 
> 
