From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 25 May 2010 10:01:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: resend deref to new master
 if recovery occures
In-Reply-To: <4BFAD7F4.3000705@oracle.com>
References: <4BFAD7F4.3000705@oracle.com>
Message-ID: <20100525020114.GA9173@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-05-24 12:48, Srinivas Eeda wrote:
> thanks for doing this patch. I have a little comment, wondering if
> there could be a window where node B sent the lock info to node C as
> part of recovery and removed flag DLM_LOCK_RES_RECOVERING while
> dlm_thread was still purging it. In that case dlm_thread will still
> continue to remove it from hash list.

Yes, you are right. There do is such a window. I missed that.

> 
> Also, this patch puts dlm_thread to sleep ... may be it's ok, but
> wondering if we can avoid that.

Yes. I considered about that too but failed at finding a simple way to avoid
that.

> delay deref message if DLM_LOCK_RES_RECOVERING is set (which means
> recovery got to the lockres before dlm_thread could), move the
> lockres to the end of the purgelist and retry later.

Good point! I meant that but the patch deosn't prove that :P.

> do not inform recovery master if DLM_LOCK_RES_DROPPING_REF is set
> (which means dlm_thread got to the lockres before recovery). So in
> the case you described, node C will not know about node B dropping
> the dereference and node B will just go ahead and remove it from
> hash list and free it.

Cool idea! let me try and re-create the patch!

thanks much Srini.
wengang.

> Wengang Wang wrote:
> >When purge a lockres, we unhash the lockres ignore the result of deref request
> >and ignore the lockres state.
> >There is a problem that rarely happen. It can happen when recovery take places.
> >Say node A is the master of the lockres with node B wants to deref and there is
> >a node C. If things happen in the following order, the bug is triggered.
> >
> >1) node B send DEREF to node A for lockres A and waiting for result.
> >2) node A crashed, node C become the recovery master.
> >3) node C mastered lockres A with node B has a ref on it.
> >4) node B goes to unhashes the lockres A with a ref on node C.
> >  After step 4), if a umount comes on node C, it will hang at
> >migrate lockres A since node B has a ref on it.
> >
> >The fix is that we check if recovery happened on lockres A after sending DEREF
> >request. If that happened, we keep lockres A in hash and in purge list for
> >another try to send DEREF to the new master(node C). So that node C can clear
> >the incorrect refbit.
> >
