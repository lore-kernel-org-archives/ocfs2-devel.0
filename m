From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb 16 15:01:57 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <20040214031841.GH26331@ca-server1.us.oracle.com>
References: <20040213015201.GA4171@penguin.co.intel.com>
	<20040213034433.GA1193@ca-server1.us.oracle.com>
	<20040213054330.GA12076@penguin.co.intel.com>
	<20040213221537.GA15067@ca-server1.us.oracle.com>
	<20040214000654.GA26945@penguin.co.intel.com>
	<20040214010423.GB18686@ca-server1.us.oracle.com>
	<20040214013748.GA27767@penguin.co.intel.com>
	<20040214030500.GA19657@ca-server1.us.oracle.com>
	<20040214030940.GA12892@penguin.co.intel.com>
	<20040214031841.GH26331@ca-server1.us.oracle.com>
Message-ID: <20040214032154.GA12920@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 13, 2004 at 07:18:41PM -0800, Mark Fasheh wrote:
> On Fri, Feb 13, 2004 at 07:09:40PM -0800, Rusty Lynch wrote:
> > I have something here that instead of doing crazy cast, with define a U64_MODIFIER
> > that will expand appropriatly.  So... it's always correct and much easier on the eyes.
> > 
> > printk's would look something like:
> > 
> > printk(KERN_DEBUG "size_t is %Zu, and a u64 is " U64_MODIFIER "\n", asize, au64value);
> > 
> > Let me do one more verification on the patch and I will send it out.
> > 
> >     --rusty
> 
> Have you seen how often we print out __u64's? I predict that chopping up our
> format strings with that will be much uglier than a cast macro ;)
> 	--Mark
> 

Take a look at the following and see if it's too much.

    --rusty


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 31)
+++ src/inode.c	(working copy)
@@ -147,7 +147,7 @@
 	mode_t mode;
 	ocfs_file_entry *fe = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, 0x%08x)\n", inode, ino, opaque);
+	LOG_ENTRY_ARGS ("(%p, %lu, %p)\n", inode, ino, opaque);
 
 	if (opaque == NULL || inode == NULL)
 		goto bail;
@@ -167,13 +167,13 @@
 		LOG_TRACE_STR ("find_inode -> S_ISDIR");
 		if (fe->extents[0].disk_off != fileOff) {
 			LOG_TRACE_ARGS
-		    	("DIR : inode number same but full offset does not match: %u.%u != %u.%u\n",
+		    	("DIR : inode number same but full offset does not match: " U64_MODIFIER " != " U64_MODIFIER "\n",
 		     	fe->extents[0].disk_off, fileOff);
 			goto bail;
 		}
 	} else if (args->offset != fileOff) {
 		LOG_TRACE_ARGS
-	    	("FILE : inode number same but full offset does not match: %u.%u != %u.%u\n",
+	    	("FILE : inode number same but full offset does not match: " U64_MODIFIER " != " U64_MODIFIER "\n",
 	     	args->offset, fileOff);
 		goto bail;
 	}
@@ -237,7 +237,7 @@
 	__u64 offset, fe_off;
 	unsigned long uniq_ino;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, size:%u)\n", inode, mode, fe->file_size);
+	LOG_ENTRY_ARGS ("(%p, %u, size:" U64_MODIFIER ")\n", inode, mode, fe->file_size);
 
 	sb = inode->i_sb;
 	osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
@@ -274,8 +274,8 @@
 		inode->i_ino = uniq_ino;
 		/* caller needs to know to call inode_hash_bind! */
 	}
-	LOG_TRACE_ARGS("offset = %u.%u, ino = %lu, create_ino = %s\n",
-		       HILO(offset), inode->i_ino, 
+	LOG_TRACE_ARGS("offset = " U64_MODIFIER ", ino = %lu, create_ino = %s\n",
+		       offset, inode->i_ino, 
 		       create_ino ? "true" : "false");
 
 	switch (inode->i_mode & S_IFMT) {
@@ -418,7 +418,7 @@
 	ocfs_file_entry *fe = NULL;
 	__u64 voteoff;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", inode, opaque);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", inode, opaque);
 
 	if (inode == NULL || inode->i_sb == NULL) {
 		LOG_ERROR_STR ("bad inode");
@@ -623,7 +623,7 @@
 		off = args->offset;
 		/* Need to verify that ocfs_find_inode does the right thing,
 		 * and need to actually write ocfs_init_inode */
-		inode = iget5_locked(sb, LO (off), ocfs_find_actor,
+		inode = iget5_locked(sb, off, ocfs_find_actor,
 				     ocfs_init_locked_inode, args);
 	}
 
@@ -657,8 +657,8 @@
 {
 	ocfs_super *osb;
 
-	LOG_ENTRY_ARGS ("(0x%08x, inode_i_ino=%lu)\n", inode, inode->i_ino);
-	LOG_TRACE_ARGS ("put_inode: count=%d\n", inode->i_count);
+	LOG_ENTRY_ARGS ("(%p, inode_i_ino=%lu)\n", inode, inode->i_ino);
+	LOG_TRACE_ARGS ("put_inode: count=%d\n", atomic_read(&inode->i_count));
 	osb = OCFS_GENERIC_SB_P(inode->i_sb);
 	if (inode_data_is_oin(inode) && (atomic_read (&inode->i_count) == 1) ) {
 	     ocfs_inode *oin;
@@ -765,7 +765,7 @@
 		else
 			LOG_TRACE_ARGS("Inode %lu (%u.%u) already deleted, "
 				       "skipping call to hash_remove\n",
-				       inode->i_ino, HILO(offset));
+				       inode->i_ino, offset);
 	}
 #endif
 
@@ -783,7 +783,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u, %u)\n", file, page, from, to);
+	LOG_ENTRY_ARGS ("(%p, %p, %u, %u)\n", file, page, from, to);
 
 	ret = block_prepare_write (page, from, to, ocfs_get_block);
 
@@ -799,7 +799,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u, %u)\n", file, page, from, to);
+	LOG_ENTRY_ARGS ("(%p, %p, %u, %u)\n", file, page, from, to);
 
 	ret = generic_commit_write (file, page, from, to);
 
@@ -861,8 +861,8 @@
 	int status = 0;
 
 	if (newsize > oin->alloc_size) {
-		LOG_TRACE_ARGS ("Extend: have=%u.%u, need=%u.%u\n",
-				HILO (oin->alloc_size), HILO (newsize));
+		LOG_TRACE_ARGS ("Extend: have=" U64_MODIFIER ", need=" U64_MODIFIER "\n",
+				oin->alloc_size, newsize);
 
 		if (unlock)
 			ocfs_up_sem (&(oin->main_res));
@@ -875,7 +875,7 @@
 	
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
-		LOG_TRACE_ARGS ("Failed to extend file to %u.%u\n", HILO (newsize));
+		LOG_TRACE_ARGS ("Failed to extend file to " U64_MODIFIER "\n", newsize);
 		status = -ENOSPC;
 	}
 
@@ -895,8 +895,8 @@
 	__u64 entryOffset;
 	struct buffer_head *bh = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %d, 0x%08x, %d)\n", inode, iblock, bh_result,
-			create);
+	LOG_ENTRY_ARGS ("(%p, " SECTOR_MODIFIER ", %p, %d)\n", 
+			inode, iblock, bh_result, create);
 
 	if (!inode) {
 		LOG_ERROR_STR ("bad inode");
@@ -906,7 +906,8 @@
 	osb = (ocfs_super *) OCFS_GENERIC_SB_P(inode->i_sb);
 
 	if ((iblock << 9) > PATH_MAX + 1) {
-		LOG_ERROR_ARGS ("file offset > PATH_MAX: %u.%u", iblock << 9);
+		LOG_ERROR_ARGS ("file offset > PATH_MAX: " 
+				SECTOR_MODIFIER "", iblock << 9);
 		goto bail;
 	}
 
@@ -924,14 +925,14 @@
 
 	if (!IS_VALID_FILE_ENTRY (fe)) {
 		OCFS_BH_PUT_DATA(bh);
-		LOG_ERROR_ARGS ("Invalid fe at offset %u.%u", HILO(entryOffset));
+		LOG_ERROR_ARGS ("Invalid fe@offset " U64_MODIFIER "", entryOffset);
 		goto bail;
 	}
 
 	if ((iblock << 9) >= (__s64)fe->alloc_size) {
 		OCFS_BH_PUT_DATA(bh);
-		LOG_ERROR_ARGS ("file offset is outside the allocated size: %u.%u",
-		     HILO(iblock << 9));
+		LOG_ERROR_ARGS ("file offset is outside the allocated size: "
+				SECTOR_MODIFIER, iblock << 9);
 		goto bail;
 	}
 
@@ -962,8 +963,8 @@
 	__u32 len;
 	bool oin_locked = false;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %d, 0x%08x, %d)\n", inode, iblock, bh_result,
-			create);
+	LOG_ENTRY_ARGS ("(%p, " SECTOR_MODIFIER ", %p, %d)\n", 
+			inode, iblock, bh_result, create);
 
 	if (S_ISLNK (inode->i_mode)) {
 		err = ocfs_symlink_get_block (inode, iblock, bh_result, create);
@@ -1004,8 +1005,8 @@
 	err = ocfs_lookup_file_allocation(osb, oin, vbo, &lbo, len, NULL, 
 					  (oin->journal_inode) ? NULL : inode);
 	if (err < 0) {
-		LOG_ERROR_ARGS ("vbo=%u.%u lbo=%u.%u len=%u", HILO(vbo),
-				HILO(lbo), len);
+		LOG_ERROR_ARGS ("vbo=" U64_MODIFIER " lbo=" U64_MODIFIER " len=%u", vbo,
+				lbo, len);
 		goto bail;
 	}
 
@@ -1015,8 +1016,8 @@
 
 	if (bh_result->b_blocknr == 0) {
 		err = -EIO;
-		LOG_ERROR_ARGS ("vbo=%u.%u lbo=%u.%u len=%u, fe=0x%08x",
-				HILO(vbo), HILO(lbo), len, oin->file_disk_off);
+		LOG_ERROR_ARGS ("vbo=" U64_MODIFIER " lbo=" U64_MODIFIER " len=%u, fe=" U64_MODIFIER "",
+				vbo, lbo, len, oin->file_disk_off);
 	}
 
 bail:
@@ -1079,8 +1080,8 @@
 	err = ocfs_lookup_file_allocation(osb, oin, vbo, &lbo, len, 
 					  NULL, NULL);
 	if (err < 0) {
-		LOG_ERROR_ARGS ("vbo=%u.%u lbo=%u.%u len=%u", HILO(vbo),
-				HILO(lbo), len);
+		LOG_ERROR_ARGS ("vbo=" U64_MODIFIER " lbo=" U64_MODIFIER " len=%u", vbo,
+				lbo, len);
 		LOG_ERROR_STATUS(err);
 		goto bail;
 	}
@@ -1105,7 +1106,7 @@
 	__s64 vbo = 0;
 	__s64 lbo = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %d)\n", inode, iblock);
+	LOG_ENTRY_ARGS ("(%p, %li)\n", inode, iblock);
 
 	if (!inode || !inode_data_is_oin (inode)) {
 		LOG_ERROR_STR ("bad inode or inode has no oin");
@@ -1130,8 +1131,8 @@
 	*oblock = lbo >> inode->i_sb->s_blocksize_bits;
 	if (*oblock == 0) {
 		err = -EIO;
-		LOG_ERROR_ARGS ("vbo=%u.%u lbo=%u.%u len=%u, fe=0x%08x",
-				HILO(vbo), HILO(lbo), len, oin->file_disk_off);
+		LOG_ERROR_ARGS ("vbo=" U64_MODIFIER " lbo=" U64_MODIFIER " len=%u, fe=" U64_MODIFIER "",
+				vbo, lbo, len, oin->file_disk_off);
 	}
 
 bail:
@@ -1150,7 +1151,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u)\n", file, (page ? page->index : 0));
+	LOG_ENTRY_ARGS ("(%p, %lu)\n", file, (page ? page->index : 0));
 
 	ret = block_read_full_page (page, ocfs_get_block);
 
@@ -1179,7 +1180,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x)\n", page);
+	LOG_ENTRY_ARGS ("(%p)\n", page);
 
 	ret = block_write_full_page (page, ocfs_get_block);
 
Index: src/extmap.c
===================================================================
--- src/extmap.c	(revision 31)
+++ src/extmap.c	(working copy)
@@ -245,7 +245,7 @@
 
 bail:
 
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_coalesce_extent_map_entry */
 
@@ -304,7 +304,7 @@
 	spin_unlock(&(map->lock));
 
 bail:
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_extent_map_add */
 
@@ -385,7 +385,7 @@
 	spin_unlock(&(map->lock));
 
 bail:
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_extent_map_lookup */
 
@@ -430,7 +430,7 @@
 	spin_unlock(&(map->lock));
 bail:
 
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_extent_map_next_entry */
 
@@ -516,10 +516,10 @@
 		Results = false;
 		*SectorCount = 0xffffffffUL;
 	} else {
-		*SectorCount = (LO(LiSectorCount)) << OCFS_LOG_SECTOR_SIZE;
+		*SectorCount = (LiSectorCount & 0x00000000FFFFFFFFUL) << OCFS_LOG_SECTOR_SIZE;
 	}
 		
-	LOG_EXIT_ULONG (Results);
+	LOG_EXIT_STATUS (Results);
 	return Results;
 }				/* ocfs_get_next_extent_map_entry  */
 
@@ -566,7 +566,7 @@
 		}
 	}
 
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_lookup_extent_map_entry */
 
@@ -648,8 +648,8 @@
 
 		if ((OcfsExtent->next_free_ext != OCFS_MAX_DATA_EXTENTS) &&
 		    (*remainingLength)) {
-			LOG_ERROR_ARGS ("next_free_extent=%d, rem_len=%u.%u",
-				OcfsExtent->next_free_ext, HILO(*remainingLength));
+			LOG_ERROR_ARGS ("next_free_extent=%d, rem_len=" U64_MODIFIER "",
+				OcfsExtent->next_free_ext, *remainingLength);
 		} else
 			status = 0;
 	}
@@ -689,10 +689,10 @@
 
 	ret = ocfs_extent_map_add (Map, ((__s64) Vbo), ((__s64) Lbo), ((__s64) ByteCount));
 	if (!ret)
-		LOG_ERROR_ARGS ("fileoff=%u.%u, diskoff=%u.%u, len=%u.%u",
-				HILO (Vbo), HILO (Lbo), HILO (ByteCount));
+		LOG_ERROR_ARGS ("fileoff=" U64_MODIFIER ", diskoff=" U64_MODIFIER ", len=" U64_MODIFIER "",
+				Vbo, Lbo, ByteCount);
 
 
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_add_extent_map_entry */
Index: src/super.c
===================================================================
--- src/super.c	(revision 31)
+++ src/super.c	(working copy)
@@ -326,7 +326,7 @@
 		inode = NULL;
 	}
 
-	LOG_EXIT_PTR (0);
+	LOG_EXIT_PTR (NULL);
 	return NULL;
 }				/* ocfs_read_super */
 
@@ -355,7 +355,7 @@
 		goto bail;
 	}
 
-	LOG_TRACE_ARGS("strlen(options) = %d, options = \"%s\"\n", strlen(options), options);
+	LOG_TRACE_ARGS("strlen(options) = %Zu, options = \"%s\"\n", strlen(options), options);
 
 #ifdef LINUX_2_5
         while ( (c = strsep(&options, ",")) != NULL)
