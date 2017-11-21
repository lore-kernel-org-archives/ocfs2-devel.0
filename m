From: John Lightsey <john@nixnuts.net>
Date: Tue, 21 Nov 2017 15:05:01 -0600
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7CDDB@H3CMLB14-EX.srv.huawei-3com.com>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
	<1511232309.3644.14.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CDDB@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <1511298301.2735.1.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2017-11-21 at 05:58 +0000, Changwei Ge wrote:

> Can your tell me how did you format your volume?
> What's your _cluster size_ and _block size_?
> Your can obtain such information via debugfs.ocfs2 <your volume> -R?
> 'stats' | grep 'Cluster Size'
> 
> It's better for you provide a way to reproduce this issue so that we
> can?
> perform some test.
> 

The issue recurred in our cluster today, so at best my patch is just
decreasing the frequency of the crashes.

Our setup has 10 machines sharing two OCFS2 mountpoints over fibre
channel.

Both OCFS2 partitions have block size bits set to 12 and cluster size
bits set to 20.

The two partitions contain around 310 files total with 200 of those
being qcow2 files. The only inodes getting any read and write activity
are the qcow2 files.

The qcow2 files were created as sparse files (preallocation=metadata)
and some are reflinked copies.

It's not clear to me exactly why it's passing through
ocfs2_lock_allocators() without allocating meta_ac. These qcow files
wouldn't be written concurrently by different systems in the OCFS2
cluster.

Is it possible the 2 x multiplier in the ocfs2_lock_allocators call is
not large enough?
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171121/29b65745/attachment.bin 
