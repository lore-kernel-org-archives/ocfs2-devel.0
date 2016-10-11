From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 11 Oct 2016 10:58:10 +0800
Subject: [Ocfs2-devel] [Question] deadlock on chmod when running
 discontigous block group multiple node testing
In-Reply-To: <66f1a48d-21e2-aeed-5d79-2ad2576760f5@suse.com>
References: <66f1a48d-21e2-aeed-5d79-2ad2576760f5@suse.com>
Message-ID: <a753e9d1-2f32-7675-7e22-1a4fdc8746a3@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

On 10/11/2016 10:42 AM, Eric Ren wrote:
> Hi Junxiao,
> 
> As the subject, the testing hung there on a kernel without your patches:
> 
> "ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang"
> and
> "ocfs2: fix posix_acl_create deadlock"
> 
> The stack trace is:
> ```
> ocfs2cts1:~ # pstree -pl 24133
> discontig_runne(24133)???activate_discon(21156)???mpirun(15146)???fillup_contig_b(15149)???sudo(15231)???chmod(15232)
> 
> ocfs2cts1:~ # pgrep -a chmod
> 15232 /bin/chmod -R 777 /mnt/ocfs2
> 
> ocfs2cts1:~ # cat /proc/15232/stack
> [<ffffffffa05377ef>] __ocfs2_cluster_lock.isra.39+0x1bf/0x620 [ocfs2]
> [<ffffffffa053856d>] ocfs2_inode_lock_full_nested+0x12d/0x840 [ocfs2]
> [<ffffffffa0538dbb>] ocfs2_inode_lock_atime+0xcb/0x170 [ocfs2]
> [<ffffffffa0531e61>] ocfs2_readdir+0x41/0x1b0 [ocfs2]
> [<ffffffff8120d03c>] iterate_dir+0x9c/0x110
> [<ffffffff8120d453>] SyS_getdents+0x83/0xf0
> [<ffffffff815e126e>] entry_SYSCALL_64_fastpath+0x12/0x6d
> [<ffffffffffffffff>] 0xffffffffffffffff
> ```
> 
> Do you think this issue can be fixed by your patches?
Looks not. Those two patches are to fix recursive locking deadlock. But
from above call trace, there is no recursive lock.

Thanks,
Junxiao.
> 
> I will try your patches later, but I am little worried the possibility
> of reproduction may not be 100%.
> So ask you to confirm;-)
> 
> Eric