@@ -675,7 +675,7 @@
  */
 static void ocfs_put_super (struct super_block *sb)
 {
-	LOG_ENTRY_ARGS ("(0x%08x)\n", sb);
+	LOG_ENTRY_ARGS ("(%p)\n", sb);
 
 	ocfs_sync_blockdev(sb);
 	LOG_TRACE_STR ("put super... do nothing!  DONE!!!!");
@@ -700,7 +700,7 @@
         ocfs_bitmap_lock *bm_lock = NULL;
 	struct buffer_head *bh = NULL;
 
-        LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", sb, buf);
+        LOG_ENTRY_ARGS ("(%p, %p)\n", sb, buf);
 
         osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
         numbits = osb->cluster_bitmap.validbits;
@@ -1064,7 +1064,7 @@
 	__u32 tempmap;
 	int i;
 
-	LOG_ENTRY_ARGS ("(0x%08x)\n", sb);
+	LOG_ENTRY_ARGS ("(%p)\n", sb);
 
 	if (sb == NULL) {
 		LOG_ERROR_STATUS (status = -EFAIL);
Index: src/heartbeat.c
===================================================================
--- src/heartbeat.c	(revision 31)
+++ src/heartbeat.c	(working copy)
@@ -56,7 +56,7 @@
 	struct buffer_head **pub_bh = &osb->cfg_bhs[publish_idx];
 	__u64 node_publ_off = osb->vol_layout.publ_sect_off + (osb->node_num * osb->sect_size);
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, %s)\n", osb, flag,
+	LOG_ENTRY_ARGS ("(%p, %u, %s)\n", osb, flag,
 			read_publish ? "true" : "false");
 
 	if (flag & HEARTBEAT_METHOD_DISK) {
@@ -124,7 +124,7 @@
 	__u32 i;
 	__u32 num_nodes;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u)\n", osb, bhs, first_time);
+	LOG_ENTRY_ARGS ("(%p, %p, %u)\n", osb, bhs, first_time);
 
 	num_nodes = OCFS_MAXIMUM_NODES;
 	node_map = &(osb->vol_node_map);
Index: src/proc.c
===================================================================
--- src/proc.c	(revision 31)
+++ src/proc.c	(working copy)
@@ -174,7 +174,7 @@
 				       	"%08x  %9s  %-40s  %5d  %u.%u\n",
 				       	item->address, slabname, item->tag,
 				       	atomic_read(&p->lr_ref_cnt),
-				       	HILO(p->sector_num));
+				       	p->sector_num);
 			} else
 				sprintf(tmpstr, "%08x  %9s  %-40s\n", item->address,
 				       	slabname, item->tag);
@@ -440,21 +440,21 @@
 	if (pubmap != ptr)
 		*(ptr - 1) = '\0';
 
-#define PROC_STATS                             \
-  "File open count          : %d.%u\n"         \
-  "Publish map              : %s\n"            \
-  "Number of nodes          : %u\n"            \
-  "Cluster size             : %u\n"            \
-  "Volume size              : %u.%u\n"         \
-  "Dir node size            : %u.%u\n"         \
-  "File node size           : %u.%u\n"         \
-  "Failed Large Allocs      : %u\n"            \
-  "Retry Large Allocs       : %u\n"            \
+#define PROC_STATS                                      \
+  "File open count          : " U64_MODIFIER "\n"       \
+  "Publish map              : %s\n"                     \
+  "Number of nodes          : %u\n"                     \
+  "Cluster size             : %u\n"                     \
+  "Volume size              : " U64_MODIFIER "\n"       \
+  "Dir node size            : " U64_MODIFIER "\n"       \
+  "File node size           : " U64_MODIFIER "\n"       \
+  "Failed Large Allocs      : %u\n"                     \
+  "Retry Large Allocs       : %u\n"                     \
   "Inode Hash Objects       : %u\n"
 
-	len = sprintf (page, PROC_STATS, HILO (osb->file_open_cnt), pubmap,
-		       vol->num_nodes, vol->cluster_size, HILO (vol->size),
-		       HILO (vol->dir_node_size), HILO (vol->file_node_size),
+	len = sprintf (page, PROC_STATS, osb->file_open_cnt, pubmap,
+		       vol->num_nodes, vol->cluster_size, vol->size,
+		       vol->dir_node_size, vol->file_node_size,
 		       osb->cluster_bitmap.failed, 
 		       osb->cluster_bitmap.ok_retries, 
 		       osb->inode_hash.num_ents);
Index: src/io.c
===================================================================
--- src/io.c	(revision 31)
+++ src/io.c	(working copy)
@@ -188,7 +188,7 @@
 	my_timing_t begin, end; 
 #endif
 	
-	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %u, nr=%d, flags=%u, inodes=%p)\n", 
+	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %lu, nr=%d, flags=%u, inodes=%p)\n", 
 		       bhs[0]->b_blocknr, nr, flags, inodes);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
@@ -258,7 +258,7 @@
 		if (!(flags & OCFS_BH_IGNORE_JBD) && buffer_jbd(bh)) {
 #ifdef VERBOSE_BH_JBD_TRACE
 			LOG_TRACE_ARGS("trying to write a jbd managed bh "
-				       "(blocknr = %u), nr=%d\n", 
+				       "(blocknr = %lu), nr=%d\n", 
 				       bh->b_blocknr, nr);
 #endif
 			continue;
@@ -316,14 +316,14 @@
 #ifdef OCFS_DBG_TIMING
 	my_timing_t begin, end; 
 #endif
-	LOG_ENTRY_ARGS("(off=(%u.%u), len=(%u.%u), flags=%d, inodes=%p)\n", HILO(off), 
-		       HILO(len), flags, inodes);
+	LOG_ENTRY_ARGS("(off=(" U64_MODIFIER "), len=(" U64_MODIFIER "), flags=%d, inodes=%p)\n", off, 
+		       len, flags, inodes);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
 #endif
 
 	if (len % 512) {
-		LOG_TRACE_ARGS("len %% 512 (len=%u)\n", len);
+		LOG_TRACE_ARGS("len %% 512 (len=" U64_MODIFIER ")\n", len);
 		status = -EINVAL;
 		LOG_ERROR_STATUS(status);
 		goto bail;
@@ -355,9 +355,9 @@
 	nr = (len + 511) >> 9;
 	if (nr == 0) {
 		LOG_TRACE_STR("No buffers will be read!!!");
-		LOG_TRACE_ARGS("Len=%u Off=%u.%u numbuffers=%u "
-			       "blocknum=%u.%u\n", len, HI (off), LO (off), 
-			       nr, HI (blocknum), LO (blocknum));
+		LOG_TRACE_ARGS("Len=" U64_MODIFIER " Off=" U64_MODIFIER " numbuffers=%u "
+			       "blocknum=" U64_MODIFIER "\n", 
+			       len, off, nr, blocknum);
 		status = 0;
 		goto bail;
 	}
@@ -382,7 +382,7 @@
 			ignore_cache = 1;
 		} else if (flags & OCFS_BH_CACHED && !TEST_BH_SEQNUM(inodes[i], bh)) {
 #ifdef VERBOSE_BH_SEQNUM_TRACE
-			LOG_TRACE_ARGS("(read) bh (%u) seqnum (%u) does not "
+			LOG_TRACE_ARGS("(read) bh (%lu) seqnum (%lu) does not "
 			       	"match inode (%u)\n", bh->b_blocknr, 
 			       	(bh->b_state & STATE_BIT_MASK) >> 19,
 			       	atomic_read(GET_INODE_CLEAN_SEQ(inodes[i])));
@@ -397,7 +397,7 @@
 #ifdef VERBOSE_BH_JBD_TRACE
 			if (!(flags & OCFS_BH_CACHED) || ignore_cache)
 				LOG_TRACE_ARGS("trying to sync read a jbd "
-					       "managed bh (blocknr = %u)\n",
+					       "managed bh (blocknr = %lu)\n",
 					       bh->b_blocknr);
 #endif
 			continue;
@@ -408,7 +408,7 @@
 				/* This should probably be a BUG, or
 				 * at least return an error. */
 				LOG_TRACE_ARGS("asking me to sync read a "
-					      "dirty buffer! (blocknr = %u)\n",
+					      "dirty buffer! (blocknr = %lu)\n",
 					      bh->b_blocknr);
 				continue;
 			}
@@ -435,7 +435,7 @@
 
 		OCFS_BH_PUT_DATA(bh);
 	}
-	LOG_TRACE_ARGS("off=(%u.%u), len=(%u.%u), cached=%s\n", HILO(off), HILO(len), 
+	LOG_TRACE_ARGS("off=(" U64_MODIFIER "), len=(" U64_MODIFIER "), cached=%s\n", off, len, 
 		       (!(flags & OCFS_BH_CACHED) || ignore_cache) ? "no" : "yes");
 
 bail:
@@ -461,7 +461,7 @@
 	my_timing_t begin, end; 
 #endif
 	
-	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %u, nr=%d, flags=%u, inode=%p)\n", 
+	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %lu, nr=%d, flags=%u, inode=%p)\n", 
 		       bhs[0]->b_blocknr, nr, flags, inode);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
@@ -531,7 +531,7 @@
 		if (!(flags & OCFS_BH_IGNORE_JBD) && buffer_jbd(bh)) {
 #ifdef VERBOSE_BH_JBD_TRACE
 			LOG_TRACE_ARGS("trying to write a jbd managed bh "
-				       "(blocknr = %u), nr=%d\n", 
+				       "(blocknr = %lu), nr=%d\n", 
 				       bh->b_blocknr, nr);
 #endif
 			continue;
@@ -590,14 +590,14 @@
 #ifdef OCFS_DBG_TIMING
 	my_timing_t begin, end; 
 #endif
-	LOG_ENTRY_ARGS("(off=(%u.%u), len=(%u.%u), flags=%d, inode=%p)\n", HILO(off), 
-		       HILO(len), flags, inode);
+	LOG_ENTRY_ARGS("(off=(" U64_MODIFIER "), len=(" U64_MODIFIER "), flags=%d, inode=%p)\n", off, 
+		       len, flags, inode);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
 #endif
 
 	if (len % 512) {
-		LOG_TRACE_ARGS("len %% 512 (len=%u)\n", len);
+		LOG_TRACE_ARGS("len %% 512 (len=" U64_MODIFIER ")\n", len);
 		status = -EINVAL;
 		LOG_ERROR_STATUS(status);
 		goto bail;
@@ -629,9 +629,9 @@
 	nr = (len + 511) >> 9;
 	if (nr == 0) {
 		LOG_TRACE_STR("No buffers will be read!!!");
-		LOG_TRACE_ARGS("Len=%u Off=%u.%u numbuffers=%u "
-			       "blocknum=%u.%u\n", len, HI (off), LO (off), 
-			       nr, HI (blocknum), LO (blocknum));
+		LOG_TRACE_ARGS("Len=" U64_MODIFIER " Off=" U64_MODIFIER " numbuffers=%u "
+			       "blocknum=" U64_MODIFIER "\n", 
+			      len, off, nr, blocknum);
 		status = 0;
 		goto bail;
 	}
@@ -655,7 +655,7 @@
 		if (flags & OCFS_BH_CACHED && inode && 
 		    !TEST_BH_SEQNUM(inode, bh)) {
 #ifdef VERBOSE_BH_SEQNUM_TRACE
-			LOG_TRACE_ARGS("(read) bh (%u) seqnum (%u) does not "
+			LOG_TRACE_ARGS("(read) bh (%lu) seqnum (%lu) does not "
 				       "match inode (%u)\n", bh->b_blocknr, 
 				       (bh->b_state & STATE_BIT_MASK) >> 19,
 				       atomic_read(GET_INODE_CLEAN_SEQ(inode)));
@@ -670,7 +670,7 @@
 #ifdef VERBOSE_BH_JBD_TRACE
 			if (!(flags & OCFS_BH_CACHED) || ignore_cache)
 				LOG_TRACE_ARGS("trying to sync read a jbd "
-					       "managed bh (blocknr = %u)\n",
+					       "managed bh (blocknr = %lu)\n",
 					       bh->b_blocknr);
 #endif
 			continue;
@@ -681,7 +681,7 @@
 				/* This should probably be a BUG, or
 				 * at least return an error. */
 				LOG_TRACE_ARGS("asking me to sync read a "
-					      "dirty buffer! (blocknr = %u)\n",
+					      "dirty buffer! (blocknr = %lu)\n",
 					      bh->b_blocknr);
 				continue;
 			}
@@ -708,7 +708,7 @@
 
 		OCFS_BH_PUT_DATA(bh);
 	}
-	LOG_TRACE_ARGS("off=(%u.%u), len=(%u.%u), cached=%s\n", HILO(off), HILO(len), 
+	LOG_TRACE_ARGS("off=(" U64_MODIFIER "), len=(" U64_MODIFIER "), cached=%s\n", off, len, 
 		       (!(flags & OCFS_BH_CACHED) || ignore_cache) ? "no" : "yes");
 
 bail:
Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 31)
+++ src/dcache.c	(working copy)
@@ -48,7 +48,7 @@
 	struct buffer_head *fe_bh = NULL;
 	int needs_trunc;
 
-        LOG_ENTRY_ARGS ("(0x%08x, %d, '%*s')\n", dentry, flags,
+        LOG_ENTRY_ARGS ("(%p, %d, '%*s')\n", dentry, flags,
                         dentry->d_name.len, dentry->d_name.name);
 
 	if ((inode = dentry->d_inode) == NULL ||
@@ -176,7 +176,7 @@
 	struct list_head *list;
 	int ret, done;
 
-	LOG_ENTRY_ARGS ("(0x%08x, '%*s')\n", dentry,
+	LOG_ENTRY_ARGS ("(%p, '%*s')\n", dentry,
                         dentry->d_name.len, dentry->d_name.name);
 
 	spin_lock (&dcache_lock);
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 31)
+++ src/journal.c	(working copy)
@@ -96,7 +96,7 @@
 	retval->k_handle = journal_start(journal, max_buffs);
 	if (IS_ERR(retval->k_handle)) {
 		LOG_ERROR_STR("journal_start() failed!");
-		LOG_ERROR_STATUS(PTR_ERR(retval->k_handle));
+		LOG_ERROR_STATUS((int)PTR_ERR(retval->k_handle));
 		retval->k_handle = NULL;
 		goto done_free;
 	}
@@ -240,8 +240,8 @@
 					    lock->flags, lock->res, 
 					    (abort ? NULL : lock->bh), NULL);
 		if (tmpstat < 0) {
-			LOG_ERROR_ARGS("Could not release lock %u.%u\n", 
-				       HILO(lock->id));
+			LOG_ERROR_ARGS("Could not release lock " U64_MODIFIER "\n", 
+				       lock->id);
 			LOG_ERROR_STATUS(tmpstat);
 			status = tmpstat;
 		}
@@ -265,7 +265,7 @@
 	int status = -ENOENT;
 	struct list_head *p1;
 	
-	LOG_ENTRY_ARGS("(%u.%u)\n", lockid);
+	LOG_ENTRY_ARGS("(" U64_MODIFIER ")\n", lockid);
 
 	/* make sure that we have a root_start off     */
 	/* this can be called early in the first mount */
@@ -748,8 +748,8 @@
 {
 	ocfs_journal_lock *lock;
 
-	LOG_ENTRY_ARGS("(id=%u.%u, type=%u, flags=%u, res=0x%08x, " 
-		       "bh=0x%08x)\n", HILO(id), type, flags, res, bh);
+	LOG_ENTRY_ARGS("(id=" U64_MODIFIER ", type=%u, flags=%u, res=%p, " 
+		       "bh=%p)\n", id, type, flags, res, bh);
 
 	lock = ocfs_malloc(sizeof(ocfs_journal_lock));
 	if (lock == NULL) {
@@ -882,10 +882,8 @@
 		}
 		fe = (ocfs_file_entry *) OCFS_BH_GET_DATA_READ(bh); /* read */
 	}
-	LOG_TRACE_ARGS("fe->file_size = %u.%u\n", HI(fe->file_size), 
-		       LO(fe->file_size));
-	LOG_TRACE_ARGS("fe->alloc_size = %u.%u\n", HI(fe->alloc_size), 
-		       LO(fe->alloc_size));
+	LOG_TRACE_ARGS("fe->file_size  = " U64_MODIFIER "\n", fe->file_size);
+	LOG_TRACE_ARGS("fe->alloc_size = " U64_MODIFIER "\n", fe->alloc_size); 
 
 	/* gonna need this later */
 	alloc_size = fe->alloc_size;
@@ -893,8 +891,7 @@
 	/* Ok, look up the inode for our journal */
 	args.offset = fe->this_sector;
 	args.fe_bh = bh;
-	LOG_TRACE_ARGS("fe->this_sector = %u.%u\n", HI(fe->this_sector), 
-		       LO(fe->this_sector));
+	LOG_TRACE_ARGS("fe->this_sector = " U64_MODIFIER "\n", fe->this_sector);
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
 #ifdef LINUX_2_5
@@ -914,15 +911,14 @@
 		status = -EACCES;
 		goto done;
 	}
-	LOG_TRACE_ARGS("inode->i_size = %u\n", inode->i_size);
+	LOG_TRACE_ARGS("inode->i_size = %Lu\n", inode->i_size);
 
 	status = ocfs_create_new_oin(&oin, alloc_size, osb);
 	status = ocfs_initialize_oin(oin, osb, 0, lock_id, lock_id, false, NULL);
 	oin->journal_inode = true;
 	oin->open_hndl_cnt++;
 	SET_INODE_OIN(inode, oin);
-	LOG_TRACE_ARGS("oin->alloc_size = %u.%u\n", HI(oin->alloc_size), 
-		       LO(oin->alloc_size));
+	LOG_TRACE_ARGS("oin->alloc_size = " U64_MODIFIER "\n", oin->alloc_size);
 
 	/* call the kernels journal init function now */
 	k_journal = journal_init_inode(inode);
@@ -1328,8 +1324,8 @@
 			status = -EINVAL;
 			goto bail;
 		}
-		LOG_TRACE_ARGS("(Run %d), lbo = %d.%d bytes, numbytes = %u "
-			       "bytes\n", run, HILO(lbo), numbytes);
+		LOG_TRACE_ARGS("(Run %d), lbo = " U64_MODIFIER " bytes, numbytes = %u "
+			       "bytes\n", run, lbo, numbytes);
 
 		/* there are actually returned in bytes. need blocks. */
 		numblks = numbytes / osb->sect_size;
@@ -1537,7 +1533,7 @@
 		status = -EACCES;
 		goto done;
 	}
