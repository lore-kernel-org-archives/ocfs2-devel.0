From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 28 Mar 2014 14:35:00 +0800
Subject: [Ocfs2-devel] [PATCH] [ocfs2]: pass "new" parameter to
	ocfs2_init_xattr_bucket
Message-ID: <1395988500-22847-1-git-send-email-wen.gang.wang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes the following crash:

[71379.310340] kernel BUG at fs/ocfs2/uptodate.c:530!
[71379.310340] invalid opcode: 0000 [#1] SMP
[71379.310340] Modules linked in: ocfs2(F) ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bridge xen_pciback xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn xenfs xen_privcmd sunrpc 8021q garp stp llc bonding be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi iTCO_wdt iTCO_vendor_support dcdbas coretemp freq_table mperf microcode pcspkr serio_raw bnx2 lpc_ich mfd_core i5k_amb i5000_edac edac_core e1000e sg shpchp ext4(F) jbd2(F) mbcache(F) dm_round_robin(F) sr_mod(F) cdrom(F) usb_storage(F) sd_mod(F) crc_t10dif(F) pata_acpi(F) ata_generic(F) ata_piix(F) mptsas(F) mptscsih(F) mptbase(F) scsi_transport_sas(F) radeon(F)
[71379.310340]  ttm(F) drm_kms_helper(F) drm(F) hwmon(F) i2c_algo_bit(F) i2c_core(F) dm_multipath(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F)
[71379.310340] CPU 5
[71379.310340] Pid: 21303, comm: xattr-test Tainted: GF       W    3.8.13-30.el6uek.x86_64 #2 Dell Inc. PowerEdge 1950/0M788G
[71379.310340] RIP: e030:[<ffffffffa074b451>]  [<ffffffffa074b451>] ocfs2_set_new_buffer_uptodate+0x51/0x60 [ocfs2]
[71379.310340] RSP: e02b:ffff880017acb7a8  EFLAGS: 00010202
[71379.310340] RAX: 0000000000000001 RBX: ffff880038f30478 RCX: ffff8800072f0748
[71379.310340] RDX: 0000000000146326 RSI: ffff8800072f0748 RDI: ffff880038f3041c
[71379.310340] RBP: ffff880017acb7b8 R08: 0000000000000004 R09: ffffea000041d69c
[71379.310340] R10: 000000000000330a R11: 0000000000000000 R12: ffff8800072f0748
[71379.310340] R13: 0000000000146326 R14: 0000000000000000 R15: ffff88001892ea40
[71379.310340] FS:  00007f1922ffc700(0000) GS:ffff880039940000(0000) knlGS:0000000000000000
[71379.310340] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[71379.310340] CR2: ffffffffff600400 CR3: 00000000026c3000 CR4: 0000000000002660
[71379.310340] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[71379.310340] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[71379.310340] Process xattr-test (pid: 21303, threadinfo ffff880017aca000, task ffff880016a2c480)
[71379.310340] Stack:
[71379.310340]  ffff88001892ea40 ffff88001892ea40 ffff880017acb7f8 ffffffffa075950a
[71379.310340]  ffff880038f304c0 ffff880038f304c0 0000000000000000 0000000000146326
[71379.310340]  ffff880017ffc240 0000000000000000 ffff880017acb858 ffffffffa075965b
[71379.310340] Call Trace:
[71379.310340]  [<ffffffffa075950a>] ocfs2_init_xattr_bucket+0x8a/0x120 [ocfs2]
[71379.310340]  [<ffffffffa075965b>] ocfs2_cp_xattr_bucket+0xbb/0x1b0 [ocfs2]
[71379.310340]  [<ffffffffa075a73a>] ocfs2_extend_xattr_bucket+0x20a/0x2f0 [ocfs2]
[71379.310340]  [<ffffffffa075f87e>] ocfs2_add_new_xattr_bucket+0x23e/0x4b0 [ocfs2]
[71379.310340]  [<ffffffffa075dc3f>] ? ocfs2_xattr_set_entry_bucket+0x1af/0x2d0 [ocfs2]
[71379.310340]  [<ffffffffa024e934>] ? jbd2_journal_dirty_metadata+0xf4/0x250 [jbd2]
[71379.310340]  [<ffffffffa075fc2c>] ocfs2_xattr_set_entry_index_block+0x13c/0x3d0 [ocfs2]
[71379.310340]  [<ffffffffa0752f72>] ? ocfs2_xa_block_journal_dirty+0x12/0x20 [ocfs2]
[71379.310340]  [<ffffffffa075ffb9>] ocfs2_xattr_block_set+0xf9/0x220 [ocfs2]
[71379.310340]  [<ffffffffa075d981>] ? ocfs2_xattr_ibody_set+0x1f1/0x300 [ocfs2]
[71379.310340]  [<ffffffffa07627e8>] __ocfs2_xattr_set_handle+0x118/0x710 [ocfs2]
[71379.310340]  [<ffffffffa024fb33>] ? jbd2_journal_start+0x13/0x20 [jbd2]
[71379.310340]  [<ffffffffa0763471>] ocfs2_xattr_set+0x691/0x880 [ocfs2]
[71379.310340]  [<ffffffffa07636a6>] ocfs2_xattr_user_set+0x46/0x50 [ocfs2]
[71379.310340]  [<ffffffff811b4616>] generic_setxattr+0x96/0xa0
[71379.310340]  [<ffffffff811b5b4b>] __vfs_setxattr_noperm+0x7b/0x170
[71379.310340]  [<ffffffff811b5cfc>] vfs_setxattr+0xbc/0xc0
[71379.310340]  [<ffffffff811b5dde>] setxattr+0xde/0x230
[71379.310340]  [<ffffffff811b5ff6>] sys_fsetxattr+0xc6/0xf0
[71379.310340]  [<ffffffff8159d599>] system_call_fastpath+0x16/0x1b
[71379.310340] Code: 41 80 0c 24 01 48 89 df e8 7d f0 ff ff 4c 89 e6 48 89 df e8 a2 fe ff ff 48 89 df e8 3a f0 ff ff 48 8b 1c 24 4c 8b 64 24 08 c9 c3 <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 66 66
[71379.310340] RIP  [<ffffffffa074b451>] ocfs2_set_new_buffer_uptodate+0x51/0x60 [ocfs2]
[71379.310340]  RSP <ffff880017acb7a8>

It hit the BUG_ON() in ocfs2_set_new_buffer_uptodate().

527 void ocfs2_set_new_buffer_uptodate(struct ocfs2_caching_info *ci,
528                                    struct buffer_head *bh)
529 {
530         /* This should definitely *not* exist in our cache */
531         if (ocfs2_buffer_cached(ci, bh))
532                 printk(KERN_ERR "bh->b_blocknr: %lu @ %p\n", bh->b_blocknr, bh);
533         BUG_ON(ocfs2_buffer_cached(ci, bh));
534
535         set_buffer_uptodate(bh);
536
537         ocfs2_metadata_cache_io_lock(ci);
538         ocfs2_set_buffer_uptodate(ci, bh);
539         ocfs2_metadata_cache_io_unlock(ci);
540 }

The problem here is:
We cached a block, but the buffer_head got reused. When we are to pick up this block
again, a new buffer_head created with UPTODATE flag cleared.
ocfs2_buffer_uptodate() returned false since no UPTODATE is set on the buffer_head.
so we set this block to cache as a NEW block, then it failed at asserting block is
not in cache.

The fix is to add a new parameter indicating the bucket is a new allocated or not
to ocfs2_init_xattr_bucket(). ocfs2_init_xattr_bucket() assert block not cached
accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/xattr.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 185fa3b7..45c2574 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -369,7 +369,7 @@ static void ocfs2_xattr_bucket_free(struct ocfs2_xattr_bucket *bucket)
  * them fully.
  */
 static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
-				   u64 xb_blkno)
+				   u64 xb_blkno, int new)
 {
 	int i, rc = 0;
 
@@ -383,9 +383,16 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		}
 
 		if (!ocfs2_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
-					   bucket->bu_bhs[i]))
-			ocfs2_set_new_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
-						      bucket->bu_bhs[i]);
+					   bucket->bu_bhs[i])) {
+			if (new)
+				ocfs2_set_new_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
+							      bucket->bu_bhs[i]);
+			else {
+				set_buffer_uptodate(bucket->bu_bhs[i]);
+				ocfs2_set_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
+							  bucket->bu_bhs[i]);
+			}
+		}
 	}
 
 	if (rc)
