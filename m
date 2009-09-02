From: Coly Li <coly.li@suse.de>
Date: Thu, 03 Sep 2009 01:11:53 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4A8B6C29.30802@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
Message-ID: <4A9EA759.5090906@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Read this thread for some background. There are others like this.
> http://oss.oracle.com/pipermail/ocfs2-devel/2009-April/004313.html
> 
> David had run into a similar issue with two nodes. The symptoms were the
> same. In that case, we were failing to kick the downconvert thread under
> one situation.
> 
> Bottomline, the reason for the hang is that a node is not downconverting
> its lock. It could be a race in dlmglue or something else.
> 
> The node has a PR and an another nodes wants an EX. Unless the node
> downconverts
> to a NL, the master cannot upconvert the other node to EX. Hang. Also,
> cancel
> converts are in the mix.
> [snip]
> The downcnvt shows 1 lockres is queued. We have to assume it is this one.
> If not, then we have a bigger problem. Maybe add a quick/dirty hack to dump
> the lockres in this queue.
> 
> Maybe we are forgetting to kick it like last time. I did scan the code
> for that but came up empty handed.
> 
> To solve this mystery, you have to find out as to why the dc thread is
> not acting on the lockres. Forget stats. Just add printks in that thread.
> Starting from say ocfs2_downconvert_thread_do_work().

I simplified the original perl script to a simple bash script,
---------------------------------
#!/bin/sh

prefix=`hostname`
i=1
while [ 1 ];do
	f="$prefix"_"$i"
	echo $f
	touch $f
	i=`expr $i + 1`
	if [ $i -ge 1000 ];then
		i=1
		rm -f "$prefix"_*
	fi
done
---------------------------------

Run the above script on both nodes can also reproduce the blocking issue.

When the blocking happens, ocfs2_downconvert_thread_do_work() still gets called
again and again.

I add a printk to display osb->blocked_lock_count before the while(1) loop
inside ocfs2_downconvert_thread_do_work().

Here is what I observed,
1) Before the blocking happens, the
number sequence is,
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 2
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
(the count could be 1, 0, 2 and in an irregular sequence)

2) when the blocking happens, the number sequence of osb->blocked_lock_count is
always like this,
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
(all are 0-1-0-1-0-1-... in a regular sequence)

Continue to track...

-- 
Coly Li
SuSE Labs