-	LOG_TRACE_ARGS("inode->i_size = %u\n", inode->i_size);
+	LOG_TRACE_ARGS("inode->i_size = %Lu\n", inode->i_size);
 
 	status = ocfs_create_new_oin(&oin, alloc_size, osb);
 	if (status < 0) {
@@ -1654,7 +1650,7 @@
 	struct buffer_head *publish_bh = NULL;
 	__u64 node_publ_off;
 
-	LOG_ENTRY_ARGS("(0x%08x, %u.%u)\n", osb, HI (node_num), LO (node_num));
+	LOG_ENTRY_ARGS("(%p, " U64_MODIFIER ")\n", osb, node_num);
 
 	/* take a lock on the publish sector */
 	down (&(osb->publish_lock));
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 31)
+++ src/nm.c	(working copy)
@@ -158,13 +158,13 @@
 	ocfs_publish * publish;
 	struct ocfs_sched_vote *sv = NULL;
 
-	LOG_ENTRY_ARGS("(vote_node = %d, bh = 0x%x)\n", vote_node, bh);
+	LOG_ENTRY_ARGS("(vote_node = %d, bh = %p)\n", vote_node, bh);
 
 	publish = (ocfs_publish *) OCFS_BH_GET_DATA_READ(bh); /* read */
 
 	if (osb->last_publ_seq_num[vote_node] == publish->publ_seq_num){
-		LOG_TRACE_ARGS("Already voted on node %d, seqnum (%u.%u)\n", 
-			       vote_node, HILO(publish->publ_seq_num));
+		LOG_TRACE_ARGS("Already voted on node %d, seqnum (" U64_MODIFIER ")\n", 
+			       vote_node, publish->publ_seq_num);
 		OCFS_BH_PUT_DATA(bh);
 		status = 0;
 		goto bail;
@@ -310,7 +310,7 @@
 			atomic_inc (&osb->nm_init);
 		}
 
-		LOG_TRACE_ARGS ("Publish map: 0x%08x\n", LO (osb->publ_map));
+		LOG_TRACE_ARGS ("Publish map: " U64_MODIFIER "\n", osb->publ_map);
 
 		/* map of local node */
 		curr_node_map = (__u64) ((__u64)1 << osb->node_num);
@@ -433,7 +433,7 @@
 	int status = 0;
 	ocfs_file_entry *fe;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, 0x%08x)\n", osb, lock_res, bh);
+	LOG_ENTRY_ARGS ("(%p, %p, %p)\n", osb, lock_res, bh);
 
 	/* Don't sync-read if we already own the lock as it may not
 	 * have hit disk yet. */
@@ -447,8 +447,8 @@
 
 	status = ocfs_acquire_lockres_ex (lock_res, timeout);
 	if (status < 0) {
-		LOG_TRACE_ARGS ("Timedout locking lockres for id: %u.%u\n",
-				HILO (lock_res->sector_num));
+		LOG_TRACE_ARGS ("Timedout locking lockres for id: " U64_MODIFIER "\n",
+				lock_res->sector_num);
 		goto finally;
 	}
 
@@ -487,8 +487,8 @@
 	ocfs_lock_res *tmp_lockres = NULL;
 	struct buffer_head *tmpbh = NULL, **b = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, 0x%08x, 0x%08x, 0x%08x)\n", osb,
-			HI (lock_id), LO (lock_id), lockres, bh, updated);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %p, %p, %p)\n",
+			osb, lock_id, lockres, bh, updated);
 
 	if (bh == NULL)
 		b = &tmpbh;
@@ -720,7 +720,7 @@
 	__u64 lock_id, seq_num;
 	int needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", osb, ctxt);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", osb, ctxt);
 
 	if (!publish && !dlm_msg) {
 		status = -EINVAL;
@@ -743,8 +743,8 @@
 	}
 	lockflags = (lock_id >= osb->vol_layout.bitmap_off ? OCFS_BH_CACHED : 0);
 	
-	LOG_TRACE_ARGS ("node=%u, id=%u.%u, seq=%u.%u\n", node_num,
-			HILO (lock_id), HILO (seq_num));
+	LOG_TRACE_ARGS ("node=%u, id=" U64_MODIFIER ", seq=" U64_MODIFIER "\n", node_num,
+			lock_id, seq_num);
 
 	if (disk_vote) {
 		offset = osb->vol_layout.vote_sect_off + (osb->node_num * osb->sect_size);
@@ -765,8 +765,8 @@
 	} else {
 		status = ocfs_acquire_lockres_ex (lockres, (OCFS_NM_HEARTBEAT_TIME/2));
 		if (status < 0) {
-			LOG_TRACE_ARGS ("Timedout locking lockres for id: %u.%u\n",
-				HILO (lockres->sector_num));
+			LOG_TRACE_ARGS ("Timedout locking lockres for id: " U64_MODIFIER "\n",
+				lockres->sector_num);
 			ocfs_put_lockres(lockres);
 			goto leave;
 		}
@@ -775,7 +775,7 @@
 	vote_type = get_process_vote_action(osb, lockres, node_num, flags, 
 					    status, &master_alive, &oin);
 	
-	printk("ocfs_process_vote: %s request for lockid: %u.%u, action: %s, type: %s\n",
+	printk("ocfs_process_vote: %s request for lockid: " U64_MODIFIER ", action: %s, type: %s\n",
 	       flags & FLAG_RELEASE_LOCK ? "RELEASE" : 
 	       (flags & FLAG_ACQUIRE_LOCK ? "ACQUIRE" : "MODIFY"), lock_id,
 	       process_vote_strings[vote_type], disk_vote ? "disk vote" : "net vote" );
@@ -938,8 +938,8 @@
 			 * him the lock if it's part of the cache and
 			 * we can flush it... */
 
-			LOG_TRACE_ARGS("Lock id (%u.%u) has %u holders\n", 
-				       HILO(lockres->sector_num), 
+			LOG_TRACE_ARGS("Lock id (" U64_MODIFIER ") has %u holders\n", 
+				       lockres->sector_num, 
 				       lockres->lock_holders);
 
 			/* Try to take the trans_lock. We try a couple
Index: src/ioctl.c
===================================================================
--- src/ioctl.c	(revision 31)
+++ src/ioctl.c	(working copy)
@@ -40,7 +40,7 @@
 	extern char *ocfs_version;
 	int ret = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u, %lu)\n", inode, filp, cmd, arg);
+	LOG_ENTRY_ARGS ("(%p, %p, %u, %lu)\n", inode, filp, cmd, arg);
 
 	if (_IOC_TYPE (cmd) != OCFS_IOC_MAGIC) {
 		ret = -ENOTTY;
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 31)
+++ src/dlm.c	(working copy)
@@ -79,7 +79,7 @@
 	__u64 lockseqno = 0;
 	unsigned long jif = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u)\n", osb, lockres, flags);
+	LOG_ENTRY_ARGS ("(%p, %p, %u)\n", osb, lockres, flags);
 
 	ocfs_acquire_lockres (lockres);
 	votemap = (1 << lockres->master_node_num);
@@ -132,7 +132,7 @@
 	ocfs_break_cache_lock_zap_buffers(osb, inode);
 
 	jif = jiffies - jif;
-	LOG_TRACE_ARGS ("Lock time:%u\n", jif);
+	LOG_TRACE_ARGS ("Lock time:%lu\n", jif);
 
 	if (flags & FLAG_CHANGE_MASTER)
 		lockres->master_node_num = osb->node_num;
@@ -169,11 +169,11 @@
 	bool publish_flag = false;
 	struct buffer_head **bhs = NULL;
 
-	LOG_ENTRY_ARGS ("(osb=0x%08x, id=%u.%u, ty=%u, fl=%u, vm=0x%08x)\n",
-			osb, HILO (lock_id), lock_type, flags, LO (vote_map));
+	LOG_ENTRY_ARGS ("(osb=%p, id=" U64_MODIFIER ", ty=%u, fl=%u, vm=" U64_MODIFIER ")\n",
+			osb, lock_id, lock_type, flags, vote_map);
 
-	LOG_TRACE_ARGS ("osb=0x%08x, id=%u.%u, ty=%u, fl=%u, vm=0x%08x\n",
-			osb, HILO (lock_id), lock_type, flags, LO (vote_map));
+	LOG_TRACE_ARGS ("osb=%p, id=" U64_MODIFIER ", ty=%u, fl=%u, vm=" U64_MODIFIER "\n",
+			osb, lock_id, lock_type, flags, vote_map);
 
 	pubmap = osb->publ_map;
 	offset = osb->vol_layout.publ_sect_off;
@@ -231,7 +231,7 @@
 	p = OCFS_BH_GET_DATA_WRITE(bhs[osb->node_num]); /* write */
 	pubsect = (ocfs_publish *)p;
 	largestseqno++;
-	LOG_TRACE_ARGS ("largestseqno : %u.%u\n", HILO (largestseqno));
+	LOG_TRACE_ARGS ("largestseqno : " U64_MODIFIER "\n", largestseqno);
 	osb->publish_dirty = true;
 	pubsect->publ_seq_num = largestseqno;
 	pubsect->dirty = true;
@@ -361,9 +361,8 @@
 	__u32 curr_master;
 	__u8 lock_level;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u, 0x%08x, %u)\n", osb,
-			HI (offset), LO (offset), time_to_wait,
-			lockres, lock_type);
+	LOG_ENTRY_ARGS ("%p, " U64_MODIFIER ", %u, %p, %u)\n", 
+			osb, offset, time_to_wait, lockres, lock_type);
 
 	while (time_to_wait > timewaited) {
 		bh = NULL;
@@ -519,8 +518,8 @@
 	__u8 *p;
 	struct buffer_head **bhs = NULL;
 
-	LOG_ENTRY_ARGS ("(lockid=%u.%u, locktype=%u, votemap=0x%08x)\n",
-			HILO (lock_id), lock_type, LO (vote_map));
+	LOG_ENTRY_ARGS ("(lockid=" U64_MODIFIER ", locktype=%u, votemap=" U64_MODIFIER ")\n",
+			lock_id, lock_type, vote_map);
 
 	numnodes = OCFS_MAXIMUM_NODES;
 
@@ -592,12 +591,9 @@
 	__u64 offset = 0;
 	struct buffer_head *bh = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u)\n", osb, HI (lock_id),
-			LO (lock_id), lock_type);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %u)\n", osb,	lock_id, lock_type);
+	LOG_TRACE_ARGS ("%p, " U64_MODIFIER ", %u\n",   osb, lock_id, lock_type);
 
-	LOG_TRACE_ARGS ("0x%08x, %u.%u, %u\n", osb, HI (lock_id),
-			LO (lock_id), lock_type);
-
 	/* take lock to prevent publish overwrites by vote_req and nm thread */
 	down (&(osb->publish_lock));
 
@@ -649,13 +645,13 @@
 	__u64 gotvotemap = 0;
 	__u64 fileopenmap = 0;
 
-	LOG_ENTRY_ARGS ("(osb=0x%08x, id=%u.%u, ty=%u, fl=%u, vm=0x%08x, "
-		"sq:%u.%u)\n", osb, HILO (lock_id), lock_type, flags,
-		LO (vote_map), HILO (lock_seq_num));
+	LOG_ENTRY_ARGS ("(osb=%p, id=" U64_MODIFIER ", ty=%u, fl=%u, vm=" U64_MODIFIER ", "
+		"sq:" U64_MODIFIER ")\n", osb, lock_id, lock_type, flags,
+		vote_map, lock_seq_num);
 
-	LOG_TRACE_ARGS ("osb=0x%08x, id=%u.%u, ty=%u, fl=%u, vm=0x%08x, "
-		"sq=%u.%u\n", osb, HILO (lock_id), lock_type, flags,
-		LO (vote_map), HILO (lock_seq_num));
+	LOG_TRACE_ARGS ("osb=%p, id=" U64_MODIFIER ", ty=%u, fl=%u, vm=" U64_MODIFIER ", "
+		"sq=" U64_MODIFIER "\n", osb, lock_id, lock_type, flags,
+		vote_map, lock_seq_num);
 
 	while (time_to_wait > timewaited) {
 		ocfs_sleep (WAIT_FOR_VOTE_INCREMENT);
@@ -765,8 +761,8 @@
 	__u32 msg_len;
 	ocfs_dlm_msg_hdr *req;
 
-	LOG_ENTRY_ARGS ("(osb=0x%08x, id=%u.%u, ty=%u, fl=%u, vm=0x%08x)\n",
-			osb, HILO (lock_id), lock_type, flags, LO(vote_map));
+	LOG_ENTRY_ARGS ("(osb=%p, id=" U64_MODIFIER ", ty=%u, fl=%u, vm=" U64_MODIFIER ")\n",
+			osb, lock_id, lock_type, flags, vote_map);
 
 	msg_len = sizeof (ocfs_dlm_msg) - 1 + sizeof (ocfs_dlm_req_master);
 
@@ -891,7 +887,7 @@
 
 vote_success:
 	jif = jiffies - jif;
-	LOG_TRACE_ARGS ("Lock time: %u\n", jif);
+	LOG_TRACE_ARGS ("Lock time: %lu\n", jif);
 
 	/* Make this node the master of this lock */
 	if (lockres->lock_type <= lock_type)
@@ -933,7 +929,7 @@
 	int status = 0;
 	int cnt = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %d)\n", lockres, timeout);
