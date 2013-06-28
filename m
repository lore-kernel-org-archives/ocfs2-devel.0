From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Jun 2013 13:47:49 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmlock_master should return
 DLM_NORMAL after adding lock to blocked list
In-Reply-To: <51C6D054.40100@oracle.com>
References: <51C2E3F1.5020605@huawei.com>
	<51C6D054.40100@oracle.com>
Message-ID: <20130628134749.2058ab52184a7259c2d9379e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, 23 Jun 2013 18:39:16 +0800 Jeff Liu <jeff.liu@oracle.com> wrote:

> Hi Jiufei,
> 
> On 06/20/2013 07:13 PM, Xue jiufei wrote:
> 
> > Function dlmlock_master() returns DLM_RECOVERING/DLM_MIGRATING/
> > DLM_FORWAR after adding lock to blocked list if lockres has the state
> > DLM_LOCK_RES_RECOVERING/DLM_LOCK_RES_MIGRATING/
> > DLM_LOCK_RES_IN_PROGRESS. so it will retry in dlmlock(). And this may
> > cause dlm_thread fall into an infinite loop
> > 
> > 	Thread1                                  dlm_thread
> > calls dlm_lock->dlmlock_master,				     
> > if lockresA is in state
> > DLM_LOCK_RES_RECOVERING, calls
> > __dlm_wait_on_lockres() and waits
> > until others threads clear this
> > state; 
> > 
> > If cannot grant this lock,
> > adding lock to blocked list,
> > and return DLM_RECOVERING;	
> > 
> >                                         Grant this lock and move it to
> >                                         grant list;
> > 
> > After a while, retry and 
> > calls list_add_tail(), adding lock
> > to blocked list again. 
> > 
> > Granted and blocked list of this lockres will become the following
> > conditions:
> >     lock_res->granted.next = dlm_lock->list_head;
> >     lock_res->blocked.next = dlm_lock->list_head;
> >     dlm_lock->list_head.next = dlm_lock_resource->blocked;
> > When dlm_thread traverses the granted list, it will fall into an
> > endless loop, checking dlm_lock.list_head, dlm_lock->list_head.next
> > (i.e.lock_res->blocked), lock_res->blocked.next(i.e.dlm_lock.list_head
> > again) .....
> 
> Thanks for your nice description of this problem and this fix looks good.
> Let's waiting for an ACK from either Sunil, Mark or Joel.

Still waiting ;)


From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: dlmlock_master() should return DLM_NORMAL after adding lock to blocked list

dlmlock_master() returns DLM_RECOVERING/DLM_MIGRATING/ DLM_FORWAR after
adding lock to blocked list if lockres has the state
DLM_LOCK_RES_RECOVERING/DLM_LOCK_RES_MIGRATING/ DLM_LOCK_RES_IN_PROGRESS. 
so it will retry in dlmlock().  And this may cause dlm_thread fall into an
infinite loop

	Thread1                                  dlm_thread
calls dlm_lock->dlmlock_master,
if lockresA is in state
DLM_LOCK_RES_RECOVERING, calls
__dlm_wait_on_lockres() and waits
until others threads clear this
state;

If cannot grant this lock,
adding lock to blocked list,
and return DLM_RECOVERING;

                                        Grant this lock and move it to
                                        grant list;

After a while, retry and
calls list_add_tail(), adding lock
to blocked list again.

Granted and blocked list of this lockres will become the following
conditions:

    lock_res->granted.next = dlm_lock->list_head;
    lock_res->blocked.next = dlm_lock->list_head;
    dlm_lock->list_head.next = dlm_lock_resource->blocked;

When dlm_thread traverses the granted list, it will fall into an endless
loop, checking dlm_lock.list_head, dlm_lock->list_head.next
(i.e.lock_res->blocked), lock_res->blocked.next(i.e.dlm_lock.list_head
again) .....

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: jensen <shencanquan@huawei.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmlock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmlock.c~ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -178,6 +178,7 @@ static enum dlm_status dlmlock_master(st
 				     lock->ml.node);
 			}
 		} else {
+			status = DLM_NORMAL;
 			dlm_lock_get(lock);
 			list_add_tail(&lock->list, &res->blocked);
 			kick_thread = 1;
_
