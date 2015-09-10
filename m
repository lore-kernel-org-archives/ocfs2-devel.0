From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 10 Sep 2015 19:49:45 +0800
Subject: [Ocfs2-devel] [RFC] Doubt about dlm_worker
In-Reply-To: <55EC3B99.7040601@huawei.com>
References: <55EC3B99.7040601@huawei.com>
Message-ID: <55F16E59.8070006@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao & Sunil,
Your comments would be appreciated.

Thanks,
Joseph

On 2015/9/6 21:11, Joseph Qi wrote:
> Comments for dlm_dispatch_work is described below:
> /* Worker function used during recovery. */
> 
> But actually dlm_worker is used by 4 types of dlm message workers:
> 	dlm_assert_master_worker
> 	dlm_deref_lockres_worker
> 	dlm_request_all_locks_worker
> 	dlm_mig_lockres_worker
> 
> And the first 2 are not dlm recovery related. Moreover, it will send
> DLM_ASSERT_MASTER_MSG to all other nodes in dlm_assert_master_worker.
> And it may do a lot of assert master during recovery. In our scenario,
> it is tens of thousands.
> This will delay the recovery because dlm_worker is a single thread
> workqueue and cluster is hanging during dlm recovery.
> So I doubt if we can move the assert master to a new workqueue or just
> use a system workqueue.
> Any suggestions?
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