+	LOG_ENTRY_ARGS ("(%p, %d)\n", lockres, timeout);
 
 	mypid = ocfs_getpid ();
 
@@ -985,11 +981,11 @@
  */
 void ocfs_release_lockres (ocfs_lock_res * lockres)
 {
-	LOG_ENTRY_ARGS ("(0x%08x)\n", lockres);
+	LOG_ENTRY_ARGS ("(%p)\n", lockres);
 
 	spin_lock (&lockres->lock_mutex);
 	if (lockres->in_use == 0) {
-		LOG_ERROR_ARGS("Releasing lockres with inuse 0: 0x%08x\n", lockres);
+		LOG_ERROR_ARGS("Releasing lockres with inuse 0: %p\n", lockres);
 		BUG();
 	} else {
 		if (lockres->thread_id != current->pid)
@@ -1098,9 +1094,9 @@
 	while (status == -EAGAIN) {
 		if (!IS_NODE_ALIVE (osb->publ_map, lockres->master_node_num,
 				    OCFS_MAXIMUM_NODES)) {
-			LOG_TRACE_ARGS ("Master (%u) dead, lockid %u.%u\n",
-				lockres->master_node_num,
-				HI (lockres->sector_num), LO (lockres->sector_num));
+			LOG_TRACE_ARGS ("Master (%u) dead, lockid " U64_MODIFIER "\n",
+					lockres->master_node_num, 
+					lockres->sector_num);
 			status = 0;
 			goto bail;
 		}
@@ -1108,9 +1104,8 @@
 		ocfs_acquire_lockres (lockres);
 
 		if (lockres->master_node_num == osb->node_num) {
-			LOG_TRACE_ARGS ("Added node to map 0x%08x, lockid %u.%u\n",
-			     LO (lockres->oin_openmap), HI (lockres->sector_num),
-			     LO (lockres->sector_num));
+			LOG_TRACE_ARGS ("Added node to map " U64_MODIFIER ", lockid " U64_MODIFIER "\n",
+			     lockres->oin_openmap, lockres->sector_num);
 
 			lockres->oin_openmap |= (1 << osb->node_num);
 			status = ocfs_update_disk_lock (osb, lockres,
@@ -1133,8 +1128,8 @@
 				if (status == -EAGAIN) {
 					ocfs_sleep (500);
 					if (ocfs_task_interruptible (osb)) {
-						LOG_TRACE_ARGS("interrupted... lockid=%u.%u\n",
-							HILO(lockres->sector_num));
+						LOG_TRACE_ARGS("interrupted... lockid=" U64_MODIFIER "\n",
+							lockres->sector_num);
 						status = -EINTR;
 						goto bail;
 					}
@@ -1158,8 +1153,7 @@
  */
 void ocfs_init_lockres (ocfs_super * osb, ocfs_lock_res * lockres, __u64 lock_id)
 {
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u.%u)\n", osb, lockres,
-			HI (lock_id), LO (lock_id));
+	LOG_ENTRY_ARGS ("(%p, %p, " U64_MODIFIER ")\n", osb, lockres, lock_id);
 
 	lockres->signature = 0x55AA;
 	lockres->lock_type = OCFS_DLM_NO_LOCK;
@@ -1204,8 +1198,7 @@
 	ocfs_lock_res *tmp_lockres = NULL;
 	bool is_dir = false;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u.%u, %u)\n", osb, oin,
-			HI (lock_id), LO (lock_id), flags);
+	LOG_ENTRY_ARGS ("(%p, %p, " U64_MODIFIER ", %u)\n", osb, oin, lock_id, flags);
 
 	is_dir = (flags & OCFS_OIN_DIRECTORY) ? true : false;
 
@@ -1378,8 +1371,8 @@
 	bool truncate_extend = false, have_cache_already = false;
 	int lock_path = invalid_path;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u, %u, 0x%08x, 0x%08x)\n", osb,
-			HI (lock_id), LO (lock_id), lock_type, flags, lr, bh);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %u, %u, %p, %p)\n", 
+			osb, lock_id, lock_type, flags, lr, bh);
 
 	if (bh != NULL)
 		b = bh;
@@ -1546,7 +1539,7 @@
 				if (status == -EAGAIN) {
 					ocfs_sleep (500);
 					if (ocfs_task_interruptible (osb)) {
-						LOG_TRACE_ARGS("interrupted... lockid=%u.%u\n", HILO(lock_id));
+						LOG_TRACE_ARGS("interrupted... lockid=" U64_MODIFIER "\n", lock_id);
 						status = -EINTR;
 						goto finally;
 					}
@@ -1576,8 +1569,8 @@
 			if (status == 0 || status == -ETIMEDOUT) {
 				/* lock released or waited too long, back to top */
 				if (status == -ETIMEDOUT) {
-					LOG_TRACE_ARGS("lock %u.%u, level %d, not being freed by node %u\n", 
-					       	HILO(lock_id), lockres->lock_type, lockres->master_node_num);
+					LOG_TRACE_ARGS("lock " U64_MODIFIER ", level %d, not being freed by node %u\n", 
+					       	lock_id, lockres->lock_type, lockres->master_node_num);
 				}
 				updated = false;
 				goto again;
@@ -1597,8 +1590,8 @@
 				if (status == -EAGAIN) {
 					ocfs_sleep (500);
 					if (ocfs_task_interruptible (osb)) {
-						LOG_TRACE_ARGS("interrupted... lockid=%u.%u\n",
-							HILO(lockres->sector_num));
+						LOG_TRACE_ARGS("interrupted... lockid=" U64_MODIFIER "\n",
+							lockres->sector_num);
 						status = -EINTR;
 						goto finally;
 					}
@@ -1690,8 +1683,8 @@
 	int lockflags = (lock_id >= osb->vol_layout.bitmap_off ? OCFS_BH_CACHED : 0);
 	bool clear_tmp = false;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u, %u, 0x%08x)\n", osb, HI (lock_id),
-			LO (lock_id), lock_type, flags, lockres);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %u, %u, %p)\n",
+			osb, lock_id, lock_type, flags, lockres);
 
 	if (bh != NULL)
 		b = &bh;
@@ -1817,13 +1810,13 @@
 			break;
 
 loop:
-		LOG_TRACE_ARGS ("id=%u.%u\n", HILO(lock_id));
+		LOG_TRACE_ARGS ("id=" U64_MODIFIER "\n", lock_id);
 		ocfs_sleep (500);
 	}
 
 finally:
 	jif = jiffies - jif;
-	LOG_TRACE_ARGS ("Lock time: %u\n", jif);
+	LOG_TRACE_ARGS ("Lock time: %lu\n", jif);
 
 	if (disk_vote && !disk_reset) {
 		tmpstat = ocfs_reset_voting (osb, lock_id, lock_type, oin_node_map);
@@ -1834,7 +1827,7 @@
 	fe = (ocfs_file_entry *)OCFS_BH_GET_DATA_WRITE(*b); /* write */
 
 	LOG_TRACE_ARGS("writing lock now... releasemaster: %s, level: %d, master: %d\n",
-		       flags & FLAG_FILE_RELEASE_MASTER, DISK_LOCK_FILE_LOCK (fe),
+		       flags & FLAG_FILE_RELEASE_MASTER ? "yes" : "no", DISK_LOCK_FILE_LOCK (fe),
 		       DISK_LOCK_CURRENT_MASTER (fe));
 	if (flags & FLAG_FILE_RELEASE_MASTER)
 		DISK_LOCK_CURRENT_MASTER (fe) = OCFS_INVALID_NODE_NUM;
@@ -1878,8 +1871,8 @@
 {
 	int status = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u, %u, 0x%08x)\n", osb, HI (lock_id),
-			LO (lock_id), lock_type, flags, lockres);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %u, %u, %p)\n",
+			osb, lock_id, lock_type, flags, lockres);
 
 	flags |= FLAG_RELEASE_LOCK;
 
@@ -2088,7 +2081,7 @@
 	while (status == -EAGAIN) {
 		if (!IS_NODE_ALIVE (osb->publ_map, lockres->master_node_num,
 				    OCFS_MAXIMUM_NODES)) {
-			LOG_TRACE_ARGS ("Master (%u) is dead, lockid %u.%u\n",
+			LOG_TRACE_ARGS ("Master (%u) is dead, lockid " U64_MODIFIER "\n",
 				lockres->master_node_num, lockres->sector_num);
 			/* TODO recovery needs to be done here .....and then become master */
 			status = 0;
@@ -2163,11 +2156,11 @@
 			break;
 
 loop:
-		LOG_TRACE_ARGS ("id=%u.%u\n", HILO(lockres->sector_num));
+		LOG_TRACE_ARGS ("id=" U64_MODIFIER "\n", lockres->sector_num);
 		ocfs_sleep (500);
 		if (ocfs_task_interruptible (osb)) {
-			LOG_TRACE_ARGS("interrupted.... lockid=%u.%u\n",
-				HILO(lockres->sector_num));
+			LOG_TRACE_ARGS("interrupted.... lockid=" U64_MODIFIER "\n",
+				lockres->sector_num);
 			status = -EINTR;
 			goto finito;
 		}
@@ -2185,7 +2178,7 @@
 	}
 
 	jif = jiffies - jif;
-	LOG_TRACE_ARGS ("Lock time: %u\n", jif);
+	LOG_TRACE_ARGS ("Lock time: %lu\n", jif);
 
 	if (disk_vote && !disk_reset) {
 		tmpstat = ocfs_reset_voting (osb, lockres->sector_num,
Index: src/bitmap.c
===================================================================
--- src/bitmap.c	(revision 31)
+++ src/bitmap.c	(working copy)
@@ -42,7 +42,7 @@
 {
 	__u32 tmp;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, %u)\n", bitmap, validbits, allocbits);
+	LOG_ENTRY_ARGS ("(%p, %u, %u)\n", bitmap, validbits, allocbits);
 
 	bitmap->validbits = validbits;
 	bitmap->allocbits = allocbits;
@@ -137,7 +137,7 @@
 	int c;
 	struct buffer_head *currbh = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %u, %u, %u)\n", osb, bitmap, numBits,
+	LOG_ENTRY_ARGS ("(%p, %p, %u, %u, %u)\n", osb, bitmap, numBits,
 			offset, sysonly);
 
 	globalsize = bitmap->validbits - sysonly;
@@ -258,7 +258,7 @@
 		OCFS_BH_PUT_DATA(currbh);
 	}
 
-	LOG_EXIT_ULONG (count);
+	LOG_EXIT_STATUS (count);
 	return count;
 }				/* ocfs_count_bits */
 
@@ -277,7 +277,7 @@
 	void *buff;
 	int i, local;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, %u)\n", bitmap, start, num);
+	LOG_ENTRY_ARGS ("(%p, %u, %u)\n", bitmap, start, num);
 
 	if ((start + num) > bitmap->validbits) {
 		LOG_ERROR_ARGS("bitmap->validbits = %u but start = %u and "  \
@@ -318,7 +318,7 @@
 	void *buff;
 	int i, local;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u, %u)\n", bitmap, start, num);
+	LOG_ENTRY_ARGS ("(%p, %u, %u)\n", bitmap, start, num);
 
 	if ((start + num) > bitmap->validbits) {
 		LOG_ERROR_ARGS("bitmap->validbits = %u but start = %u and "  \
Index: src/vote.c
===================================================================
--- src/vote.c	(revision 31)
+++ src/vote.c	(working copy)
@@ -118,10 +118,10 @@
 	struct sockaddr_in sin;
 	mm_segment_t oldfs;
 
-	LOG_ENTRY_ARGS ("(votemap=0x%x)\n", LO(votemap));
+	LOG_ENTRY_ARGS ("(" U64_MODIFIER ")\n", votemap);
 
 	oldfs = get_fs ();
-	for (map = LO(votemap), num = 0; map != 0; map >>= 1, num++) {
+	for (map = votemap, num = 0; map != 0; map >>= 1, num++) {
 		if (num == osb->node_num)
 			continue;
 
@@ -362,10 +362,9 @@
 		goto bail;
 	}
 
-	LOG_TRACE_ARGS("node=%u, lockid=%u.%u, seq=%u.%u, vote=%d\n",
-		       dlm_msg->src_node, HI(reply_msg->lock_id),
-		       LO(reply_msg->lock_id), HI(reply_msg->lock_seq_num),
-		       LO(reply_msg->lock_seq_num), reply->status);
+	LOG_TRACE_ARGS("node=%u, lockid=" U64_MODIFIER ", seq=" U64_MODIFIER ", vote=%d\n",
+		       dlm_msg->src_node, reply_msg->lock_id,
+		       reply_msg->lock_seq_num, reply->status);
 
 	ctxt.reply_method = COMM_VOTE;
 	ctxt.got_vote_map = &(lockres->got_vote_map);
@@ -388,9 +387,8 @@
 		    (reply_msg->flags & FLAG_FILE_UPDATE))
 			lockres->oin_openmap = lockres->tmp_openmap;
 		lockres->tmp_openmap = 0;
-		LOG_TRACE_ARGS ("OK vote, lockid=%u.%u, map: 0x%08x\n",
-				HI(lockres->sector_num), LO(lockres->sector_num),
-				LO(lockres->got_vote_map));
+		LOG_TRACE_ARGS ("OK vote, lockid=" U64_MODIFIER ", map: " U64_MODIFIER "\n",
+				lockres->sector_num, lockres->got_vote_map);
 		lockres->vote_state = 0;
 		atomic_set (&lockres->voted_event_woken, 1);
 		wake_up (&lockres->voted_event);
@@ -512,7 +510,7 @@
 	__u32 msg_len;
 	ocfs_dlm_msg_hdr *req;
 
-	LOG_ENTRY_ARGS ("(osb=0x%08x, vm=0x%08x)\n", osb, LO(vote_map));
+	LOG_ENTRY_ARGS ("(osb=%p, vm=" U64_MODIFIER ")\n", osb, vote_map);
 
 	msg_len = sizeof (ocfs_dlm_msg) - 1 + sizeof (ocfs_dlm_req_master);
 
Index: src/util.c
===================================================================
--- src/util.c	(revision 31)
+++ src/util.c	(working copy)
@@ -270,7 +270,7 @@
 		*oin = GET_INODE_OIN(inode);
 	*off = GET_INODE_VOTEOFF (inode);
 
-	LOG_TRACE_ARGS("offset=%u.%u, i_ino=%u\n", HILO((*off)), inode->i_ino);
+	LOG_TRACE_ARGS("offset=" U64_MODIFIER ", i_ino=%lu\n", (*off), inode->i_ino);
 
 	if (*off == -1)
 		BUG();
@@ -388,9 +388,9 @@
 void ocfs_truncate_inode_pages(struct inode *inode, loff_t off)
 {
 #if LINUX_VERSION_CODE <= LinuxVersionCode(2,4,10)
-	LOG_TRACE_ARGS ("NOT truncating pages for inode %p from offset %u.%u\n", inode, off);
+	LOG_TRACE_ARGS ("NOT truncating pages for inode %p from offset " U64_MODIFIER "\n", inode, off);
 #else
-	LOG_TRACE_ARGS ("truncating pages for inode %p from offset %u.%u\n", inode, off);
+	LOG_TRACE_ARGS ("truncating pages for inode %p from offset %Lu\n", inode, off);
 	truncate_inode_pages(&inode->i_data, off);
 #endif
 }				/* ocfs_truncate_inode_pages */
@@ -471,7 +471,7 @@
                 addr = *stack++;
                 if (ocfs_kernel_text_address(addr)) {
                 //        lookup_symbol(addr, buffer, 512);
-                        printk("[<%08lx>] %s (0x%x)\n", addr," ",stack-1);
+                        printk("[<%08lx>] %s (%p)\n", addr," ",stack-1);
                 }
         }
         printk("\n");
Index: src/dir.c
===================================================================
--- src/dir.c	(revision 31)
+++ src/dir.c	(working copy)
@@ -54,7 +54,7 @@
 	int ret = 0;
 	struct inode *inode = filp->f_dentry->d_inode;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", filp, dirent, 
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", filp, dirent, 
                         filp->f_dentry->d_name.len, filp->f_dentry->d_name.name);
 
 	pos = filp->f_pos;
@@ -126,11 +126,11 @@
 					    break;
 				    entry = (ocfs_file_entry *) OCFS_BH_GET_DATA_READ(entry_bh); /* read */
                                     r=filldir (dirent, entry->filename, strlen (entry->filename), filp->f_pos,
-                                                 LO (entry->this_sector), DT_UNKNOWN);
+                                                 entry->this_sector, DT_UNKNOWN);
                             	    if (r < 0) {
                                     	memcpy(ofile->filldir.fname, entry->filename, OCFS_MAX_FILENAME_LENGTH);
                                     	ofile->filldir.pos = filp->f_pos;
-                                    	ofile->filldir.ino = LO (entry->this_sector);
+                                    	ofile->filldir.ino = entry->this_sector;
 				    }
 			    	    OCFS_BH_PUT_DATA(entry_bh);
 				    brelse(entry_bh);
