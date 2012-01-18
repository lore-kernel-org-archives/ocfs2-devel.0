From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 18 Jan 2012 10:21:59 -0800
Subject: [Ocfs2-devel] Question about incorrect free bits setting
In-Reply-To: <CAJtY7HWnYqX=CeU+G7YRGRwrANaZ5itRiu13J+HkLA+zQ6FmCQ@mail.gmail.com>
References: <CAJtY7HWnYqX=CeU+G7YRGRwrANaZ5itRiu13J+HkLA+zQ6FmCQ@mail.gmail.com>
Message-ID: <4F170DC7.3060608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We've seen this too. The problem happens because of the patch added to delay
dropping of the dentry locks (first patch below). The other two are related.
It was added to avoid a deadlock in quotas but adds problems of its own.
Srini has studied this issue and may be able to expand on this. The quick
and dirty solution is to back out these patches and ask users to disable
quotas for now. The longer term solution is to fix the quotas issue in a different
way... or redo deletes completely.

commit ea455f8ab68338ba69f5d3362b342c115bea8e13
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jan 12 23:20:31 2009 +0100

     ocfs2: Push out dropping of dentry lock to ocfs2_wq

     Dropping of last reference to dentry lock is a complicated operation involving
     dropping of reference to inode. This can get complicated and quota code in
     particular needs to obtain some quota locks which leads to potential deadlock.
     Thus we defer dropping of inode reference to ocfs2_wq.

     Signed-off-by: Jan Kara <jack@suse.cz>
     Signed-off-by: Mark Fasheh <mfasheh@suse.com>

commit 5fd131893793567c361ae64cbeb28a2a753bbe35
Author: Jan Kara <jack@suse.cz>
Date:   Thu Jul 30 17:01:53 2009 +0200

     ocfs2: Don't oops in ocfs2_kill_sb on a failed mount

     If we fail to mount the filesystem, we have to be careful not to dereference
     uninitialized structures in ocfs2_kill_sb.

     Signed-off-by: Jan Kara <jack@suse.cz>
     Signed-off-by: Joel Becker <joel.becker@oracle.com>

commit f7b1aa69be138ad9d7d3f31fa56f4c9407f56b6a
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jul 20 12:12:36 2009 +0200

     ocfs2: Fix deadlock on umount

     In commit ea455f8ab68338ba69f5d3362b342c115bea8e13, we moved the dentry lock
     put process into ocfs2_wq. This causes problems during umount because ocfs2_wq
     can drop references to inodes while they are being invalidated by
     invalidate_inodes() causing all sorts of nasty things (invalidate_inodes()
     ending in an infinite loop, "Busy inodes after umount" messages etc.).

     We fix the problem by stopping ocfs2_wq from doing any further releasing of
     inode references on the superblock being unmounted, wait until it finishes
     the current round of releasing and finally cleaning up all the references in
     dentry_lock_list from ocfs2_put_super().

     The issue was tracked down by Tao Ma <tao.ma@oracle.com>.

     Signed-off-by: Jan Kara <jack@suse.cz>
     Signed-off-by: Joel Becker <joel.becker@oracle.com>



On 01/18/2012 10:00 AM, Goldwyn Rodrigues wrote:
> We have a customer who was running into read-only filesystem because
> of incorrect free bits set/calculation. We have provided the fix from
> here, which avoids the read-only problem
> http://oss.oracle.com/pipermail/ocfs2-devel/2011-November/008431.html
>
> Though the filesystem is does not turn read-only, we still get messages like -
>
> [ 5017.452846] (ocfs2_wq,8480,0):ocfs2_block_group_clear_bits:2113
> ERROR: Trying to clear 1 bits at offset 7658 in group descriptor #
> 7644672 (device cciss/c0d0p3), needed to clear 0 bits
>
> We are investigating how the bits get free in the first place because
> another allocation could claim the bits marked as free.
>
> The question is:
>
> Why does ocfs2_release_clusters has ocfs2_clear_bit as the undo
> function wheras ocfs2_free_clusters has ocfs2_set_bit as the undo
> function? Should it be NULL for ocfs2_release_clusters?
>
