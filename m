From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Mon, 28 Jun 2010 15:32:51 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
	<20100624001437.GF20090@mail.oracle.com>
	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
	<20100624005537.GG20090@mail.oracle.com>
	<AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>
	<AANLkTilw7xckG9rpMf9M5NVMNi-PXEw4AXqskPRAVYh0@mail.gmail.com>
	<AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>
	<AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>
Message-ID: <AANLkTikJOtSn1ohvfPgCrKEfBOYsmmYDNe_aFUAsGgZb@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current version of my proposed patch is appended.

The good news is that I have tested it, and it "works for me".

The bad news is that it performs the check fairly late (in
ocfs2_check_volume(), just after the call to ocfs2_journal_load()),
because this is the earliest I have the journal flags available to
test.

We can:

(a) Run with this patch pretty much as-is; or
(b) Move the jbd2_journal_load() call out of ocfs2_journal_load() so
that the flags will be in memory sooner; or
(c) Do something else (ideas welcome)

Let me know what you think.  Thanks!

 - Pat


diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..3db233d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1991,6 +1991,47 @@ static int ocfs2_setup_osb_uuid(struct
ocfs2_super *osb, const unsigned char *uu
 	return 0;
 }

+/* Check to make sure entire volume is addressable on this system.
+   Requires osb_clusters_at_boot to be valid and for the journal to
+   have been read by jbd2_journal_load(). */
+static int ocfs2_check_addressable(struct ocfs2_super *osb)
+{
+	int status = 0;
+	u64 max_block =
+		ocfs2_clusters_to_blocks(osb->sb,
+					 osb->osb_clusters_at_boot) - 1;
+
+	/* Absolute addressability check (borrowed from ext4/super.c) */
+	if ((max_block >
+	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
+	    (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
+					     osb->sb->s_blocksize_bits))) {
+		mlog(ML_ERROR, "Volume too large "
+		     "to mount safely on this system");
+		status = -EFBIG;
+		goto out;
+	}
+
+	/* 32-bit block number is always OK. */
+	if (max_block <= (u32)~0UL)
+		goto out;
+
+	/* Volume is "huge", so see if our journal is new enough to
+	   support it. */
+	if (!(OCFS2_HAS_COMPAT_FEATURE(osb->sb,
+				       OCFS2_FEATURE_COMPAT_JBD2_SB) &&
+	      jbd2_journal_check_used_features(osb->journal->j_journal, 0, 0,
+					       JBD2_FEATURE_INCOMPAT_64BIT))) {
+		mlog(ML_ERROR, "The journal cannot address the entire volume. "
+		     "Enable the 'block64' journal option with tunefs.ocfs2");
+		status = -EFBIG;
+		goto out;
+	}
+
+ out:
+	return status;
+}
+
 static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
 				  int sector_size,
@@ -2215,14 +2256,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}

-	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-	    > (u32)~0UL) {
-		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-		     "what jbd can address in 32 bits.\n");
-		status = -EINVAL;
-		goto bail;
-	}
-
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
@@ -2404,6 +2437,12 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		goto finally;
 	}

+	/* Now that journal has been loaded, check to make sure entire
+	   volume is addressable. */
+	status = ocfs2_check_addressable(osb);
+	if (status)
+		goto finally;
+
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
 		status = ocfs2_begin_local_alloc_recovery(osb,
