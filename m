From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 16:27:24 +0800
Subject: [Ocfs2-devel] [PATCH 0/4] Add readahead support in CoW for
	reflinked files.
Message-ID: <4C29AE6C.1050205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	When we try to CoW some clusters for a reflinked file, we have to read 
the contents first, allocate some clusters and then map these pages to 
the new clusters. Currently, we use block_read_full_page to read it, but 
it is a little bit slower.
	So this patch set try to add readahead support for CoW. Before we 
start, we call readahead first so that the pages can be read at the very 
first. And during CoW, when we find a readahead page, we know that we 
need to move the readahead window, so a new asyncreadahead is called.

I have a small test to show how readahead speed up CoW.
readahead_test()
{
MNT_DIR=/mnt/ocfs2
DEVICE=/dev/sda8
echo 'y'|mkfs.ocfs2 --fs-features=local,refcount $DEVICE
mount -t ocfs2 $DEVICE $MNT_DIR
FILE=$MNT_DIR/$RANDOM
REFLINK=$MNT_DIR/$RANDOM
dd if=/dev/zero of=$FILE bs=1M count=1000
reflink $FILE $REFLINK
dd if=/dev/zero of=$REFLINK bs=1M count=1000 conv=notrunc
umount $MNT_DIR
}

Without these patch set, the 2nd dd has a i/o speed of 22MB/s.
with the patch set, the i/o speed is increased to about 40MB/s.

Any comments are welcomed.

Regards,
Tao
