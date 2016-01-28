From: Gang He <ghe@suse.com>
Date: Wed, 27 Jan 2016 20:02:27 -0700
Subject: [Ocfs2-devel] Ocfs2 test for linux-next-20160122 passed
In-Reply-To: <56A98263.5010208@oracle.com>
References: <56A98263.5010208@oracle.com>
Message-ID: <56A9F543020000F900027826@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Cool, thank for sharing.

Thanks
Gang


>>> 
> This means the following patches have passed ocfs2-test. The first three
> ones are merged by me to avoid that recursive deadlock issue.
> 
> =============================
> 
> -inode deadlock in ocfs2_mknode due to using posix_acl_create
> -posix_acl_create unsuitable to use in ocfs2_reflink
> -revert to using ocfs2_acl_chmod to avoid inode cluster lock hang
> -ocfs2: check/fix inode block for online file check
> -ocfs2: create/remove sysfile for online file check
> -ocfs2: sysfile interfaces for online file check
> -ocfs2: export ocfs2_kset for online file check
> -ocfs2: solve a problem of crossing the boundary in updating backups
> -ocfs2: fix occurring deadlock by changing ocfs2_wq from global to local
> -ocfs2: extend enough credits for freeing one truncate record while
> replaying truncate records
> -ocfs2: extend transaction for ocfs2_remove_rightmost_path() and
> ocfs2_update_edge_lengths() before to avoid inconsistency between inode
> and et
> -ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list
> -ocfs2-dlm-fix-race-between-convert-and-recovery-v3
> -ocfs2-dlm-fix-race-between-convert-and-recovery-v2
> -ocfs2/dlm: fix race between convert and recovery
> -ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()
> -ocfs2: fix disk file size and memory file size mismatch
> -ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write
> -ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
> -ocfs2: fix ip_unaligned_aio deadlock with dio work queue
> -ocfs2: code clean up for direct io
> -ocfs2: fix sparse file & data ordering issue in direct io
> -ocfs2: record UNWRITTEN extents when populate write desc
> -ocfs2: return the physical address in ocfs2_write_cluster
> -ocfs2: do not change i_size in write_end for direct io
> -ocfs2: test target page before change it
> -ocfs2: use c_new to indicate newly allocated extents
> -ocfs2: add ocfs2_write_type_t type to identify the caller of write
> -ocfs2: NFS hangs in __ocfs2_cluster_lock due to race with
> ocfs2_unblock_lock
> 
> ==================================
> 
> Thanks,
> Junxiao.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
