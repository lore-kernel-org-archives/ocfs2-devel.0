From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb  3 22:48:36 2004
Subject: [Ocfs2-devel] [PATCH] ocfs2 support for blkid utility
Message-ID: <200402040448.i144mMld031531@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a an email thread on the Data Center Linux (DCL) working group mailing
list about a proposed requirement for persistant device naming, Theodore Ts'o
noted that his blkid utility in the e2fsprog package could be used as part
of a persistent device naming implementation.

<<<<<<<<<<<<<< CUT 

On Tue, Feb 03, 2004@08:21:33AM -0800, Rusty Lynch wrote:
> 
> Can you point me to some documentation on how to add support for other 
> filesystems.  I just recently started working with ocfs, and it looks 
> like blkid is not picking up and partitions formated for ocfs.
> 

No documentation, I'm afraid, although adding support for ocfs should
be fairly straightforward.  The relevant file is
e2fsprogs/lib/blkid/probe.c.  If the filesystem has a straightforward
magic number, it can just be placed in the blk_magic type array:

/*
 * Various filesystem magics that we can check for.  Note that kboff and
 * sboff are in kilobytes and bytes respectively.  All magics are in
 * byte strings so we don't worry about endian issues.
 */
static struct blkid_magic type_array[] = {
/*  type     kboff   sboff len  magic			probe */
	...
  { "xfs",	 0,	 0,  4, "XFSB",			probe_xfs },
	...
}

The probe function (probe_xfs in this case) can also be used to do a
more refined test.  The probe function is responsible for setting the
label and uuid information for the filesystem, or else returning a
non-zero value if it turns out that the filesystem is not of the
specified type.  lib/blkid/probe.c probably could be more paranoid
about identifying filesystems, but to date no one has reported any
false positives so I haven't bothered to put in more stringent tests.
(See the probe_reiserfs() function for an example of the sort of extra
testing that can be done to make sure the superblock is consistent.)
As always, patches are welcome.  :-)

						- Ted

P.S.  I'm about to release a new e2fsprogs release soon, so if you
have some additional filesystems that should be added (blkid currently
supports ext2, ext3, jbd, jfs, xfs, reiserfs, minix, vfat, msdos,
ntfs, hfs, vxfs, hpfs, sysv, romfs, bfs, cramfs, qnx4, udf, iso9660,
and swap, with LABEL and/or UUID support for all filesystems that
support such labelling), please let me know.  I'm aiming for blkid to
be as complete as possible.

>>>>>>>>>>>>>> CUT

So... I downloaded the e2fsprog source tree and hacked the following
patch that adds ocfs2 support.

In the probe_ocfs() function, buf contains the first kbytes of data
from the disk, and I just grab the label, suggested mount point, and
UUID by indexing into buf.

Some of the other probe functions define their super block structure
in an e2fsprog header file, and then just cast buf to their own 
super block.  Since ocfs2 structures are considerably more complex, 
I just went with the offset method.

This code would totally break if ocfs2 changes the layout of the first
kbyte on disk.  Are there any plans to change this?

Would anyone have a problem with me submitting this to the e2fsprogs
project?

    --rusty

--- probe.c	2004-02-03 20:18:42.000000000 -0800
+++ /home/rusty/probe.c	2004-02-03 20:21:50.000000000 -0800
@@ -312,6 +312,27 @@
 	return 1;
 }
 
+static int probe_ocfs(int fd __BLKID_ATTR((unused)), 
+		      blkid_cache cache __BLKID_ATTR((unused)), 
+		      blkid_dev dev,
+		      struct blkid_magic *id __BLKID_ATTR((unused)), 
+		      unsigned char *buf)
+{
+	char *label = 0;
+	char *mount_point = 0;
+	
+	if (strlen((char *) (buf + 0x230)))
+		label = (char *) (buf + 0x230);	
+	blkid_set_tag(dev, "LABEL", label, 64);
+	
+	if (strlen((char *) (buf + 0x88)))
+		mount_point = (char *) (buf + 0x88);	
+	blkid_set_tag(dev, "MOUNT", mount_point, 128);
+
+	set_uuid(dev, (char *)(buf + 0x272));
+	return 0;
+}
+
 /*
  * BLKID_BLK_OFFS is at least as large as the highest bim_kboff defined
  * in the type_array table below + bim_kbalign.
@@ -371,6 +392,7 @@
   { "swap",	 0, 0x1ff6, 10, "SWAPSPACE2",		0 },
   { "swap",	 0, 0x3ff6, 10, "SWAP-SPACE",		0 },
   { "swap",	 0, 0x3ff6, 10, "SWAPSPACE2",		0 },
+  { "ocfs2",	 0,	 8,  9,	 "OracleCFS",  probe_ocfs },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 
