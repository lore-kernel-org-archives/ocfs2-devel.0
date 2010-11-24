From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 23 Nov 2010 16:40:44 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Migrate lockres with no
 locks if it has a reference
In-Reply-To: <20101122081737.GC3326@laptop.jp.oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
	<1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
	<20101122081737.GC3326@laptop.jp.oracle.com>
Message-ID: <4CEC5F0C.9040001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/22/2010 12:17 AM, Wengang Wang wrote:
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

Is this related to the bug we were discussing yesterday? If so, then
the flush_workqueue() is a better solution, IMO.
