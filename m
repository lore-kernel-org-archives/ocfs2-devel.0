From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:03:56 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
 list_for_each_entry loop cursor
In-Reply-To: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
Message-ID: <20100812000355.GA7195@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>

On Sat, Aug 07, 2010 at 11:09:13AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> list_for_each_entry uses its first argument to move from one element to the
> next, so modifying it can break the iteration.

	Thanks for catching the bug.  It was introduced by 800deef3
[ocfs2: use list_for_each_entry where benefical].  I blame Christoph.

> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 9dfaac7..7084a11 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1792,10 +1792,10 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>  			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
>  				tmpq = dlm_list_idx_to_ptr(res, j);
>  				list_for_each_entry(lock, tmpq, list) {
> -					if (lock->ml.cookie != ml->cookie)
> +					if (lock->ml.cookie != ml->cookie) {
>  						lock = NULL;
> -					else
>  						break;
> +					}
>  				}
>  				if (lock)
>  					break;

	However, this is not the correct solution.  The goal of the
original code, which used to use list_for_each(), was to leave lock
non-NULL if the cookie was found.  Your version merely exits the loop on
the first non-matching entry, always leaving lock==NULL if there is a
non-matching entry.
	One possible solution is to return the original code:

--8<-----------------------------------------------------------------
@@ -1747,7 +1747,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue;
+	struct list_head *queue, *iter;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
@@ -1791,11 +1791,12 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each_entry(lock, tmpq, list) {
-					if (lock->ml.cookie != ml->cookie)
-						lock = NULL;
-					else
+				list_for_each(iter, tmpq) {
+					lock = list_entry(iter, struct dlm_lock, list);
+
+					if (lock->ml.cookie == ml->cookie)
 						break;
+					lock = NULL;
 				}
 				if (lock)
 					break;
-->8-----------------------------------------------------------------

	Another approach would be to keep list_for_each_entry() around,
but use a better check for entry existence:

--8<-----------------------------------------------------------------
@@ -1792,13 +1792,12 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
 				list_for_each_entry(lock, tmpq, list) {
-					if (lock->ml.cookie != ml->cookie)
-						lock = NULL;
-					else
+					if (lock->ml.cookie == ml->cookie)
 						break;
 				}
-				if (lock)
+				if (&lock->list != tmpq)
 					break;
+				lock = NULL;
 			}
 
 			/* lock is always created locally first, and
-->8-----------------------------------------------------------------

	I think I like the second one better.  Sunil, what do you think?

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