@@ -175,7 +175,7 @@
 
 	/* TODO: change this to take a buffer head instead of fe */
 
-	LOG_ENTRY_ARGS ("(osb=%p, parent=%u.%u, fname=%p, fe_bh=%p, ofile=%p, inode=%p)\n", osb, parent_off, file_name, fe_bh, ofile, inode);
+	LOG_ENTRY_ARGS ("(osb=%p, parent=" U64_MODIFIER ", fname=%p, fe_bh=%p, ofile=%p, inode=%p)\n", osb, parent_off, file_name, fe_bh, ofile, inode);
 
 	nbhs = osb->vol_layout.dir_node_size >> 9;
 	bufsz = nbhs * (sizeof(struct buffer_head *));
@@ -503,7 +503,7 @@
 	if (DirNode)
 		ocfs_safefree(DirNode);
 
-	LOG_EXIT_ULONG (bRet);
+	LOG_EXIT_STATUS (bRet);
 	return bRet;
 }				/* ocfs_search_dir_node */
 
@@ -618,7 +618,7 @@
 bail:
 	if (DirNode)
 		OCFS_BH_PUT_DATA(bhs[0]);
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_find_index */
 
@@ -1091,9 +1091,9 @@
 	locknode_off = LockNode->node_disk_off;
 	locknode_head_del = LockNode->head_del_ent_node;
 
-	LOG_TRACE_ARGS("ocfs_insert_file: head_del=%u.%u, free_node=%u.%u, locknode=%u.%u\n",
-		       HILO(LockNode->head_del_ent_node), HILO(LockNode->free_node_ptr),
-		       HILO(locknode_off));
+	LOG_TRACE_ARGS("ocfs_insert_file: head_del=" U64_MODIFIER ", free_node=" U64_MODIFIER ", locknode=" U64_MODIFIER "\n",
+		       LockNode->head_del_ent_node, LockNode->free_node_ptr,
+		       locknode_off);
 
 	if (locknode_head_del != INVALID_NODE_POINTER)
 		dir_off = locknode_head_del;
@@ -1102,7 +1102,7 @@
 	else
 		dir_off = locknode_off;
 	
-	LOG_TRACE_ARGS("ocfs_insert_file: dir_off selected was %u.%u\n", HILO(dir_off));
+	LOG_TRACE_ARGS("ocfs_insert_file: dir_off selected was " U64_MODIFIER "\n", dir_off);
 
 	parent_is_lock_node = (dir_off == locknode_off);
 	OCFS_BH_PUT_DATA(lock_bh);
@@ -1143,7 +1143,7 @@
 	/* start from locknode, travel along next_node_ptr */
 	dir_off = locknode_off;
 	while (1) {
-		LOG_TRACE_ARGS("ocfs_insert_file: now checking %u.%u\n", dir_off);
+		LOG_TRACE_ARGS("ocfs_insert_file: now checking " U64_MODIFIER "\n", dir_off);
 		status = ocfs_read_dirnode(osb, dir_off, false, bhs, dir_inode);
 		if (status < 0) {
 			LOG_ERROR_STATUS (status);
@@ -1157,12 +1157,12 @@
 		DirNode = NULL;
 
 		if (dir_num_ent_used < osb->max_dir_node_ent) {
-			LOG_TRACE_ARGS("ocfs_insert_file: num_ent_used for %u.%u is good (%d)\n", dir_off, 
+			LOG_TRACE_ARGS("ocfs_insert_file: num_ent_used for " U64_MODIFIER " is good (%d)\n", dir_off, 
 				       dir_num_ent_used);
 			new_head_del = dir_off;
 			break;
 		}
-		LOG_TRACE_ARGS("ocfs_insert_file: next_node pointer for %u.%u is %u.%u\n", dir_off, dir_next_node);
+		LOG_TRACE_ARGS("ocfs_insert_file: next_node pointer for " U64_MODIFIER " is " U64_MODIFIER "\n", dir_off, dir_next_node);
 		dir_off = dir_next_node;
 		if (dir_off == INVALID_NODE_POINTER) {
 			new_head_del = INVALID_NODE_POINTER;
Index: src/sysfile.c
===================================================================
--- src/sysfile.c	(revision 31)
+++ src/sysfile.c	(working copy)
@@ -145,10 +145,10 @@
 	int flags = OCFS_BH_CACHED;
 	bool bWriteThru = false;
 
-	LOG_ENTRY_ARGS ("(FileId = %u, metadatafile = %u, offset = (%u.%u), "
-			"Length = (%u.%u))\n", FileId, 
-			OCFS_FILE_VOL_META_DATA + osb->node_num, HILO(Offset),
-			HILO(Length));
+	LOG_ENTRY_ARGS ("(FileId = %u, metadatafile = %u, offset = (" U64_MODIFIER "), "
+			"Length = (" U64_MODIFIER "))\n", FileId, 
+			OCFS_FILE_VOL_META_DATA + osb->node_num, Offset,
+			Length);
 
 	if ((FileId == (OCFS_FILE_VOL_LOG_FILE + osb->node_num)) ||
 	    (FileId == (OCFS_FILE_VOL_META_DATA + osb->node_num))) {
@@ -273,7 +273,7 @@
 	if (Buffer)
 		vfree(Buffer);
 
-	LOG_EXIT_ARGS ("%u.%u", HI (StartOffset), LO (StartOffset));
+	LOG_EXIT_ARGS ("" U64_MODIFIER "", StartOffset);
 	return StartOffset;
 }				/* ocfs_file_to_disk_off */
 
@@ -312,7 +312,7 @@
 	fe = (ocfs_file_entry *) OCFS_BH_GET_DATA_READ(fe_bh); /* read */
 
 	if (!IS_VALID_FILE_ENTRY (fe)) {
-		LOG_ERROR_ARGS("offset=%u.%u", HILO (offset));
+		LOG_ERROR_ARGS("offset=" U64_MODIFIER "", offset);
 		status = -EINVAL;
 		goto leave;
 	}
@@ -351,8 +351,7 @@
 	char *data;
 	struct buffer_head **bhs;
 
-	LOG_ENTRY_ARGS ("(FileId = %u, Size = %u.%u)\n", FileId, HI (FileSize),
-			LO (FileSize));
+	LOG_ENTRY_ARGS ("(FileId = %u, Size = " U64_MODIFIER ")\n", FileId, FileSize);
 
 	OCFS_ASSERT (osb);
 
@@ -775,8 +774,8 @@
 	}
 
 	if (allocSize < neededSize) {
-		LOG_TRACE_ARGS ("allocSize(%u.%u) < neededSize(%u.%u)",
-				HILO (allocSize), HILO (neededSize));
+		LOG_TRACE_ARGS ("allocSize(" U64_MODIFIER ") < neededSize(" U64_MODIFIER ")",
+				allocSize, neededSize);
 		status = ocfs_extend_system_file (osb,
 				  (OCFS_FILE_VOL_META_DATA + osb->node_num),
 				  neededSize, NULL, NULL, false);
Index: src/file.c
===================================================================
--- src/file.c	(revision 31)
+++ src/file.c	(working copy)
@@ -67,7 +67,7 @@
 	ocfs_sem *oin_sem = NULL;
 	int truncate_pages = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", inode, file, 
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", inode, file, 
                         file->f_dentry->d_name.len, file->f_dentry->d_name.name);
 	atomic_inc (&parent->i_count);
 
@@ -305,7 +305,7 @@
         struct dentry *dentry;
         struct inode *parent;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", inode, file,
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", inode, file,
                         file->f_dentry->d_name.len, file->f_dentry->d_name.name);
 
 	dentry = file->f_dentry;
@@ -369,8 +369,8 @@
                 goto do_parent_dec;
         }
                 
-        LOG_TRACE_ARGS ("openhandles: %d / osbfiles: %d / refcount: %d\n",
-                         oin->open_hndl_cnt, osb->file_open_cnt,
+        LOG_TRACE_ARGS ("openhandles: %d / osbfiles: %lu / refcount: %d\n",
+                         oin->open_hndl_cnt, (long int)osb->file_open_cnt,
                         atomic_read(&dentry->d_count)); 
                
         /* FIXME: in all the other places I run thru all the dentries */
@@ -428,7 +428,7 @@
 {
 	int err = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, '%*s')\n", file,
+	LOG_ENTRY_ARGS ("(%p, '%*s')\n", file,
                         file->f_dentry->d_name.len, file->f_dentry->d_name.name);
 
 #if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
@@ -446,7 +446,7 @@
 int ocfs_sync_file (struct file *file, struct dentry *dentry, int datasync)
 {
 	int err = 0;
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", file, dentry, datasync,
+	LOG_ENTRY_ARGS ("(%p, %p, %d, '%*s')\n", file, dentry, datasync,
                         dentry->d_name.len, dentry->d_name.name);
 #if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
 	fsync_inode_data_buffers(file->f_dentry->d_inode);
@@ -488,7 +488,7 @@
 	fileEntry = (ocfs_file_entry *)OCFS_BH_GET_DATA_READ(bh); /* read */
 
 	if (!IS_VALID_FILE_ENTRY(fileEntry)) {
-		LOG_ERROR_ARGS ("Invalid fe at offset %u.%u", HILO (file_off));
+		LOG_ERROR_ARGS ("Invalid fe at offset " U64_MODIFIER "", file_off);
 		OCFS_BH_PUT_DATA(bh);
 		status = -EFAIL;
 		goto leave;
@@ -612,7 +612,7 @@
 	struct super_block *sb = inode->i_sb;
 	int needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", filp, buf, count,
+	LOG_ENTRY_ARGS ("(%p, %p, %Zu, '%*s')\n", filp, buf, count,
                         filp->f_dentry->d_name.len, filp->f_dentry->d_name.name);
 
 	/* happy write of zero bytes */
@@ -651,8 +651,9 @@
 	}
 	
 	if (filp->f_flags & O_APPEND) {
-		LOG_TRACE_ARGS("O_APPEND: inode->i_size=%u, ppos was %u\n",
-			       inode->i_size, *ppos);
+		LOG_TRACE_ARGS("O_APPEND: inode->i_size=%lu, ppos was %lu\n",
+			       (long unsigned int)inode->i_size, 
+			       (long unsigned int)*ppos);
 		*ppos = inode->i_size;
 	}
 
@@ -717,22 +718,20 @@
 	if (writingAtEOF)
 		LOG_TRACE_STR ("Writing at EOF");
 
-	LOG_TRACE_ARGS ("ppos=%u.%u newsize=%u.%u cursize=%u.%u\n",
-			HI (*ppos), LO (*ppos), HI (newsize), LO (newsize),
-			HI (inode->i_size), LO (inode->i_size));
+	LOG_TRACE_ARGS ("ppos=%Lu newsize=" U64_MODIFIER " cursize=%Lu\n",
+			*ppos, newsize, inode->i_size);
 
 	if (writingAtEOF) {
 		LOG_TRACE_ARGS
-		    ("Will need more allocation: have=%u.%u, need=%u.%u\n",
-		     HI (oin->alloc_size), LO (oin->alloc_size), HI (newsize),
-		     LO (newsize));
+			("Will need more allocation: have=" U64_MODIFIER ", need=" U64_MODIFIER "\n",
+			 oin->alloc_size, newsize);
 
 		status = ocfs_extend_file (osb, oin->parent_dirnode_off, oin, newsize, &oin->file_disk_off, NULL, inode, NULL);
 		if (status < 0) {
 			if (status != -EINTR && status != -ENOSPC) {
 				LOG_ERROR_STATUS (status);
-				LOG_ERROR_ARGS ("Failed to extend file from %u.%u to %u.%u",
-			     		HILO (*ppos), HILO (newsize));
+				LOG_ERROR_ARGS ("Failed to extend file from %Lu to " U64_MODIFIER "",
+			     		*ppos, newsize);
 				ret = -ENOSPC;
 			} else
 				ret = status;
@@ -790,7 +789,7 @@
 	struct inode *inode = filp->f_dentry->d_inode;
 	int status = 0, needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", filp, buf, count,
+	LOG_ENTRY_ARGS ("(%p, %p, %Zu, '%*s')\n", filp, buf, count,
                         filp->f_dentry->d_name.len, filp->f_dentry->d_name.name);
 
 
@@ -861,8 +860,8 @@
 	ocfs_bitmap_free_head *free_head = NULL;
 	ocfs_journal_handle *handle = NULL;
 
-	LOG_ENTRY_ARGS ("(file_off = %u.%u, file_size = %u.%u\n", 
-		   HILO(file_off), HILO(file_size));
+	LOG_ENTRY_ARGS ("(file_off = " U64_MODIFIER ", file_size = " U64_MODIFIER "\n", 
+		   file_off, file_size);
 
 	changeSeqNum = osb->curr_trans_id;
 
@@ -883,7 +882,7 @@
 
 	fe = (ocfs_file_entry *)OCFS_BH_GET_DATA_READ(bh); /* read */
 	if (!IS_VALID_FILE_ENTRY(fe)) {
-		LOG_ERROR_ARGS ("Invalid fe at offset %u.%u", HILO (file_off));
+		LOG_ERROR_ARGS ("Invalid fe at offset " U64_MODIFIER "", file_off);
 		status = -EFAIL;
 		OCFS_BH_PUT_DATA(bh);
 		goto leave;
@@ -958,9 +957,9 @@
 	 * one. This really ought to check for other things too, like
 	 * a valid bit, etc. */
 	if (file_size > fe->file_size) {
-		LOG_TRACE_ARGS("asked to truncate file with size (%u.%u) "
-			       "to size (%u.%u)!\n", HILO(fe->file_size), 
-			       HILO(file_size));
+		LOG_TRACE_ARGS("asked to truncate file with size (" U64_MODIFIER ") "
+			       "to size (" U64_MODIFIER ")!\n", fe->file_size, 
+			       file_size);
 		OCFS_BH_PUT_DATA(bh);
 		if (oin)
 			ocfs_up_sem(&oin->main_res);
@@ -1094,7 +1093,7 @@
 	if (!IS_VALID_FILE_ENTRY(fileEntry)) {
 		printk("fe->signature=%8s\n", fileEntry->signature);
 		printk("fe->filename=%8s\n", fileEntry->filename);
-		LOG_ERROR_ARGS ("Invalid fe at offset %u.%u", HILO (*file_off));
+		LOG_ERROR_ARGS ("Invalid fe at offset " U64_MODIFIER "", *file_off);
 		status = -EFAIL;
 		OCFS_BH_PUT_DATA(bh);
 		goto leave;
@@ -1238,7 +1237,7 @@
 
 	/* Update tha file size and add the new one to old one. */
 	fileEntry->file_size = file_size;
-	LOG_TRACE_ARGS("fileEntry->alloc_size = %u.%u\n", HILO(fileEntry->alloc_size));
+	LOG_TRACE_ARGS("fileEntry->alloc_size = " U64_MODIFIER "\n", fileEntry->alloc_size);
 
 	if (attr)
 		OCFS_FE_SET_ATTRIBUTES(fileEntry, attr);
@@ -1325,7 +1324,7 @@
 	bool extended = false;
 	int needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, '%*s')\n", dentry,
+	LOG_ENTRY_ARGS ("(%p, '%*s')\n", dentry,
                         dentry->d_name.len, dentry->d_name.name);
 
 	osb = (ocfs_super *) OCFS_GENERIC_SB_P(inode->i_sb);
@@ -1501,7 +1500,7 @@
 	struct super_block *sb = dentry->d_inode->i_sb;
 	int status, needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", dentry, attr,
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", dentry, attr,
                         dentry->d_name.len, dentry->d_name.name);
 
 	inode = dentry->d_inode;
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 31)
+++ src/volcfg.c	(working copy)
@@ -76,12 +76,12 @@
 	}
 
 	if (atomic_read (&osb->lock_stop)) {
-		LOG_TRACE_ARGS ("Last Lock written : %d\n", jiffies);
+		LOG_TRACE_ARGS ("Last Lock written : %lu\n", jiffies);
 		atomic_set (&osb->lock_event_woken, 1);
 		brelse(bh);
 		wake_up (&osb->lock_event);
 	} else {
-		LOG_TRACE_ARGS ("Lock written : %d\n", jiffies);
+		LOG_TRACE_ARGS ("Lock written : %lu\n", jiffies);
 		mod_timer (&osb->lock_timer, jiffies + OCFS_VOLCFG_LOCK_ITERATE);
 	}
 
@@ -400,7 +400,7 @@
 			lock_buf = NULL;
 
 			/* Set timer to reiterate lock every few jiffies */
-			LOG_TRACE_ARGS ("Start Timer: %d\n", jiffies);
+			LOG_TRACE_ARGS ("Start Timer: %lu\n", jiffies);
 			osb->lock_timer.expires = jiffies +
 						  OCFS_VOLCFG_LOCK_ITERATE;
 			/* we get_bh here because we brelse later in
Index: src/hash.c
===================================================================
--- src/hash.c	(revision 31)
+++ src/hash.c	(working copy)
@@ -52,7 +52,7 @@
 	int status = 0;
 	__u32 tmp;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", osb, lock_res);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", osb, lock_res);
 
 	if (HASHTABLE_DESTROYED (&(osb->root_sect_node))) {
 		LOG_TRACE_STATUS (status = -EFAIL);
@@ -73,16 +73,16 @@
 
 	if (*found_lock_res) {
 		ocfs_get_lockres (*found_lock_res);
-		LOG_TRACE_ARGS ("isn: fres=0x%08x, ref=%d, lid=%u.%u\n",
+		LOG_TRACE_ARGS ("isn: fres=%p, ref=%d, lid=" U64_MODIFIER "\n",
 				*found_lock_res,
 				atomic_read (&((*found_lock_res)->lr_ref_cnt)),
-				HILO((*found_lock_res)->sector_num));
+				(*found_lock_res)->sector_num);
 	}
 	else {
 		ocfs_get_lockres (lock_res);
-		LOG_TRACE_ARGS ("isn: lres=0x%08x, ref=%d, lid=%u.%u\n", lock_res,
+		LOG_TRACE_ARGS ("isn: lres=%p, ref=%d, lid=" U64_MODIFIER "\n", lock_res,
 				atomic_read (&lock_res->lr_ref_cnt),
-				HILO(lock_res->sector_num));
+				lock_res->sector_num);
 	}	
 
 bail:
@@ -99,8 +99,7 @@
 	int status = 0;
 	__u32 len = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, 0x%08x)\n", osb, HI (lock_id),
-			LO (lock_id), lock_res);
+	LOG_ENTRY_ARGS ("(%p, " U64_MODIFIER ", %p)\n", osb, lock_id, lock_res);
 
 	if (HASHTABLE_DESTROYED (&(osb->root_sect_node))) {
 		status = -EFAIL;
@@ -121,8 +120,8 @@
 		}
 
 		ocfs_get_lockres (*lock_res);
-		LOG_TRACE_ARGS ("lsn: lid=%u.%u, lres=0x%08x, ref=%d\n",
-				HILO(lock_id), *lock_res,
+		LOG_TRACE_ARGS ("lsn: lid=" U64_MODIFIER ", lres=%p, ref=%d\n",
+				lock_id, *lock_res,
 				atomic_read (&((*lock_res)->lr_ref_cnt)));
 	} else
 		status = -ENOENT;		
@@ -138,7 +137,7 @@
  */
 void ocfs_remove_sector_node (ocfs_super * osb, ocfs_lock_res * lock_res)
 {
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", osb, lock_res);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", osb, lock_res);
 
 	if (HASHTABLE_DESTROYED (&(osb->root_sect_node))) {
 		LOG_TRACE_STATUS (-EFAIL);
@@ -150,9 +149,9 @@
 		goto bail;
 	}
 
-	LOG_TRACE_ARGS ("rsn: lres=0x%08x, ref=%d, lid=%u.%u\n", lock_res,
+	LOG_TRACE_ARGS ("rsn: lres=%p, ref=%d, lid=" U64_MODIFIER "\n", lock_res,
 			atomic_read (&lock_res->lr_ref_cnt),
-			HILO(lock_res->sector_num));
+			lock_res->sector_num);
 
 	ocfs_hash_del (&(osb->root_sect_node), &(lock_res->sector_num),
 		       sizeof (__u64));
@@ -352,7 +351,7 @@
 	/* Create a new bucket and add to the end of list */
 	if ((bucket = (HASHBUCKET *) ocfs_malloc (sizeof (HASHBUCKET))) == NULL) {
 		LOG_ERROR_ARGS ("unable to allocate %u bytes of memory",
-				sizeof (HASHBUCKET));
+				(unsigned int)sizeof (HASHBUCKET));
 		ret = 0;
 		goto bail;
 	}
@@ -659,7 +658,7 @@
 {
 	if (atomic_dec_and_lock(&sem->s_refcnt, &OcfsGlobalCtxt.bh_sem_hash_lock)) {
 		if (buffer_modified(sem->s_bh)) {
-			LOG_ERROR_ARGS("putting last refcount of a modified buffer!  block %d\n",
+			LOG_ERROR_ARGS("putting last refcount of a modified buffer!  block %lu\n",
 				       sem->s_bh->b_blocknr);
 		}
 		put_bh(sem->s_bh);
@@ -788,7 +787,7 @@
 		//	      sem->s_pid);
 			      
 		if (buffer_modified(sem->s_bh) && sem->s_pid == 0) {
-			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%d)\n", 
+			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%lu)\n", 
 				       newsem != sem ? "n old" : " new",
 				       sem->s_bh->b_blocknr);
 		}
@@ -1058,7 +1057,7 @@
 			LOG_TRACE_ARGS("missed block %lu, refcount %u, "
 				       "pid = %u\n",
 				       sem->s_blocknr, 
-				       sem->s_refcnt,
+				       atomic_read(&sem->s_refcnt),
 				       sem->s_pid);
 		}
 	}
@@ -1258,12 +1257,12 @@
 		/* this log_error_args is mainly for debugging */
 		if (atomic_read(&inum->i_inode->i_count) > 2)
 			LOG_ERROR_ARGS("inode (%lu) with i_count = %u left in "
-				       "system, (voteoff = %u.%u, "
-				       "fileoff = %u.%u)\n", 
+				       "system, (voteoff = " U64_MODIFIER ", "
+				       "fileoff = " U64_MODIFIER ")\n", 
 				       inum->i_inode->i_ino,
 				       atomic_read(&inum->i_inode->i_count),
-				       HILO(inum->i_voteoff), 
-				       HILO(inum->i_feoff));
+				       inum->i_voteoff, 
+				       inum->i_feoff);
 
 		if (inum->i_inode)
 			iput(inum->i_inode);
