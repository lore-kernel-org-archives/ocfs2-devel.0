From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Feb  4 19:46:27 2004
Subject: [Ocfs2-devel] Re: [PATCH] Adding ocfs support to blkid
In-Reply-To: <20040205010819.GC3605@thunk.org>
References: <200402040838.i148cCqU002632@penguin.co.intel.com>
	<20040205010819.GC3605@thunk.org>
Message-ID: <20040205014555.GA15920@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2004 at 08:08:19PM -0500, Theodore Ts'o wrote:
> On Wed, Feb 04, 2004 at 12:38:12AM -0800, Rusty Lynch wrote:
> > The following patch adds ocfs support to blkid.
> 
> If I'm reading your probe function implementation correctly, you don't
> actually need to reread the OCFS volume header and label, since the
> first 1k of the filesystem is passed to the probe function in the buf
> parameter.  This is done deliberately because the blkid library tries
> very hard to read each part of the filesystem only once.  
> 
> (There is cache management that goes on in blkid_very_devname() which
> tries to avoid calling llseek/read needlessly, and that's why we pass
> the cached buffer to the probe functions.)
> 
> 						- Ted

Yea, the first 1k off the disk is all I need.  Here is a version that
utilizes the passed in buffer and also contains changes for all previous 
feedback.

    --rusty


# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/04 17:40:55-08:00 rusty@penguin.co.intel.com 
#   There was no need to read off the file descriptor since the 'buf'
#   already holds all the data we need (first 1k off disk.)  Changed
#   ocfs probe to utilize the passed in 'buf'.
# 
# lib/blkid/probe.c
#   2004/02/04 17:40:55-08:00 rusty@penguin.co.intel.com +2 -14
#   There was no need to read off the file descriptor since the 'buf'
#   already holds all the data we need (first 1k off disk.)  Changed
#   ocfs probe to utilize the passed in 'buf'.
# 
# ChangeSet
#   2004/02/04 16:18:29-08:00 rusty@penguin.co.intel.com 
#   Adding SEC_TYPE for ocfs
# 
# lib/blkid/probe.h
#   2004/02/04 16:18:29-08:00 rusty@penguin.co.intel.com +4 -0
#   Adding SEC_TYPE for ocfs
# 
# lib/blkid/probe.c
#   2004/02/04 16:18:29-08:00 rusty@penguin.co.intel.com +10 -1
#   Adding SEC_TYPE for ocfs
# 
# ChangeSet
#   2004/02/04 11:15:08-08:00 rusty@penguin.co.intel.com 
#   Changing name of file system from ocfs2 to ocfs
# 
# lib/blkid/probe.c
#   2004/02/04 11:15:07-08:00 rusty@penguin.co.intel.com +1 -1
#   Changing name of file system from ocfs2 to ocfs
# 
# ChangeSet
#   2004/02/04 00:14:40-08:00 rusty@penguin.co.intel.com 
#   Adding support for the Oracle cluster file system (ocfs)
# 
# BitKeeper/etc/logging_ok
#   2004/02/04 00:14:40-08:00 rusty@penguin.co.intel.com +2 -1
#   Logging to logging@openlogging.org accepted
# 
# lib/blkid/probe.h
#   2004/02/04 00:14:24-08:00 rusty@penguin.co.intel.com +21 -0
#   Adding support for the Oracle cluster file system (ocfs)
# 
# lib/blkid/probe.c
#   2004/02/04 00:14:24-08:00 rusty@penguin.co.intel.com +31 -0
#   Adding support for the Oracle cluster file system (ocfs)
# 
diff -Nru a/lib/blkid/probe.c b/lib/blkid/probe.c
--- a/lib/blkid/probe.c	Wed Feb  4 17:41:04 2004
+++ b/lib/blkid/probe.c	Wed Feb  4 17:41:04 2004
@@ -312,6 +312,33 @@
 	return 1;
 }
 
+static int probe_ocfs(int fd __BLKID_ATTR((unused)), 
+		      blkid_cache cache __BLKID_ATTR((unused)), 
+		      blkid_dev dev,
+		      struct blkid_magic *id __BLKID_ATTR((unused)), 
+		      unsigned char *buf)
+{
+	struct ocfs_volume_header ovh;
+	struct ocfs_volume_label ovl;
+	uint major;
+
+	memcpy(&ovh, buf, sizeof(ovh));
+	memcpy(&ovl, buf+512, sizeof(ovl));
+
+	major = ocfsmajor(ovh);
+	if (major == 1)
+		blkid_set_tag(dev,"SEC_TYPE","ocfs1",sizeof("ocfs1"));
+	else if (major == 2)
+		blkid_set_tag(dev,"SEC_TYPE","ocfs2",sizeof("ocfs2"));
+	else if (major >= 9)
+		blkid_set_tag(dev,"SEC_TYPE","ntocfs",sizeof("ntocfs"));
+	
+	blkid_set_tag(dev, "LABEL", ovl.label, ocfslabellen(ovl));
+	blkid_set_tag(dev, "MOUNT", ovh.mount, ocfsmountlen(ovh));
+	set_uuid(dev, ovl.vol_id);
+	return 0;
+}
+
 /*
  * BLKID_BLK_OFFS is at least as large as the highest bim_kboff defined
  * in the type_array table below + bim_kbalign.
@@ -371,6 +398,7 @@
   { "swap",	 0, 0x1ff6, 10, "SWAPSPACE2",		0 },
   { "swap",	 0, 0x3ff6, 10, "SWAP-SPACE",		0 },
   { "swap",	 0, 0x3ff6, 10, "SWAPSPACE2",		0 },
+  { "ocfs",	 0,	 8,  9,	 "OracleCFS",  probe_ocfs },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 
diff -Nru a/lib/blkid/probe.h b/lib/blkid/probe.h
--- a/lib/blkid/probe.h	Wed Feb  4 17:41:04 2004
+++ b/lib/blkid/probe.h	Wed Feb  4 17:41:04 2004
@@ -209,6 +209,31 @@
 	__u32	h_blksize;
 };
 
+struct ocfs_volume_header {
+	u_char	minor_version[4];
+	u_char	major_version[4];
+	u_char	signature[128];
+	u_char  mount[128];
+	u_char  mount_len[2];
+};
+
+struct ocfs_volume_label {
+	u_char	disk_lock[48];
+	u_char	label[64];	
+	u_char	label_len[2];
+	u_char  vol_id[16];
+	u_char  vol_id_len[2];
+};
+
+#define ocfsmajor(o) ((uint)o.major_version[0] \
+                   + (((uint) o.major_version[1]) << 8) \
+                   + (((uint) o.major_version[2]) << 16) \
+                   + (((uint) o.major_version[3]) << 24))
+#define ocfslabellen(o)	((uint)o.label_len[0] + (((uint) o.label_len[1]) << 8))
+#define ocfsmountlen(o)	((uint)o.mount_len[0] + (((uint) o.mount_len[1])<<8))
+
+#define OCFS_MAGIC "OracleCFS"
+
 #define ISODCL(from, to) (to - from + 1)
 struct iso_volume_descriptor {
 	char type[ISODCL(1,1)]; /* 711 */
