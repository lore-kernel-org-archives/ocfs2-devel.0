From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Wed, 23 Jun 2010 17:04:49 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <20100623013633.GC20090@mail.oracle.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
Message-ID: <AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 6:36 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
>
> ? ? ? ?JBD2_FEATURE_INCOMPAT_64BIT. ?You'll need to call
> jbd2_journal_check_used_features() to see if the journal has it enabled.
> Before you can do that, you have to ensure that the filesystem has the
> OCFS2_FEATURE_COMPAT_JBD2_SB feature enabled.
>
> ? ? ? ?sector_t. ?You can copy what ext4 did here.
>
> 2709 ? ? ? ? if ((ext4_blocks_count(es) >
> 2710 ? ? ? ? ? ? ?(sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) ||
> 2711 ? ? ? ? ? ? (ext4_blocks_count(es) >
> 2712 ? ? ? ? ? ? ?(pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits)) ? ? ) {
> 2713 ? ? ? ? ? ? ? ? ext4_msg(sb, KERN_ERR, "filesystem"
> 2714 ? ? ? ? ? ? ? ? ? ? ? ? ?" too large to mount safely on this system");
>
> ? ? ? ?blocks_count is, of course, the calculation we already perform
> to turn di->i_clusters into how many blocks we have.
> ? ? ? ?We must always fail if we can't address our disk in sector_t.
> Once we've gotten past that check, we then need to figure out if our
> journal can address our entire disk. ?So if our current test for ">
> (u32)~0UL" returns true, one must then check for the 64BIT feature.

Thank you for the pointers, Joel.

Below is my first proposal for this patch.  It compiles and passes
checkpatch.pl (except for the missing Signed-off-by line).  *** I have
not tested this yet. ***  I just want to get some early feedback.

Note that I believe the original code had a bug: A "-1" was being
applied to the cluster count, when it should instead be applied to the
block count.  (Please correct me if I am wrong.)

Trying to do all this inline got messy, so I factored out the tests
into a new static function.

I am hoping to find time to test within the next few days.

Thanks!

 - Pat


diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..e9d9ca3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1991,6 +1991,43 @@ static int ocfs2_setup_osb_uuid(struct
ocfs2_super *osb, const unsigned char *uu
 	return 0;
 }

+/* Check to make sure entire volume is addressable on this system. */
+static int check_addressable(struct ocfs2_super *osb, struct ocfs2_dinode *di)
+{
+	int status = 0;
+	const u32 clusters = le32_to_cpu(di->i_clusters);
+	const u64 max_block = ocfs2_clusters_to_blocks(osb->sb, clusters) - 1;
+
+	/* Absolute addressability check (borrowed from ext4/super.c) */
+	if ((max_block >
+	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
+	    max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
+					    osb->sb->s_blocksize_bits)) {
+		mlog(ML_ERROR, "Volume too large "
+		     "to mount safely on this system");
+		status = -EFBIG;
+		goto out;
+	}
+
+	if (max_block <= (u32)~0UL)
+		goto out;
+
+	/* Volume is "huge", so see if our journal is new enough to
+	   have support for it. */
+	if (!(OCFS2_HAS_COMPAT_FEATURE(osb->sb,
+				       OCFS2_FEATURE_COMPAT_JBD2_SB) &&
+	      jbd2_journal_check_used_features(osb->journal->j_journal, 0, 0,
+					       JBD2_FEATURE_INCOMPAT_64BIT))) {
+		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
+		     "what jbd can address in 32 bits.\n");
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
@@ -2215,13 +2252,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}

-	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-	    > (u32)~0UL) {
-		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-		     "what jbd can address in 32 bits.\n");
-		status = -EINVAL;
+	status = check_addressable(osb, di);
+	if (status)
 		goto bail;
-	}

 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