@@ -1374,7 +1373,7 @@
 	ocfs_inode_hash *h = &osb->inode_hash;
 	struct inode * inode = NULL;
 
-//	LOG_ENTRY_ARGS("(voteoff=%u.%u, reverse = %s)\n", HILO(voteoff),
+//	LOG_ENTRY_ARGS("(voteoff=" U64_MODIFIER ", reverse = %s)\n", voteoff,
 //		       reverse ? "true" : "false");
 
 search:
@@ -1423,8 +1422,8 @@
 	unsigned long ino = 0;
 	struct super_block *sb = osb->sb;
 
-	LOG_ENTRY_ARGS("(offset = %u.%u, fe_off = %u.%u)\n", 
-		       HILO(offset), HILO(fe_off));
+	LOG_ENTRY_ARGS("(offset = " U64_MODIFIER ", fe_off = " U64_MODIFIER ")\n", 
+		       offset, fe_off);
 
 again:
 	spin_lock(&h->lock);
@@ -1433,16 +1432,14 @@
 
 	/* whoa, offset better be the same! */
 	if (inum && (inum->i_voteoff != offset)) {
-		LOG_ERROR_ARGS("inum=%p, i_voteoff=%u.%u, offset=%u.%u)\n",
-			       inum, inum ? inum->i_voteoff : 0ULL,
-			       offset);
+		LOG_ERROR_ARGS("inum=%p, i_voteoff=" U64_MODIFIER ", offset=" U64_MODIFIER ")\n",
+			       inum, inum ? inum->i_voteoff : 0UL, offset);
 		BUG();
 	}
 
 	if (inum && (inum->i_feoff != fe_off)) {
-		LOG_ERROR_ARGS("inum=%p, i_feoff=%u.%u, fe_off=%u.%u)\n",
-			       inum, inum ? inum->i_feoff : 0ULL,
-			       fe_off);
+		LOG_ERROR_ARGS("inum=%p, i_feoff=" U64_MODIFIER ", fe_off=" U64_MODIFIER ")\n",
+			       inum, inum ? inum->i_feoff : 0UL, fe_off);
 		BUG();
 	}
 
@@ -1501,26 +1498,26 @@
 	ocfs_inode_hash *h = &osb->inode_hash;
 	ocfs_inode_num *inum = NULL;
 
-	LOG_ENTRY_ARGS("(voteoff=%u.%u, inode->i_ino = %lu)\n",
-		       HILO(voteoff), inode->i_ino);
+	LOG_ENTRY_ARGS("(voteoff=" U64_MODIFIER ", inode->i_ino = %lu)\n",
+		       voteoff, inode->i_ino);
 
 	spin_lock(&h->lock);
 
 	inum = __ocfs_inode_hash_lookup(h, voteoff);
 
 	if (!inum) {
-		printk("ocfs: lost inum, offset = %u.%u, inode->i_ino = %lu\n",
-		       HILO(voteoff), inode->i_ino);
+		printk("ocfs: lost inum, offset = " U64_MODIFIER ", inode->i_ino = %lu\n",
+		       voteoff, inode->i_ino);
 
 		BUG();
 	}
 
 	if ((inum->i_voteoff != voteoff) 
 	    || (GET_INODE_VOTEOFF(inode) != voteoff)) {
-		LOG_ERROR_ARGS("passed=%u.%u, on inode=%u.%u, "
-			       "(inum voteoff = %u.%u, feoff = %u.%u)\n",
-			       HILO(voteoff), HILO(GET_INODE_VOTEOFF(inode)),
-			       HILO(inum->i_voteoff), HILO(inum->i_feoff));
+		LOG_ERROR_ARGS("passed=" U64_MODIFIER ", on inode=" U64_MODIFIER ", "
+			       "(inum voteoff = " U64_MODIFIER ", feoff = " U64_MODIFIER ")\n",
+			       voteoff, GET_INODE_VOTEOFF(inode),
+			       inum->i_voteoff, inum->i_feoff);
 		BUG();
 	}
 
@@ -1528,10 +1525,10 @@
 		LOG_ERROR_ARGS("inode numbers don't match! "
 			       "(inum=%lu, inode=%lu)\n", 
 			       inum->i_ino, inode->i_ino);
-		LOG_ERROR_ARGS("passed=%u.%u, on inode=%u.%u, "
-			       "(inum voteoff = %u.%u, feoff = %u.%u)\n",
-			       HILO(voteoff), HILO(GET_INODE_VOTEOFF(inode)),
-			       HILO(inum->i_voteoff), HILO(inum->i_feoff));
+		LOG_ERROR_ARGS("passed=" U64_MODIFIER ", on inode=" U64_MODIFIER ", "
+			       "(inum voteoff = " U64_MODIFIER ", feoff = " U64_MODIFIER ")\n",
+			       voteoff, GET_INODE_VOTEOFF(inode),
+			       inum->i_voteoff, inum->i_feoff);
 		BUG();
 	}
 
@@ -1540,13 +1537,13 @@
 		inum->i_state = INUM_BOUND;
 		atomic_inc(&inode->i_count);
 
-		LOG_TRACE_ARGS("bound to ino %lu, voteoff=%u.%u, "
-			       "feoff=%u.%u\n", inode->i_ino, 
-			       HILO(inum->i_voteoff), HILO(inum->i_feoff));
+		LOG_TRACE_ARGS("bound to ino %lu, voteoff=" U64_MODIFIER ", "
+			       "feoff=" U64_MODIFIER "\n", inode->i_ino, 
+			       inum->i_voteoff, inum->i_feoff);
 	} else if (inum->i_inode != inode) {
 		LOG_ERROR_ARGS("Inum is bound to a different inode!"
-			       "(%u.%u) (%lu) (%lu)\n",
-			       HILO(voteoff), inode->i_ino, 
+			       "(" U64_MODIFIER ") (%lu) (%lu)\n",
+			       voteoff, inode->i_ino, 
 			       inum->i_inode->i_ino);
 		BUG();
 	}
@@ -1571,8 +1568,8 @@
 	inum = __ocfs_inode_hash_lookup(h, off);
 
 	if (inum == NULL) {
-		printk("Cannot remove a nonexistent inum from hash! (%u.%u)\n",
-		       HILO(off));
+		printk("Cannot remove a nonexistent inum from hash! (" U64_MODIFIER ")\n",
+		       off);
 		BUG();
 	}
 
