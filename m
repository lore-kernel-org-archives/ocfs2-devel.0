From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Thu, 24 Jun 2010 09:53:15 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <20100624005537.GG20090@mail.oracle.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
	<20100624001437.GF20090@mail.oracle.com>
	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
	<20100624005537.GG20090@mail.oracle.com>
Message-ID: <AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 23, 2010 at 5:55 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> ? ? ? ?These don't need to be const. ?Sure, they don't change, but
> you're not signifying anything special with them (like passing them to a
> subfunction or something).

Well, I am signifying that I do not intend to change them...  "const"
is just a compile-time assertion, and like all compile-time
assertions, it has no effect on the generated code.  So the only
issues are readability and maintainability.  In my experience, using
"const" consistently helps with both.  But I know it is not really the
Linux Way.

> And you don't really need the clusters temporary.

Here again, the generated code is identical, so the question is human
consumption.  I find that factoring out sub-expressions and giving
them meaningful names makes code easier to read and to understand.
(Not to mention taking two lines instead of three.)  For example, I
believe my version is less likely to wind up with the "-1" in the
wrong place.  :-)

But your house = your rules.  Updated patch follows.  I will try to
find time to test today or tomorrow.

Thanks!

 - Pat


diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..d32c800 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1991,6 +1991,46 @@ static int ocfs2_setup_osb_uuid(struct
ocfs2_super *osb, const unsigned char *uu
 	return 0;
 }

+/* Check to make sure entire volume is addressable on this system. */
+static int ocfs2_check_addressable(struct ocfs2_super *osb,
+				   struct ocfs2_dinode *di)
+{
+	int status = 0;
+	u64 max_block =
+		ocfs2_clusters_to_blocks(osb->sb,
+					 le32_to_cpu(di->i_clusters)) - 1;
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
@@ -2215,13 +2255,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}

-	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-	    > (u32)~0UL) {
-		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-		     "what jbd can address in 32 bits.\n");
-		status = -EINVAL;
+	status = ocfs2_check_addressable(osb, di);
+	if (status)
 		goto bail;
-	}

 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
