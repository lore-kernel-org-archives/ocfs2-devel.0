From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Nov 2010 16:23:34 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Migrate lockres with no
 locks if it has a reference
In-Reply-To: <20101122081737.GC3326@laptop.jp.oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
	<1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
	<20101122081737.GC3326@laptop.jp.oracle.com>
Message-ID: <20101122082334.GE3326@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-22 16:17, Wengang Wang wrote:
> On 10-11-19 15:06, Sunil Mushran wrote:
> > o2dlm was not migrating resources with zero locks because it assumed that that
> > resource would get purged by dlm_thread. However, some usage patterns involve
> > creating and dropping locks at a high rate leading to the migrate thread seeing
> > zero locks but the purge thread seeing an active reference. When this happens,
> > the dlm_thread cannot purge the resource and the migrate thread sees no reason
> > to migrate that resource. The spell is broken when the migrate thread catches
> > the resource with a lock.
> 
> I think we can consider MIGRATING as BUSY(DLM_FORWARD) and the creating thread
> should retry in case the owner has changed after the migration.
> 
> code it as something like this:
> 
> static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm, ...
> {
> 	...
> 	spin_lock(&res->spinlock);
> 	__dlm_wait_on_lockres(res);
> 	if (unlikely(res->owner != dlm->node_num)) {
> 		spin_unlock(&res->spinlock);
> 		return DLM_FORWARD;
> 	}
> 	...
> }
> 
> And if it's from a handler path, just return the DLM_FORWARD; Otherwise
> retry in dlmlock(), (goto retry_lock).
> 
> The above should be taken care in my patch "check lockres owner in handler path",
> not for only handler path but also the "local create" path. But seems I
> missed it.
> 
> regards,
> wengang.
> > 
> > The fix is to make the migrate thread also consider the reference map.
> > 
> > This usage pattern can be triggered by userspace on userdlm locks and flocks.

Sunil,
if you have the testcase, I am glad to testout if my thought works.

regards,
wengang.
