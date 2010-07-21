From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 21 Jul 2010 20:22:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: correct the refmap on recovery
 master
In-Reply-To: <4C46242D.3060305@oracle.com>
References: <201006101628.o5A0YmQN005612@rcsinet15.oracle.com>
	<20100719100959.GB3623@laptop.jp.oracle.com>
	<4C44E52B.6060704@oracle.com>
	<20100720025948.GB2936@laptop.cn.oracle.com>
	<4C46242D.3060305@oracle.com>
Message-ID: <20100721122202.GA3291@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-20 15:33, Sunil Mushran wrote:
> On 07/19/2010 07:59 PM, Wengang Wang wrote:
> >>Do you have the message sequencing that would lead to this situation?
> >>If we migrate the lockres to the reco master, the reco master will send
> >>an assert that will make us change the master.
> >So first, the problem is not about the changing owner. It is that
> >the bit(in refmap) on behalf of the node in question is not cleared on the new
> >master(recovery master). So that the new master will fail at purging the lockres
> >due to the incorrect bit in refmap.
> >
> >Second, I have no messages at hand for the situation. But I think it is simple
> >enough.
> >
> >1) node A has no interest on lockres A any longer, so it is purging it.
> >2) the owner of lockres A is node B, so node A is sending de-ref message
> >to node B.
> >3) at this time, node B crashed. node C becomes the recovery master. it recovers
> >lockres A(because the master is the dead node B).
> >4) node A migrated lockres A to node C with a refbit there.
> >5) node A failed to send de-ref message to node B because it crashed. The failure
> >is ignored. no other action is done for lockres A any more.
> 
> In dlm_do_local_recovery_cleanup(), we expicitly clear the flag...
> when the owner is the dead_node. So this should not happen.

It reproduces in my test env.

Clearing the flag DLM_LOCK_RES_DROPPING_REF doesn't prevent anything.

dlm_do_local_recovery_cleanup() continue to move the lockres to recovery
list.

2337                                 /* the wake_up for this will happen when the
2338                                  * RECOVERING flag is dropped later */
2339                                 res->state &= ~DLM_LOCK_RES_DROPPING_REF;
2340 
2341				     dlm_move_lockres_to_recovery_list(dlm, res);


and dlm_purge_lockres() continue to unhash the lockres.

202                 ret = dlm_drop_lockres_ref(dlm, res);
203                 if (ret < 0) {
204                         mlog_errno(ret);
205                         if (!dlm_is_host_down(ret))
206                                 BUG();
207                 }
208                 mlog(0, "%s:%.*s: dlm_deref_lockres returned %d\n",
209                      dlm->name, res->lockname.len, res->lockname.name, ret);
210                 spin_lock(&dlm->spinlock);
211         }
212 
213         spin_lock(&res->spinlock);
214         if (!list_empty(&res->purge)) {
215                 mlog(0, "removing lockres %.*s:%p from purgelist, "
216                      "master = %d\n", res->lockname.len, res->lockname.name,
217                      res, master);
218                 list_del_init(&res->purge);
219                 spin_unlock(&res->spinlock);
220                 dlm_lockres_put(res);
221                 dlm->purge_count--;
222         } else
223                 spin_unlock(&res->spinlock);
224 
225         __dlm_unhash_lockres(res);


> Your patch changes the logic to exclude such lockres' from the
> recovery list. And that's a change, while possibly workable, needs
> to be looked into more thoroughly.
> 
> In short, there is a disconnect between your description and your patch.
> Or, my understanding.

For mormal, we recover the lockres to recovery master, and then re-send the deref
message to it. That my privious patches do.

After discussing with Srini, we found ignoring the failure of deref to the original
master and not recovering the lockres to recovery master has the same effect. And
it's simpler.

The patch fixes the bug per my test result.

regards,
wengang.
