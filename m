From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Mar 17 15:42:21 2004
Subject: [Ocfs2-devel] Crash in ocfs_volume_thread
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC68@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am trying to debug an issue where I get a crash in the
ocfs_volume_thread.

Here is the scenario.

This is all done under a 2.6.x kernel

I have a corrupted partition (I think).  

I created this corrupted partition by:

1. Run mkfs.ocfs2
2. Mount the partition once.  This caused errors.
3. Reboot the system.
4. Try to mount the partition again and then it crashes in the
ocfs_volume_thread.

I get the following errors:

kernel: (17777) ERROR: status = -22, /root/ocfs/new-ocfs2/src/osb.c, 427
kernel: (17777) ERROR: status = -22, /root/ocfs/new-ocfs2/src/super.c,
1063

Then the crash occurs because I have a NULL pointer in line 670 of io.c
which seems to be called by ocfs_volume_thread.

The NULL pointer is in bh->b_bdev.  This being NULL causes a crash to
occur later on when BH_GET_DEVICE(bh) is called and tries to do a
bh->b_bdev->bd_dev.


From looking at the code in super.c it seems like it creates the thread
but when the error occurs it doesn't take care of destroying the
thread(s) that have been created.  Does this interpretation seem
correct.

So should the threads get killed if the mount fails?

Below is snippets of the code to help you find your way.

Thanks,
John



The osb.c code for the error:
        /* If the journal was unmounted cleanly then we don't want to
         * recover anything. Otherwise, journal_load will do that
         * dirty work for us :) */
        if (!mounted) {
--->>>          status = ocfs_journal_wipe(&osb->journal, 0);
                if (status < 0) {
                        LOG_ERROR_STATUS(status);
                        goto finally;
                }

The super.c code for the error:
        /* Read the publish sector for this node and cleanup dirent
being */
        /* modified when we crashed. */
        LOG_TRACE_STR ("ocfs_check_volume...");
        ocfs_down_sem (&(osb->osb_res), true);
-->>    status = ocfs_check_volume (osb);
        ocfs_up_sem (&(osb->osb_res));
        if (status < 0) {
                LOG_ERROR_STATUS (status);
                goto leave;
        }


The io.c code for the error:
        for (i = 0 ; i < nr ; i++) {
                if (bhs[i] == NULL) {
--->>>                  bhs[i] = getblk (dev, blocknum++,
sb->s_blocksize);
                        if (bhs[i] == NULL) {
                                LOG_TRACE_STR("bh == NULL");
                                status = -EIO;
                                LOG_ERROR_STATUS(status);
                                goto bail;
                        }
                }
                bh = bhs[i];