@@ -4294,7 +4301,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 
 	trace_ocfs2_xattr_create_index_block((unsigned long long)blkno);
 
-	ret = ocfs2_init_xattr_bucket(xs->bucket, blkno);
+	ret = ocfs2_init_xattr_bucket(xs->bucket, blkno, 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4638,7 +4645,7 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	 * Even if !new_bucket_head, we're overwriting t_bucket.  Thus,
 	 * there's no need to read it.
 	 */
-	ret = ocfs2_init_xattr_bucket(t_bucket, new_blk);
+	ret = ocfs2_init_xattr_bucket(t_bucket, new_blk, new_bucket_head);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4804,7 +4811,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	 * Even if !t_is_new, we're overwriting t_bucket.  Thus,
 	 * there's no need to read it.
 	 */
-	ret = ocfs2_init_xattr_bucket(t_bucket, t_blkno);
+	ret = ocfs2_init_xattr_bucket(t_bucket, t_blkno, t_is_new);
 	if (ret)
 		goto out;
 
@@ -6830,7 +6837,7 @@ static int ocfs2_reflink_xattr_bucket(handle_t *handle,
 			break;
 		}
 
-		ret = ocfs2_init_xattr_bucket(args->new_bucket, new_blkno);
+		ret = ocfs2_init_xattr_bucket(args->new_bucket, new_blkno, 1);
 		if (ret) {
 			mlog_errno(ret);
 			break;
-- 
1.8.3.1