@@ -1589,7 +1586,7 @@
 {
 	ocfs_inode_num *inum = NULL;
 
-	LOG_ENTRY_ARGS("(off = %u.%u)\n", HILO(off));
+	LOG_ENTRY_ARGS("(off = " U64_MODIFIER ")\n", off);
 
 	spin_lock(&h->lock);
 
@@ -1626,9 +1623,9 @@
 	struct list_head *head;
 	int bucket;
 
-	LOG_ENTRY_ARGS("(oldoff = %u.%u, newoff = %u.%u, "
-		       "new_fe_off = %u.%u)\n", 
-		       HILO(oldoff), HILO(newoff), HILO(new_fe_off));
+	LOG_ENTRY_ARGS("(oldoff = " U64_MODIFIER ", newoff = " U64_MODIFIER ", "
+		       "new_fe_off = " U64_MODIFIER ")\n", 
+		       oldoff, newoff, new_fe_off);
 
 	spin_lock(&h->lock);
 
@@ -1638,9 +1635,9 @@
 		target = __ocfs_inode_hash_lookup(h, newoff);
 		if (target) {
 			LOG_ERROR_ARGS("Rehashing on top of an existing inum!"
-				       "oldoff = %u.%u, newoff = %u.%u\n", 
-				       HILO(oldoff),
-				       HILO(newoff));
+				       "oldoff = " U64_MODIFIER ", newoff = " U64_MODIFIER "\n", 
+				       oldoff,
+				       newoff);
 			BUG();
 		}
 	}
@@ -1704,7 +1701,7 @@
 	ocfs_file_entry *fe;
 	ocfs_find_inode_args args;
 
-	LOG_ENTRY_ARGS("(offset = %u.%u)\n", HILO(offset));
+	LOG_ENTRY_ARGS("(offset = " U64_MODIFIER ")\n", offset);
 
 	/* This is ugly, but...
 	 * There are several cases where we may not want an inode:
@@ -1720,16 +1717,16 @@
 		    offset >= ((JOURNAL_FILE_BASE_ID + OCFS_MAXIMUM_NODES)
 			       * osb->sect_size 
 			       + osb->vol_layout.root_int_off)) {
-			printk("skipping inode create for %u.%u\n", 
-			       HILO(offset));
+			printk("skipping inode create for " U64_MODIFIER "\n", 
+			       offset);
 			goto bail;
 		}
 	}
 
 	/* if they ask for the root dirnode, just return it. */
 	if (offset == osb->vol_layout.root_start_off) {
-		LOG_TRACE_ARGS("Asked for root dirnode (%u.%u)\n",
-			       HILO(offset));
+		LOG_TRACE_ARGS("Asked for root dirnode (" U64_MODIFIER ")\n",
+			       offset);
 
 		inode = osb->sb->s_root->d_inode;
 
Index: src/sem.c
===================================================================
--- src/sem.c	(revision 31)
+++ src/sem.c	(working copy)
@@ -92,7 +92,7 @@
 		}
 	}
 
-	LOG_EXIT_ULONG (ret);
+	LOG_EXIT_STATUS (ret);
 	return ret;
 }				/* ocfs_down_sem */
 
Index: src/oin.c
===================================================================
--- src/oin.c	(revision 31)
+++ src/oin.c	(working copy)
@@ -467,7 +467,7 @@
 	int status = 0;
 	ocfs_inode *oin = NULL;
 
-	LOG_ENTRY_ARGS("(alloc_size = %u.%u)\n", HILO(alloc_size));
+	LOG_ENTRY_ARGS("(alloc_size = " U64_MODIFIER ")\n", alloc_size);
 
 	OCFS_ASSERT (osb);
 
@@ -650,7 +650,7 @@
 		__u64 savedOffset = oin->file_disk_off;
 
 		CLEAR_INODE_OIN(inode);
-		LOG_TRACE_ARGS ("inode oin cleared / flags: %d / offset: %u.%u\n",
+		LOG_TRACE_ARGS ("inode oin cleared / flags: %d / offset: " U64_MODIFIER "\n",
 			inode->i_flags, savedOffset);
 	}
 
@@ -696,7 +696,7 @@
 	int status = 0;
 
 
-	LOG_ENTRY_ARGS ("(oin = 0x%08x)\n", oin);
+	LOG_ENTRY_ARGS ("(oin = %p)\n", oin);
 
 	if (oin == NULL)
 		goto bail;
@@ -731,8 +731,8 @@
 		lockResource = (ocfs_lock_res *) oin->lock_res;
 		if (lockResource == NULL) {
 			LOG_ERROR_ARGS("lockres=null, oin->file_disk_off "
-				       "= %u.%u\n", 
-				       HILO(oin->file_disk_off));
+				       "= " U64_MODIFIER "\n", 
+				       oin->file_disk_off);
 
 			goto bail;
 		}
@@ -763,7 +763,7 @@
 			if (val == lockResource)
 				ocfs_remove_sector_node (osb, val);
 			else
-				LOG_ERROR_ARGS("(lres=0x%08x) != (val=0x%08x)",
+				LOG_ERROR_ARGS("(lres=%p) != (val=%p)",
 					       lockResource, val);
 			ocfs_put_lockres (val);
 		} else {
@@ -773,7 +773,7 @@
 				LOG_TRACE_ARGS ("hashtable already destroyed\n");
 				goto bail;
 			}
-			LOG_ERROR_ARGS("lres=0x%08x is not in the hash!",
+			LOG_ERROR_ARGS("lres=%p is not in the hash!",
 				       lockResource);
 		}
 		ocfs_put_lockres (oin->lock_res);
Index: src/symlink.c
===================================================================
--- src/symlink.c	(revision 31)
+++ src/symlink.c	(working copy)
@@ -121,7 +121,7 @@
 	struct inode *inode = (struct inode *)data;
 	ocfs_super *osb = (ocfs_super *) OCFS_GENERIC_SB_P(inode->i_sb);
 
-        sprintf(buf,"%ld",osb->node_num);
+        sprintf(buf,"%u",osb->node_num);
         l = strlen(buf);
 
         if (str) {
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 31)
+++ src/inc/ocfs.h	(working copy)
@@ -96,6 +96,18 @@
 
 #include "journal.h"
 
+#if defined(__ia64__) || defined(__ppc64__)
+#define U64_MODIFIER "%lu"
+#else
+#define U64_MODIFIER "%Lu"
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#define SECTOR_MODIFIER U64_MODIFIER
+#else
+#define SECTOR_MODIFIER "%lu"
+#endif
+
 typedef enum { false = 0, true = 1 } ocfs_bool;
 
 /* This should be removed and all old code fixed to just use ocfs_bool */
@@ -1162,11 +1174,6 @@
 extern __u32 debug_level;
 extern __u32 debug_exclude;
 
-#define HI(val)            ((unsigned long)(((val) >> 16) >> 16))
-#define LO(val)            ((unsigned long)((val) & 0x00000000FFFFFFFFUL))
-
-#define HILO(val)          HI(val), LO(val)
-
 /* Tracing Levels */
 #define OCFS_DEBUG_LEVEL_ERROR         0x00000001
 #define OCFS_DEBUG_LEVEL_TRACE         0x00000002
@@ -1399,8 +1406,8 @@
 #define LOG_EXIT()             LOG_EXIT_ARGS(NULL)
 #define LOG_EXIT_STATUS(val)   LOG_EXIT_ARGS("%d ", val)
 #define LOG_EXIT_LONG(val)     LOG_EXIT_ARGS("%d ", val)
-#define LOG_EXIT_ULONG(val)    LOG_EXIT_ARGS("%u ", val)
-#define LOG_EXIT_PTR(val)      LOG_EXIT_ARGS("0x%08x ", val)
+#define LOG_EXIT_ULONG(val)    LOG_EXIT_ARGS("%lu ", val)
+#define LOG_EXIT_PTR(val)      LOG_EXIT_ARGS("%p ", val)
 
 
 /* TRACE macros */
Index: src/inc/io.h
===================================================================
--- src/inc/io.h	(revision 31)
+++ src/inc/io.h	(working copy)
@@ -278,13 +278,13 @@
 				BUG();
 			} else if (bh->b_blocknr != 4720) {
 				OCFS_DO_HEX_DUMP(bh);
-				printk("uh oh!  dirnode is being written at blocknr=%u!\n", bh->b_blocknr);
+				printk("uh oh!  dirnode is being written at blocknr=%lu!\n", bh->b_blocknr);
 				BUG();
 			}
 		} else if (strncmp("FIL", fe->signature, strlen("FIL"))==0) {
 			if (fe->this_sector >> 9 != bh->b_blocknr) {
 				OCFS_DO_HEX_DUMP(bh);
-				printk("uh oh!  fe->this_sector (%u) != blocknr (%u)\n",
+				printk("uh oh!  fe->this_sector (%u) != blocknr (%lu)\n",
 				       (__u32)(fe->this_sector>>9), bh->b_blocknr);
 				BUG();
 			} else if (fe->extents[0].disk_off >> 9 == 4720) {
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 31)
+++ src/namei.c	(working copy)
@@ -71,7 +71,7 @@
 	unsigned long ino;
 	__u64 inode_off;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", dir, dentry,
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", dir, dentry,
                         dentry->d_name.len, dentry->d_name.name);
 
 	atomic_inc (&dir->i_count);
@@ -88,7 +88,7 @@
 		goto bail;
 	}
 
-	LOG_TRACE_ARGS("about to call find_files_on_disk with inode=%08x\n", dir);
+	LOG_TRACE_ARGS("about to call find_files_on_disk with inode=%p\n", dir);
 
 	status = ocfs_find_files_on_disk (osb, parentOffset, &(dentry->d_name), 
 					  &fe_bh, NULL, dir, true);
@@ -97,7 +97,7 @@
 	
 	fe = (ocfs_file_entry *) OCFS_BH_GET_DATA_READ(fe_bh); /* read */
 	if (!IS_VALID_FILE_ENTRY(fe)) {
-		printk("ocfs: invalid file entry!  parent=%u.%u, name='%*s'\n",
+		printk("ocfs: invalid file entry!  parent=" U64_MODIFIER ", name='%*s'\n",
 		       parentOffset, dentry->d_name.len, dentry->d_name.name);
 		BUG();
 	}
@@ -175,7 +175,7 @@
 	ocfs_inode *oin = NULL;
 	struct inode *inode = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, %d, '%*s')\n", dir, dentry, mode,
+	LOG_ENTRY_ARGS ("(%p, %p, %d, %d, '%*s')\n", dir, dentry, mode,
 			dev, dentry->d_name.len, dentry->d_name.name);
 	
 	atomic_inc (&dir->i_count);
@@ -281,9 +281,9 @@
 	if (S_ISDIR (mode)) 
 		oin->dir_disk_off = fe->extents[0].disk_off;
 
-	LOG_TRACE_ARGS("ocfs_mknod: new_fe_bh: this_sector = %u.%u, "
-		       "extents[0].disk_off = %u.%u\n",
-		       HILO(fe->this_sector), HILO(fe->extents[0].disk_off));
+	LOG_TRACE_ARGS("ocfs_mknod: new_fe_bh: this_sector = " U64_MODIFIER ", "
+		       "extents[0].disk_off = " U64_MODIFIER "\n",
+		       fe->this_sector, fe->extents[0].disk_off);
 	
 	oin->inode = inode;
 	ocfs_populate_inode (inode, fe, mode, oin, true);
@@ -342,7 +342,7 @@
 	int i;
 	unsigned long blk;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, %d, '%*s')\n", dir, dentry, mode,
+	LOG_ENTRY_ARGS ("(%p, %p, %d, %d, '%*s')\n", dir, dentry, mode,
 			dev, dentry->d_name.len, dentry->d_name.name);
 
 	if (new_fe_bh)
