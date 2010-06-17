From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 17 Jun 2010 19:05:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <4C19E28F.2030006@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<20100616060615.GB2895@laptop.us.oracle.com>
	<4C19E28F.2030006@oracle.com>
Message-ID: <20100617110548.GA3178@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-17 01:53, Srinivas Eeda wrote:
> On 6/15/2010 11:06 PM, Wengang Wang wrote:
> >still the question.
> >If you have sent DEREF request to the master, and the lockres became in-use
> >again, then the lockres remains in the hash table and also in the purge list.
> >So
> Yes, that's a possibility. But there is not much we could do to
> cover that window other than making the non master nodes to avoid
> such races. Patch 2/2 fixes one such race.

Yes, we should make non master nodes to avoid such races. But you only
fixed one of such races by patch 2/2 :).
And probably we can't make sure how many such races there. A know case is
dlm_mig_lockres_handler(). We dropped dlm->spinlock and res->spinlock after
dlm_lookup_lockres(). Here it can be set DROPPING_REF state in dlm_thread().
dlm_thread() then drop the spinlocks and set deref msg. Before dlm_thread()
take the spinlocks back, dlm_mig_lockres_handler() continues, A lock(s) is
added to the lockres. The lockres became in use then. dlm_thread() take
back the spinlocks, found the lockres is in use, keep it in hashtable and in
purge list.

Your patch 2/2 fixes that problem well.
So far I have no good idea to fix all such potential races..

regards,
wengang.

> >1) If this node is the last ref, there is a possibility that the master
> >purged the lockres after receiving DEREF request from this node. In this
> >case, when this node does dlmlock_remote(), the lockres won't be found on the
> >master. How to deal with it?
> patch 2/2 fixes this race. dlm_get_lock_resource will either wait
> for the lockres to get purged and starts everything fresh or marks
> the lockres in use so dlm_thread won't purge it.
> >2) The lockres on this node is going to be purged again, it means it will send
> >secondary DEREFs to the master. This is not good I think.
> right, not a good idea to send deref again. We have to fix those cases.
> >A thought is setting lockres->owner to DLM_LOCK_RES_OWNER_UNKNOWN after
> >sending a DEREF request againt this lockres. Also redo master reqeust
> >before locking on it.
> if you are referring to the hole in dlmlock_remote, patch 2/2 fixes
> it. Please review that patch and let me know :)
> >Regards,
> >wengang.
