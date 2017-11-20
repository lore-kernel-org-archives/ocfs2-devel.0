From: John Lightsey <john@nixnuts.net>
Date: Mon, 20 Nov 2017 12:54:50 -0600
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
Message-ID: <1511204090.3644.6.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In January Ben Hutchings reported Debian bug 841144 to the ocfs2-devel
list:

https://oss.oracle.com/pipermail/ocfs2-devel/2017-January/012701.html

cPanel encountered this bug after upgrading our cluster to the 4.9
Debian stable kernel. In our environment, the bug would trigger every
few hours.

The core problem seems to be that the size of dw_zero_list is not
tracked correctly. This causes the ocfs2_lock_allocators() call in
ocfs2_dio_end_io_write() to underestimate the number of extents needed.
As a result, meta_ac is null when it's needed in ocfs2_grow_tree().

The attached patch is a forward-ported version of the fix we applied to
Debian's 4.9 kernel to correct the issue.

-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-Fix-OCFS2-extent-split-estimation-for-dio-allocators.patch
Type: text/x-patch
Size: 1712 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171120/be39dbe1/attachment.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171120/be39dbe1/attachment-0001.bin 
