From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 10 May 2016 12:59:08 +0800
Subject: [Ocfs2-devel] Reflink hangs with kernel 4.4
In-Reply-To: <CAAcuexBFPZ=dTgORi_nHXTgRsEHk2ZTrTHLpzN+eFTneOtiiSw@mail.gmail.com>
References: <CAAcuexBFPZ=dTgORi_nHXTgRsEHk2ZTrTHLpzN+eFTneOtiiSw@mail.gmail.com>
Message-ID: <57316A9C.8050700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tiger,

Only those two process reported call trace from the two nodes? If so,
looks a little different from my hung where it is a recursive locking of
cluster lock. Any way, i just post the fixed to my issue to the mail
list, you can have a try.

Thanks,
Junxiao.

On 05/09/2016 09:20 PM, ??? wrote:
> Hi all.
> 
>  I built up ocfs2 on drbd dual primary. 
> Each node has 12 disks of Raid 10 with mdadm chuck size 4096k.
> Cluster size of filesystem is 1048576 bytes.
> 
> Main purpose of use is reflink files on drbd.
> 
> I reflinked files from 1TB file and exported them to LIO iscsi.
> 
> After few days tests, i got kernel error.
> 
> 
> 
> May  4 19:29:38 master kernel: [1283940.130689]
> (reflink,30902,0):ocfs2_check_dir_for_entry:2048 ERROR: status = -17
> May  4 19:29:38 master kernel: [1283940.131122]
> (reflink,30902,0):ocfs2_mv_orphaned_inode_to_new:2917 ERROR: status = -17
> May  4 19:29:38 master kernel: [1283940.131533]
> (reflink,30902,0):ocfs2_reflink:4317 ERROR: status = -17
> May  4 21:15:29 master kernel: [1290290.387752] INFO: task reflink:5954
> blocked for more than 120 seconds.
> May  4 21:15:29 master kernel: [1290290.388093]       Not tainted
> 4.4.7-040407-generic #201604121331
> May  4 21:15:29 master kernel: [1290290.388417] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May  4 21:15:29 master kernel: [1290290.388784] reflink         D
> ffff880037e83cf8     0  5954  25468 0x00000000
> May  4 21:15:29 master kernel: [1290290.388788]  ffff880037e83cf8
> ffff8800b80e6000 ffff8802156ae040 ffff88000195d280
> May  4 21:15:29 master kernel: [1290290.388790]  ffff880037e84000
> ffff8801af84f1dc ffff88000195d280 00000000ffffffff
> May  4 21:15:29 master kernel: [1290290.388792]  ffff8801af84f1e0
> ffff880037e83d10 ffffffff817fdf35 ffff8801af84f1d8
> May  4 21:15:29 master kernel: [1290290.388793] Call Trace:
> May  4 21:15:29 master kernel: [1290290.388798]  [<ffffffff817fdf35>]
> schedule+0x35/0x80
> May  4 21:15:29 master kernel: [1290290.388800]  [<ffffffff817fe1de>]
> schedule_preempt_disabled+0xe/0x10
> May  4 21:15:29 master kernel: [1290290.388802]  [<ffffffff817ffe19>]
> __mutex_lock_slowpath+0xb9/0x130
> May  4 21:15:29 master kernel: [1290290.388803]  [<ffffffff817ffeaf>]
> mutex_lock+0x1f/0x30
> May  4 21:15:29 master kernel: [1290290.388832]  [<ffffffffc0a02668>]
> ocfs2_reflink_ioctl+0x218/0x360 [ocfs2]
> May  4 21:15:29 master kernel: [1290290.388848]  [<ffffffffc09e634e>]
> ocfs2_ioctl+0x26e/0x660 [ocfs2]
> May  4 21:15:29 master kernel: [1290290.388851]  [<ffffffff8121aa68>]
> do_vfs_ioctl+0x298/0x480
> May  4 21:15:29 master kernel: [1290290.388853]  [<ffffffff812167a4>] ?
> putname+0x54/0x60
> May  4 21:15:29 master kernel: [1290290.388854]  [<ffffffff812066bf>] ?
> do_sys_open+0x1af/0x230
> May  4 21:15:29 master kernel: [1290290.388856]  [<ffffffff8121acc9>]
> SyS_ioctl+0x79/0x90
> May  4 21:15:29 master kernel: [1290290.388858]  [<ffffffff81802036>]
> entry_SYSCALL_64_fastpath+0x16/0x75
> May  4 21:15:29 master kernel: [1290290.388860] INFO: task reflink:6466
> blocked for more than 120 seconds.
> May  4 21:15:29 master kernel: [1290290.389236]       Not tainted
> 4.4.7-040407-generic #201604121331
> May  4 21:15:29 master kernel: [1290290.389611] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May  4 21:15:29 master kernel: [1290290.389998] reflink         D
> ffff880038f87cf8     0  6466  32643 0x00000000
> May  4 21:15:29 master kernel: [1290290.390000]  ffff880038f87cf8
> ffff8800b80e6000 ffff880215542940 ffff880002508dc0
> May  4 21:15:29 master kernel: [1290290.390002]  ffff880038f88000
> ffff8801af84f1dc ffff880002508dc0 00000000ffffffff
> May  4 21:15:29 master kernel: [1290290.390004]  ffff8801af84f1e0
> ffff880038f87d10 ffffffff817fdf35 ffff8801af84f1d8
> May  4 21:15:29 master kernel: [1290290.390005] Call Trace:
> May  4 21:15:29 master kernel: [1290290.390008]  [<ffffffff817fdf35>]
> schedule+0x35/0x80
> May  4 21:15:29 master kernel: [1290290.390009]  [<ffffffff817fe1de>]
> schedule_preempt_disabled+0xe/0x10
> May  4 21:15:29 master kernel: [1290290.390010]  [<ffffffff817ffe19>]
> __mutex_lock_slowpath+0xb9/0x130
> May  4 21:15:29 master kernel: [1290290.390012]  [<ffffffff817ffeaf>]
> mutex_lock+0x1f/0x30
> May  4 21:15:29 master kernel: [1290290.390031]  [<ffffffffc0a02668>]
> ocfs2_reflink_ioctl+0x218/0x360 [ocfs2]
> May  4 21:15:29 master kernel: [1290290.390045]  [<ffffffffc09e634e>]
> ocfs2_ioctl+0x26e/0x660 [ocfs2]
> May  4 21:15:29 master kernel: [1290290.390048]  [<ffffffff8121aa68>]
> do_vfs_ioctl+0x298/0x480
> May  4 21:15:29 master kernel: [1290290.390049]  [<ffffffff812167a4>] ?
> putname+0x54/0x60
> May  4 21:15:29 master kernel: [1290290.390051]  [<ffffffff812066bf>] ?
> do_sys_open+0x1af/0x230
> May  4 21:15:29 master kernel: [1290290.390052]  [<ffffffff8121acc9>]
> SyS_ioctl+0x79/0x90
> May  4 21:15:29 master kernel: [1290290.390054]  [<ffffffff81802036>]
> entry_SYSCALL_64_fastpath+0x16/0x75
> 
> 
>  I saw same report with kernel 4.3 but there was no answer.
> Any ideas?
> 
>  
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
