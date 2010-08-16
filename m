From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Aug 2010 16:03:06 +0800
Subject: [Ocfs2-devel] [PATCH] CMWQ: Set workqueue name before we
	process one work.
In-Reply-To: <4C68EC76.70903@kernel.org>
References: <1281944355-4379-1-git-send-email-tao.ma@oracle.com>
	<4C68EC76.70903@kernel.org>
Message-ID: <4C68F0BA.5050905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Tejun,
	Thanks for the quick response.
On 08/16/2010 03:44 PM, Tejun Heo wrote:
> On 08/16/2010 09:39 AM, Tao Ma wrote:
>> Now in CMWQ, workqueue threads are named as 'kworker/*'. So it is
>> a little boring to see in the 'top'(below) and actually it isn't
>> meaningful for the users.
>> 12606 root      20   0     0    0    0 S    2  0.0   0:03.22 kworker/u:0
>> 12607 root      20   0     0    0    0 S    1  0.0   0:03.69 kworker/u:4
>>
>> So this patch just try to set the proper workqueue name if it does
>> exist. Yes, workqueue now is a thread pool and the data may be not
>> accurate but I think it is better(below) than the 'kworker*' stuff.
>> And if there is something block the workqueue, we can find the caller
>> easily.
>> 12606 root      20   0     0    0    0 D    2  0.0   0:02.90 dlm_wq
>> 12607 root      20   0     0    0    0 D    0  0.0   0:03.21 ocfs2_wq
>>
>> What's more, in ocfs2, we sometimes want to print some debug info in
>> the system log and we use 'current->comm' to print the thread and this
>> change also does help.
>>
>> The only thing I am not clear is that do we need [gs]et_task_comm?
>> I guess not and this patch just try to use strlcpy without task_lock.
>>
>> Cc: Tejun Heo<tj@kernel.org>
>> Signed-off-by: Tao Ma<tao.ma@oracle.com>
>
> I thought about the same thing but this doesn't provide any more
> information than stack traces for debugging and for run time tracking
> implementing tracing API (scheduled to be added in this devel cycle)
> is the right approach.
Do you have the link for this or it will show up in the mail list soon?
> change program name.  It will confuse more than help.  So, unless
> there are other reasons for doing this, I don't think I'm gonna take
> this one.
OK, let me find other ways ocfs2 can use to trace the real callers of 
some functions in runtime.

Regards,
Tao
