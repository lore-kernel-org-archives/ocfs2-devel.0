From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri May 21 13:07:57 2004
Subject: [Ocfs2-devel] Error when mount ocfs2 partition on kernel 2.6.6
In-Reply-To: <941A6821ACE16D4BBB8A958A0EB047F730704A@pdsmsx404.ccr.corp.intel.com>
References: <941A6821ACE16D4BBB8A958A0EB047F730704A@pdsmsx404.ccr.corp.intel.com>
Message-ID: <20040521180751.GF25513@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Fri, May 21, 2004 at 06:24:25PM +0800, Chen, Yukun wrote:
> Hi All
> 
>          I find a hang issue when trying to mount an ocfs2 partition in a
> cluster environment. Machine 1 and machine 2 share a raid array.
> 
>          Steps to reproduce: (m1 represent machine 1, and m2 represent machine
> 2)
<snip>

So one of the machines is trying to recover the other one and dies, right?

<snip>
> Oracle Cluster FileSystem x y (build z)
> ocfs2: hostname is westvile2
> sectbits=9, clusterbits=12, dirbits=17, filebits=9
> ocfs2: Adding west1 (node 0) to clustered device (8,66)
> (3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1395: DISKVOTE!!: req_lock=2,
> flags=40000401, offset=1532416, inode=3
> (3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1398: DISKVOTE!!: this=1, master=
> 0, locktype=0, ronode=-1, romap=00000000
> Call Trace:
> [<dc16dbf4>]   (0xdc16dbf4)
> 
> ???
>  [<c0ed0000>]   (0xdc16dfd0)
> [<ffffe410>]   (0xdc16dfec)
> 
> (3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1395: DISKVOTE!!: req_lock=2,
> flags=40000401, offset=1532416, inode=3
> (3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1398: DISKVOTE!!: this=1, master=
> 0, locktype=0, ronode=-1, romap=00000000
> Call Trace:
> [<dc16dbf4>]   (0xdc16dbf4)
> [<ffffffff>]   (0xdc16dc04)
> 
> ???..
>  [<c0105f71>]   (0xdc16dfc0)
> [<c0ed0000>]   (0xdc16dfd0)
> [<ffffe410>]   (0xdc16dfec)
> 
> ocfs2: Removing west1 (node 0) from clustered device (8,66)
> ocfs2: Recovering node 0 from device (8,66)
> (fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status 0,
> recovered transactions 5 to 5
> (fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 0 and revoked 0/0
> blocks
> kjournald starting.  Commit interval 5 seconds
> Unable to handle kernel NULL pointer dereference at virtual address 0000001c
>  printing eip:
> e0ad4eeb
> *pde = 1dfef067
> *pte = 00000000
> Oops: 0000 [#1]
> SMP
> CPU:    2
> EIP:    0060:[<e0ad4eeb>]    Not tainted
> EFLAGS: 00010286   (2.6.6)
> EIP is at ocfs_bh_sem_lookup+0x1b/0x370 [ocfs2]
> eax: 00000000   ebx: 00000800   ecx: db405dc4   edx: 00000000
> esi: 00000000   edi: 00000000   ebp: dbe51e84   esp: dbe51e44
> ds: 007b   es: 007b   ss: 0068
> Process ocfs2rec-0 (pid: 3267, threadinfo=dbe50000 task=dd3ed480)
> Stack: db58d378 dc2ee600 db58d378 c1416be0 00014025 88ad2fc6 000000ba dd3ed630
>        c1416be0 c0498e20 dbe51ea8 00000000 c0498e20 00000000 00000000 00000000
>        dbe51e98 e0ad5257 00000000 00000000 00000000 dbe51efc e0ac175b 00000000
> Call Trace:
>  [<e0ad5257>] ocfs_bh_sem_lock+0x17/0x60 [ocfs2]
>  [<e0ac175b>] ocfs_sync_local_to_main+0x9b/0x7e0 [ocfs2]
>  [<e0ad4c90>] ocfs_bh_sem_put+0x20/0xb0 [ocfs2]
>  [<e0ad5472>] ocfs_bh_sem_unlock+0x32/0x50 [ocfs2]
>  [<e0adee39>] ocfs_read_bhs+0x3f9/0x8e0 [ocfs2]
>  [<e0ac369d>] ocfs_shutdown_local_alloc+0xdd/0x350 [ocfs2]
>  [<e0ac39f7>] ocfs_recover_local_alloc+0xe7/0x1c6 [ocfs2]
>  [<e0ae4ac9>] ocfs_recover_vol+0x699/0xc70 [ocfs2]
>  [<e0ae4163>] __ocfs_recovery_thread+0x113/0x1e0 [ocfs2]
>  [<e0ae4050>] __ocfs_recovery_thread+0x0/0x1e0 [ocfs2]
>  [<c01042e5>] kernel_thread_helper+0x5/0x10
>  
> 
>          Any ideas on this issue?

Ahh yes, that's a bug I inadvertantly introduced recently. The fix is in my
local tree and will get pushed out shortly with some other changes I'm
making to alloc.c. In the meantime you can apply this patch. Ignore the
warnings you'll get due to unused variables and whatnot -- that'll be
cleaned up in my commit.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com


Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 930)
+++ src/alloc.c	(working copy)
@@ -3416,50 +3416,6 @@ static int ocfs_sync_local_to_main(ocfs_
 	}
 	OCFS_BH_PUT_DATA(local_alloc_bh);
 
-	if (bm_lock_bh) {
-		local_lock = 0;
-		bh = bm_lock_bh;
-	}
-	
-	if (bm_inode) {
-		atomic_inc(&bm_inode->i_count);
-		local_inode = bm_inode;
-	} else {
-		local_inode = ocfs_iget(osb, OCFS_BITMAP_LOCK_OFFSET, NULL);
-		if (!local_inode) {
-			status = -EINVAL;
-			LOG_ERROR_STATUS(status);
-			goto bail;
-		}
-	}
-
-	if (local_lock) {
-		down (&(osb->vol_alloc_sem));
-
-		/* Get the allocation lock here */
-		status = ocfs_acquire_lock (osb, OCFS_BITMAP_LOCK_OFFSET,
-					    OCFS_DLM_EXCLUSIVE_LOCK, 
-					    (in_recovery) ? FLAG_FILE_RECOVERY 
-					    : 0, &bh, local_inode);
-		if (status < 0) {
-			if (status != -EINTR)
-				LOG_ERROR_STATUS (status);
-			goto bail;
-		}
-		got_lock = 1;
-	}
-
-	bitmapblocks = (OCFS_ALIGN(osb->cluster_bitmap.validbits, 
-				   OCFS_BITS_IN_CHUNK) / OCFS_BITS_IN_CHUNK);
-
-	status = ocfs_read_bhs(osb, osb->vol_layout.bitmap_off, 
-			       bitmapblocks * osb->sect_size, 
-			       osb->cluster_bitmap.chunk, 0, NULL);
-	if (status < 0) {
-		LOG_ERROR_STATUS(status);
-		goto bail;
-	}
-
 	if (!(*f)) {
 		*f = ocfs_alloc_bitmap_free_head();
 		if (*f == NULL) {
@@ -3500,23 +3456,6 @@ static int ocfs_sync_local_to_main(ocfs_
 	OCFS_BH_PUT_DATA(local_alloc_bh);
 
 bail:
-	if (local_lock) {
-		up (&(osb->vol_alloc_sem));
-
-		if (got_lock) {
-			tmpstat = ocfs_release_lock (osb, 
-						     OCFS_BITMAP_LOCK_OFFSET,
-						     OCFS_DLM_EXCLUSIVE_LOCK, 
-						     0, bh, local_inode);
-			if (tmpstat < 0)
-				LOG_ERROR_STATUS (tmpstat);
-		}
-		if (bh != NULL)
-			brelse(bh);
-	}
-
-	if (local_inode)
-		iput(local_inode);
 
 	LOG_EXIT_STATUS(status);
 	return(status);
@@ -3997,7 +3936,7 @@ void ocfs_shutdown_local_alloc(ocfs_supe
 	else
 		bh = osb->local_alloc_bh;
 
-	status = ocfs_sync_local_to_main(osb, &f, NULL, NULL, NULL,
+	status = ocfs_sync_local_to_main(osb, &f, bh, NULL, NULL,
 					 in_recovery);
 	if (status < 0)
 		LOG_ERROR_STATUS(status);
