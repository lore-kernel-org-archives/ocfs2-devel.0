From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 20 May 2013 10:49:11 +0800
Subject: [Ocfs2-devel] ocfs2: Question for ocfs2_recovery_thread
In-Reply-To: <51983831.3050802@huawei.com>
References: <51971F6C.1000002@huawei.com>
	<CD83871B-2C0E-48ED-B037-1B49AF0B98C9@gmail.com>
	<51983831.3050802@huawei.com>
Message-ID: <51998F27.7070601@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/5/19 10:25, Joseph Qi wrote:
> On 2013/5/18 21:26, Sunil Mushran wrote:
>> The first node that gets the lock will do the actual recovery. The others will get the lock and see a clean journal and skip the recovery. A thread should never error out if it fails to get the lock. It should try and try again.
>>
>> On May 17, 2013, at 11:27 PM, Joseph Qi <joseph.qi@huawei.com> wrote:
>>
>>> Hi,
>>> Once there is node down in the cluster, ocfs2_recovery_thread will be
>>> triggered on each node. These threads then do the down node recovery by
>>> get super lock.
>>> I have several questions on this:
>>> 1) Why each node has to run such a thread? We know at last one node can
>>> get the super lock and do the actual recovery.
>>> 2) If this thread is running but something error occurred, take
>>> ocfs2_super_lock failed for example, the thread will exit without
>>> clearing recovery map, will it cause other threads still waiting for
>>> recovery in ocfs2_wait_for_recovery?
>>>
>>
>>
> But when error occurs and goes to bail, and the restart logic will not
> run. Codes like below:
> ...
> 	status = ocfs2_wait_on_mount(osb);
> 	if (status < 0) {
> 		goto bail;
> 	}
> 
> 	rm_quota = kzalloc(osb->max_slots * sizeof(int), GFP_NOFS);
> 	if (!rm_quota) {
> 		status = -ENOMEM;
> 		goto bail;
> 	}
> restart:
> 	status = ocfs2_super_lock(osb, 1);
> 	if (status < 0) {
> 		mlog_errno(status);
> 		goto bail;
> 	}
> ...
> 	if (!status && !ocfs2_recovery_completed(osb)) {
> 		mutex_unlock(&osb->recovery_lock);
> 		goto restart;
> 	}
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
One more question, do we make sure dlm_recovery_thread always prior to
ocfs2_recovery_thread?
