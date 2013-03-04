From: Tejun Heo <tj@kernel.org>
Date: Mon, 04 Mar 2013 18:56:53 -0000
Subject: [Ocfs2-devel] [Ocfs2-users] [OCFS2] Crash at o2net_shutdown_sc()
In-Reply-To: <CAFLxGvw0mzPPrKv9GxKMwJr5vUy14ZAXKFfhCf0HDwE7-FQ7vQ@mail.gmail.com>
References: <CAFLxGvzUqQhbxpp4jAGW68-7GCc6jw8b4BFU7p_5H1utFxdkQQ@mail.gmail.com>
	<513120AF.5030501@oracle.com>
	<CAFLxGvw0mzPPrKv9GxKMwJr5vUy14ZAXKFfhCf0HDwE7-FQ7vQ@mail.gmail.com>
Message-ID: <20130304185645.GK30413@htj.dyndns.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-users@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org

Hello,

On Sat, Mar 02, 2013 at 09:41:54AM +0100, richard -rw- weinberger wrote:
> On Fri, Mar 1, 2013 at 10:42 PM, Srinivas Eeda <srinivas.eeda@oracle.com> wrote:
> > Yes that was the crash I was referring to which stopped me from testing my
> > other patch on mainline. I think the crashes started since some workqueue
> > patches introduced by commit  57b30ae77bf00d2318df711ef9a4d2a9be0a3a2a
> > Earlier kernels should be fine.
> >
> > Patch https://lkml.org/lkml/2012/10/18/592 tried to address one fix which
> > helped ramster that uses same ocfs2/o2net code. There still seems to be
> > another problem that crashes ocfs2.
> 
> If commit 57b30ae (workqueue: reimplement cancel_delayed_work() using
> try_to_grab_pending())
> introduced that regression, it is time to CC Tejun.

Hmmm.....

> >> [ 1514.840690] BUG: unable to handle kernel NULL pointer dereference
> >> at 0000000000000028
> >> [ 1514.841627] IP: [<ffffffff816ce840>] kernel_sock_ioctl+0x50/0x50

I suppose it's because either sock->ops or sock->ops->ioctl is NULL?
Can someone teach me what could lead to such conditions here and how
it could be affected by cancel_delayed_work()?

> >> [ 1514.841627] Call Trace:
> >> [ 1514.841627]  [<ffffffff81323776>] ? o2net_shutdown_sc+0x106/0x1e0

I suppose this is the work function?  Wondering why '?' is there tho.

> >> [ 1514.841627]  [<ffffffff810013fa>] ? __switch_to+0x2a/0x4a0
> >> [ 1514.841627]  [<ffffffff818a5c22>] ? _raw_spin_unlock_irq+0x12/0x40
> >> [ 1514.841627]  [<ffffffff81069d26>] ? finish_task_switch+0x56/0xc0
> >> [ 1514.841627]  [<ffffffff81056eb3>] process_one_work+0x133/0x510
> >> [ 1514.841627]  [<ffffffff81323670>] ?
> >> o2net_sc_connect_completed+0xf0/0xf0
> >> [ 1514.841627]  [<ffffffff810585ed>] worker_thread+0x15d/0x450
> >> [ 1514.841627]  [<ffffffff81058490>] ? busy_worker_rebind_fn+0x100/0x100
> >> [ 1514.841627]  [<ffffffff8105e10b>] kthread+0xbb/0xc0
> >> [ 1514.841627]  [<ffffffff818a0000>] ? e1000_regdump+0x262/0x3be
> >> [ 1514.841627]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130
> >> [ 1514.841627]  [<ffffffff818accac>] ret_from_fork+0x7c/0xb0
> >> [ 1514.841627]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130

Thanks.

-- 
tejun