@@ -520,7 +520,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", dir, dentry, mode,
+	LOG_ENTRY_ARGS ("(%p, %p, %d, '%*s')\n", dir, dentry, mode,
                         dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs_mknod (dir, dentry, mode | S_IFDIR, OCFS_NODEV);
 	LOG_EXIT_LONG (ret);
@@ -535,7 +535,7 @@
 {
 	int ret;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", dir, dentry, mode,
+	LOG_ENTRY_ARGS ("(%p, %p, %d, '%*s')\n", dir, dentry, mode,
                         dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs_mknod (dir, dentry, mode | S_IFREG, OCFS_NODEV);
 	LOG_EXIT_LONG (ret);
@@ -550,7 +550,7 @@
 {
 	int status = -EPERM;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, 0x%08x, old='%*s' new='%*s')\n", old_dentry, dir, dentry,
+	LOG_ENTRY_ARGS ("(%p, %p, %p, old='%*s' new='%*s')\n", old_dentry, dir, dentry,
                         old_dentry->d_name.len, old_dentry->d_name.name,
                         dentry->d_name.len, dentry->d_name.name);
 
@@ -574,7 +574,7 @@
 	bool do_release = false;
 	struct inode *parentInode = dentry->d_parent->d_inode;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", dir, dentry,
+	LOG_ENTRY_ARGS ("(%p, %p, '%*s')\n", dir, dentry,
                         dentry->d_name.len, dentry->d_name.name);
 
 	inode = dentry->d_inode;
@@ -582,11 +582,11 @@
 	if (inode_data_is_oin (inode))
 		oin = GET_INODE_OIN(inode);
 
-	LOG_TRACE_ARGS("oin = 0x%08x\n", oin);
+	LOG_TRACE_ARGS("oin = %p\n", oin);
 	ocfs_linux_get_inode_offset (dir, &parentOff, NULL);
 
 	fileOff = GET_INODE_FEOFF(inode);
-	LOG_TRACE_ARGS("fileOff = %u.%u, ino = %lu\n", HILO(fileOff), inode->i_ino);
+	LOG_TRACE_ARGS("fileOff = " U64_MODIFIER ", ino = %lu\n", fileOff, inode->i_ino);
 
 	status = -EBUSY;
 	/* i_count > 2 is because we'll be holding a ref on it for our
@@ -689,8 +689,8 @@
 	struct buffer_head **tmpbh;
 	struct inode *tmpinode;
 
-	LOG_ENTRY_ARGS("(lock_id1 = %u.%u, lock_id2 = %u.%u)\n", HILO(id1), 
-		       HILO(id2));
+	LOG_ENTRY_ARGS("(lock_id1 = " U64_MODIFIER ", lock_id2 = " U64_MODIFIER ")\n", id1, 
+		       id2);
 
 	if (*bh1)
 		*bh1 = NULL;
@@ -794,9 +794,9 @@
 		goto bail;
 	}
 
-	LOG_TRACE_ARGS("fe->this_sector = %u.%u, fe->local_ext = %s, "
+	LOG_TRACE_ARGS("fe->this_sector = " U64_MODIFIER ", fe->local_ext = %s, "
 		       "fe->next_free_ext = %u\n",
-		       HILO(fe->this_sector), 
+		       fe->this_sector, 
 		       (fe->local_ext) ? "true" : "false",
 		       fe->next_free_ext);
 
@@ -896,7 +896,7 @@
 	__u32 newfe_lockid = 0;
 	int needs_trunc = 0;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, 0x%08x, 0x%08x, from='%*s' to='%*s')\n",
+	LOG_ENTRY_ARGS ("(%p, %p, %p, %p, from='%*s' to='%*s')\n",
 			old_dir, old_dentry, new_dir, new_dentry,
                         old_dentry->d_name.len, old_dentry->d_name.name,
                         new_dentry->d_name.len, new_dentry->d_name.name);
@@ -1150,8 +1150,8 @@
 			LOG_ERROR_STATUS (status);
 			goto finally;
 		}
-		LOG_TRACE_ARGS("(after) tmpfe->this_sector = %u.%u\n", 
-			       HILO(tmpfe->this_sector));
+		LOG_TRACE_ARGS("(after) tmpfe->this_sector = " U64_MODIFIER "\n", 
+			       tmpfe->this_sector);
 
 		if (oldOIN)
 			ocfs_down_sem(&oldOIN->main_res, true);
@@ -1302,7 +1302,7 @@
 	ocfs_lock_res *lock_res = NULL;
 
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, symname='%s' actual='%*s')\n", dir, 
+	LOG_ENTRY_ARGS ("(%p, %p, symname='%s' actual='%*s')\n", dir, 
 			dentry, symname, dentry->d_name.len, 
 			dentry->d_name.name);
 
@@ -1366,7 +1366,7 @@
 	status = ocfs_extend_file (osb, parent_off, NULL, newsize, &file_off, handle, inode, NULL);
 	if (status < 0) {
 		if (status != -ENOSPC && status != -EINTR) {
-			LOG_ERROR_ARGS ("Failed to extend file to %u.%u", HILO (newsize));
+			LOG_ERROR_ARGS ("Failed to extend file to " U64_MODIFIER "", newsize);
 			LOG_ERROR_STATUS(status);
 			status = -ENOSPC;
 		}
@@ -1823,8 +1823,8 @@
 
 	if (inode && status == 0 && !(flags & FLAG_DEL_INODE)) {
 		SET_INODE_DELETED(inode);
-		LOG_TRACE_ARGS("removing inode %lu, voteoff = %u.%u\n",
-		       inode->i_ino, HILO(GET_INODE_VOTEOFF(inode)));
+		LOG_TRACE_ARGS("removing inode %lu, voteoff = " U64_MODIFIER "\n",
+		       inode->i_ino, GET_INODE_VOTEOFF(inode));
 		ocfs_inode_hash_remove(&osb->inode_hash, 
 				       GET_INODE_VOTEOFF(inode));
 	}
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 31)
+++ src/alloc.c	(working copy)
@@ -91,7 +91,7 @@
 	ocfs_free_rec *log;
 	int status = 0, tmpstat;
 
-	LOG_ENTRY_ARGS("(osb=0x%08x, f=0x%08x, f->num_logs = %d)\n", osb, f,
+	LOG_ENTRY_ARGS("(osb=%p, f=%p, f->num_logs = %d)\n", osb, f,
 		       f->num_logs);
 
 	ocfs_take_trans_lock(osb);
@@ -182,7 +182,7 @@
 	__u64 lock_id;
 	struct buffer_head *globalbh = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", osb, free_log);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", osb, free_log);
 
 #define ALLOC_BLOCK(ptr, len, err)				\
 	do {							\
@@ -496,7 +496,7 @@
 	LOG_TRACE_ARGS("Free Log Details (type = %d):\n", Type);
 	LOG_TRACE_ARGS("num_updates = %u\n", FreeLog->num_updates);
 	for(i = 0; i < FreeLog->num_updates; i++)
-		LOG_TRACE_ARGS("(upd=%u, length=%u.%u, file_off=%u.%u, type=%d, node_num=%d)\n", i, HILO(FreeLog->update[i].length), HILO(FreeLog->update[i].file_off), FreeLog->update[i].type, FreeLog->update[i].node_num);
+		LOG_TRACE_ARGS("(upd=%u, length=" U64_MODIFIER ", file_off=" U64_MODIFIER ", type=%d, node_num=%d)\n", i, FreeLog->update[i].length, FreeLog->update[i].file_off, FreeLog->update[i].type, FreeLog->update[i].node_num);
 
 	switch (Type) {
 	    case DISK_ALLOC_DIR_NODE:
@@ -879,7 +879,7 @@
 	void *buf;
 	ocfs_file_entry * fe = NULL, *real_fe = NULL;
 
-	LOG_ENTRY_ARGS("(0x%08x, 0x%08x, %u.%u, %u.%u\n", osb, fe, HILO(disk_off), HILO(length));
+	LOG_ENTRY_ARGS("(%p, %p, " U64_MODIFIER ", " U64_MODIFIER "\n", osb, fe, disk_off, length);
 
 	/* too complicated to deal with both reads and writes to the structure     */
 	/* just save off a copy and replace the fe_bh with the new data at the end */
@@ -1130,7 +1130,7 @@
 	/* Update the File Entry Extent */
 	fe->local_ext = false;
 
-	LOG_TRACE_ARGS("fe->alloc_size = %u.%u\n", HILO(fe->alloc_size));
+	LOG_TRACE_ARGS("fe->alloc_size = " U64_MODIFIER "\n", fe->alloc_size);
 	fe->extents[0].file_off = 0;
 	fe->extents[0].num_bytes = fe->alloc_size + length;
 	fe->extents[0].disk_off = physicalOffset;
@@ -1165,7 +1165,7 @@
 	__u64 newExtentOff, up_ptr;
 	ocfs_file_entry * FileEntry = NULL;
 
-	LOG_ENTRY_ARGS("(actualDiskOffset=%u.%u, actualLength=%u.%u)\n", actualDiskOffset, actualLength);
+	LOG_ENTRY_ARGS("(actualDiskOffset=" U64_MODIFIER ", actualLength=" U64_MODIFIER ")\n", actualDiskOffset, actualLength);
 
 	FileEntry = (ocfs_file_entry *)OCFS_BH_GET_DATA_WRITE(fe_bh);  /* write */
 	OCFS_ASSERT (FileEntry);
@@ -1617,7 +1617,7 @@
 		}
 
 		if (IS_VALID_EXTENT_DATA(cur_extent)) {
-			LOG_TRACE_ARGS("found some data to free (%u.%u)\n", HI(cur_extent->this_ext), LO(cur_extent->this_ext));
+			LOG_TRACE_ARGS("found some data to free (" U64_MODIFIER ")\n", cur_extent->this_ext);
 			for(i = 0; i < cur_extent->next_free_ext; i++) {
 				/* Free the data associated with each header */
 				ext = &cur_extent->extents[i];
@@ -1635,7 +1635,7 @@
 			/* Did we already kill all his children, or
 			 * are they already dead? */
 			if (cur_extent->next_free_ext == 0) {
-				LOG_TRACE_ARGS("Popping this header (%u.%u)\n", HI(cur_extent->this_ext), LO(cur_extent->this_ext), cur_extent->next_free_ext);
+				LOG_TRACE_ARGS("Popping this header (" U64_MODIFIER ")\n", cur_extent->this_ext);
 				goto free_meta;
 			}
 
@@ -1949,7 +1949,7 @@
 		if (IS_VALID_EXTENT_DATA(AllocExtent)) {
 			/* shall we just do away with him? */
 			if (AllocExtent->extents[0].file_off >= newsize) {
-				LOG_TRACE_ARGS("Killing this data extent (%u, %u)\n", HI(AllocExtent->this_ext), LO(AllocExtent->this_ext));
+				LOG_TRACE_ARGS("Killing this data extent (" U64_MODIFIER ")\n", AllocExtent->this_ext);
 				/* Boundary case - what if this guy is
 				 * the last DAT we should delete
 				 * (i.e., split no more ;) */
@@ -1965,7 +1965,7 @@
 			} else {
 				/* Alright, we know for sure that
 				 * we're splitting in this guy. */
-				LOG_TRACE_ARGS("Splitting this data extent (%u, %u)\n", HI(AllocExtent->this_ext), LO(AllocExtent->this_ext));
+				LOG_TRACE_ARGS("Splitting this data extent (" U64_MODIFIER ")\n", AllocExtent->this_ext);
 				fe->last_ext_ptr = AllocExtent->this_ext;
 				AllocExtent->next_data_ext = 0;
 				/* total_bytes is used below to know
@@ -2076,10 +2076,8 @@
                          * are they already dead? */
                         if (AllocExtent->next_free_ext == 0) {
 				/*Ok, we're done with this guy, pop the stack*/
-                                LOG_TRACE_ARGS("Popping this header (%u.%u)\n",
-					       HI(AllocExtent->this_ext), 
-					       LO(AllocExtent->this_ext), 
-					       AllocExtent->next_free_ext);
+                                LOG_TRACE_ARGS("Popping this header (" U64_MODIFIER ")\n",
+					       AllocExtent->this_ext); 
 
 				status = ocfs_add_to_bitmap_free_head(osb, free_head, 1, AllocExtent->alloc_file_off, AllocExtent->alloc_node, DISK_ALLOC_EXTENT_NODE);
 				if (status < 0) {
@@ -2096,9 +2094,8 @@
 			/* changed this from > to >= */
 			/* Do we just delete this whole part of the tree? */
 			if (AllocExtent->extents[0].file_off >= newsize) {
-				LOG_TRACE_ARGS("whacking this tree: (%u.%u)\n",
-					       HI(AllocExtent->this_ext), 
-					       LO(AllocExtent->this_ext));
+				LOG_TRACE_ARGS("whacking this tree: (" U64_MODIFIER ")\n",
+					       AllocExtent->this_ext);
 
 				if (AllocExtent->extents[0].file_off ==newsize)
 					done = true;
@@ -2358,7 +2355,7 @@
 		goto finally;
         }
 
-	LOG_TRACE_ARGS("non-local extents. taking that code path, truncating to alloc_size of (%u.%u)\n", HI(alloc_size), LO(alloc_size));
+	LOG_TRACE_ARGS("non-local extents. taking that code path, truncating to alloc_size of (" U64_MODIFIER ")\n", alloc_size);
 	/* non-local extents */
 
 	updated_lep = false;
@@ -2400,7 +2397,7 @@
 			}
 
 			/* Ok, update the FileEntry */
-			LOG_TRACE_ARGS("Alright. num_bytes = (%u,%u), alloc_size = (%u,%u) file_off = (%u,%u)\n", HI(FileEntry->extents[i].num_bytes), LO(FileEntry->extents[i].num_bytes), HI(alloc_size), LO(alloc_size), HI(FileEntry->extents[i].file_off), LO(FileEntry->extents[i].file_off));
+			LOG_TRACE_ARGS("Alright. num_bytes = (" U64_MODIFIER "), alloc_size = (" U64_MODIFIER ") file_off = (" U64_MODIFIER ")\n", FileEntry->extents[i].num_bytes, alloc_size, FileEntry->extents[i].file_off);
 			FileEntry->extents[i].num_bytes = alloc_size;
 			for (j=0; j < i; j++) 
 				FileEntry->extents[i].num_bytes += FileEntry->extents[j].num_bytes;
@@ -2435,7 +2432,7 @@
 	if (extent_bh)
 		brelse(extent_bh);
 
-	LOG_EXIT_ULONG (status);
+	LOG_EXIT_STATUS (status);
 	return status;
 }  /* ocfs_free_extents_for_truncate */
 
@@ -2497,9 +2494,8 @@
 	}
 
 	if (!oin->journal_inode && Vbo >= (__s64) fe->alloc_size) {
-		LOG_ERROR_ARGS ("vbo=%u.%u, fe->alloc_sz=%u.%u oin->alloc_size=%u.%u", 
-				HILO (Vbo), HILO (fe->alloc_size),
-				HILO (oin->alloc_size));
+		LOG_ERROR_ARGS ("vbo=" U64_MODIFIER ", fe->alloc_sz=" U64_MODIFIER " oin->alloc_size=" U64_MODIFIER "",
+				Vbo, fe->alloc_size, oin->alloc_size);
 		status = -EFAIL;
 		goto finally;
 	}
@@ -2532,12 +2528,12 @@
 
 			if (remainingLength > 0) {
 				if (!OcfsExtent->next_data_ext) {
-					LOG_ERROR_ARGS ("vbo=%u.%u, "
-						"oin->alloc_size=%u.%u, "
-						" thisext=%u.%u",
-						HILO(localVbo), 
-						HILO(oin->alloc_size),
-						HILO(OcfsExtent->this_ext));
+					LOG_ERROR_ARGS ("vbo=" U64_MODIFIER ", "
+						"oin->alloc_size=" U64_MODIFIER ", "
+						" thisext=" U64_MODIFIER "",
+						localVbo, 
+						oin->alloc_size,
+						OcfsExtent->this_ext);
 					status = -EFAIL;
 					goto finally;
 				}
@@ -2915,7 +2911,7 @@
 	bool needs_uninit = false;
 	bool delay_lockrel = false;
 
-	LOG_ENTRY_ARGS("(FileSize = (%u.%u), Type=%d)\n", HILO(FileSize),Type);
+	LOG_ENTRY_ARGS("(FileSize = (" U64_MODIFIER "), Type=%d)\n", FileSize,Type);
 
 	ocfs_down_sem (&(osb->dir_alloc_lock), true);
 	ocfs_down_sem (&(osb->file_alloc_lock), true);
@@ -3087,8 +3083,8 @@
 
 	/* this can just fall through */
 	if (*file_off == 0) {
-		LOG_TRACE_ARGS ("offset=%u.%u, type=%x, blksz=%u, foundbit=%u\n",
-			HILO (*file_off), Type, blockSize, foundBit);
+		LOG_TRACE_ARGS ("offset=" U64_MODIFIER ", type=%x, blksz=%u, foundbit=%u\n",
+				*file_off, Type, blockSize, foundBit);
 	}
 
 leave:
@@ -3334,7 +3330,7 @@
 		buffer++;
 	}
 
-	LOG_EXIT_ULONG (count);
+	LOG_EXIT_STATUS (count);
 	return(count);
 } /* ocfs_alloc_count_bits */
 
@@ -3511,8 +3507,8 @@
 
 	/* we try to use find_contig_space_from_bitmap here for now. */
 	alloc_bytes = ocfs_local_alloc_window_bits(osb) * csize;
-	LOG_TRACE_ARGS("Allocating %u.%u bytes (%u clusters) for a "
-		       "new window.\n", HILO(alloc_bytes), 
+	LOG_TRACE_ARGS("Allocating " U64_MODIFIER " bytes (%u clusters) for a "
+		       "new window.\n", alloc_bytes, 
 		       ocfs_local_alloc_window_bits(osb));
 
 	status = ocfs_find_contiguous_space_from_bitmap(osb, alloc_bytes, 
@@ -3811,8 +3807,8 @@
 	__u32 csize = osb->vol_layout.cluster_size;
 	bool use_global = true;
 
-	LOG_ENTRY_ARGS("(file_size = (%u.%u), handle = 0x%x, sysfile = %s)\n", 
-		       HILO(file_size), handle, sysfile ? "true" : "false");
+	LOG_ENTRY_ARGS("(file_size = (" U64_MODIFIER "), handle = %p, sysfile = %s)\n", 
+		       file_size, handle, sysfile ? "true" : "false");
 
 	if (file_size == 0) {
 		LOG_ERROR_STR ("asking for an allocation of zero bytes...");
@@ -3853,8 +3849,8 @@
 	if (status < 0)
 		LOG_ERROR_STATUS(status);
 
-	LOG_TRACE_ARGS("Returning *cluster_off = %u.%u, *cluster_count"
-		       "= %u.%u\n", HILO(*cluster_off), HILO(*cluster_count));
+	LOG_TRACE_ARGS("Returning *cluster_off = " U64_MODIFIER ", *cluster_count"
+		       "= " U64_MODIFIER "\n", *cluster_off, *cluster_count);
 bail:
 
 	LOG_EXIT_STATUS(status);
@@ -3974,7 +3970,7 @@
 	ocfs_bitmap_free_head *f = NULL;
 	struct buffer_head *bh = NULL;
 
-	LOG_ENTRY_ARGS("(local_alloc_bh = 0x%x, sync = %s, "
+	LOG_ENTRY_ARGS("(local_alloc_bh = %p, sync = %s, "
 		       "in_recovery = %s)\n", local_alloc_bh,
 		       sync ? "true" : "false",
 		       in_recovery ? "true" : "false");
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 31)
+++ src/Makefile	(working copy)
@@ -2,7 +2,7 @@
 
 include $(TOPDIR)/Preamble.make
 
-WARNINGS = -Wall -Wstrict-prototypes -Wno-format
+WARNINGS = -Wall -Wstrict-prototypes 
 
 ifneq ($(OCFS_PROCESSOR),x86_64)
 WARNINGS += -Wmissing-prototypes -Wmissing-declarations
