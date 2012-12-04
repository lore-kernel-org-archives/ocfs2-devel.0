From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Tue, 4 Dec 2012 09:26:10 -0800
Subject: [Ocfs2-devel] [PATCH] mkfs.ocfs2 null pointer dereference. --
	resend
In-Reply-To: <1354591096-8252-1-git-send-email-xiaowei.hu@oracle.com>
References: <1354591096-8252-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <CAEeiSHWcYa4s6s90_99nTRfYx4KjNcbrH7AsgTKH6rf4rJ-APQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK.

hb_task is a local variable that is not even accessed after kthread_stop().
The oops is in kthread_stop(). Points to a problem with get/put in
task_struct.
Not an ocfs2 issue.


On Mon, Dec 3, 2012 at 7:18 PM, <xiaowei.hu@oracle.com> wrote:

> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
>
>  Pid: 4508, comm:
>  mkfs.ocfs2 Not tainted 2.6.39-300.17.1.el5uek.bug14842737
>  #1 Dell Inc. PowerEdge 1950/0M788G RIP:
>  0010:[<ffffffff81098bff>]  [<ffffffff81098bff>]
>  exit_creds+0x1f/0xb0 RSP: 0018:ffff880222b4dd58  EFLAGS:
>  00010292 RAX: 0000000000000000 RBX: ffff88021f394480 RCX:
>  ffff88021f1f2d90 RDX: 0000000000000013 RSI:
>  ffff88021e9c4a00 RDI: 0000000000000000 RBP:
>  ffff880222b4dd68 R08: 0000000000000003 R09:
>  0000000000000020 R10: ffff880222b4dd18 R11:
>  0000000000000001 R12: ffff88021f394480 R13:
>  ffffffffa065ca88 R14: ffff88021e9c4a00 R15:
>  ffff88021e9c4a00 FS:  00007fa5e950c730(0000)
>  GS:ffff88022fcc0000(0000) knlGS:0000000000000000 CS:  0010
>  DS: 0000 ES: 0000 CR0: 0000000080050033 CR2:
>  0000000000000000 CR3: 000000021e166000 CR4:
>  00000000000006e0 DR0: 0000000000000000 DR1:
>  0000000000000000 DR2: 0000000000000000 DR3:
>  0000000000000000 DR6: 00000000ffff0ff0 DR7:
>  0000000000000400 Process mkfs.ocfs2 (pid: 4508, threadinfo
>  ffff880222b4c000, task ffff88022024c4c0) Stack:
>  ffff880222b4dd88 ffff88021f394480 ffff880222b4dd88
>  ffffffff8106e802  ffff88021f394480 0000000000000000
>  ffff880222b4dda8 ffffffff81090c38  ffff88021f394480
>  ffff88021e9c4a00 ffff880222b4dde8 ffffffffa064b78d Call
>  Trace:  [<ffffffff8106e802>] __put_task_struct+0x42/0x100
>  [<ffffffff81090c38>] kthread_stop+0x78/0xd0
>  [<ffffffffa064b78d>]
>  o2hb_heartbeat_group_drop_item+0x6d/0x1d0
>  [ocfs2_nodemanager]  [<ffffffffa0635136>]
>  client_drop_item+0x26/0x40 [configfs]  [<ffffffffa063650e>]
>  configfs_rmdir+0x20e/0x2c0 [configfs]  [<ffffffff81186c08>]
>  ? shrink_dcache_parent+0x38/0x50  [<ffffffff8117b55b>]
>  vfs_rmdir+0xdb/0x130  [<ffffffff8117eb0b>]
>  do_rmdir+0x10b/0x120  [<ffffffff810cf78b>] ?
>  audit_syscall_entry+0x17b/0x1e0  [<ffffffff8117eb76>]
>  sys_rmdir+0x16/0x20  [<ffffffff81510642>]
>  system_call_fastpath+0x16/0x1b Code: 80 00 00 00 00 0f 1f
>  80 00 00 00 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48
>  8b 87 30 06 00 00 48 89 fb 48 8b bf 28 06 00 00 <8b> 00 48
>  c7 83 28 06 00 00 00 00 00 00 f0 ff 0f 0f 94 c0 84 c0 RIP
>  [<ffffffff81098bff>] exit_creds+0x1f/0xb0  RSP
>  <ffff880222b4dd58> CR2: 0000000000000000
>
> ---
>  fs/ocfs2/cluster/heartbeat.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 61561c6..94193ac 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2143,8 +2143,10 @@ static void o2hb_heartbeat_group_drop_item(struct
> config_group *group,
>         reg->hr_item_dropped = 1;
>         spin_unlock(&o2hb_live_lock);
>
> -       if (hb_task)
> +       if (hb_task) {
>                 kthread_stop(hb_task);
> +               hb_task = NULL;
> +       }
>
>         if (o2hb_global_heartbeat_active()) {
>                 spin_lock(&o2hb_live_lock);
> --
> 1.7.7.6
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20121204/7efddd23/attachment.html 
