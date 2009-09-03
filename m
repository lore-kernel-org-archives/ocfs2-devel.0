From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 03 Sep 2009 09:24:12 -0700
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4A9FEDA8.3080108@suse.de>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de>
Message-ID: <4A9FEDAC.50704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

You will have to trace thru process_blocked_lock() to make sense of this.

Coly Li wrote:
> Sunil Mushran Wrote:
>   
>> So the thread is removing the lockres from the list (thus making
>> the count 0), and then calling ocfs2_process_blocked_lock() which
>> is adding that lockres back in the list (thus 1).
>>
>> Trace ocfs2_process_blocked_lock() to see as to why it is putting it
>> back on the list.
>>     
>>> 2) when the blocking happens, the number sequence of
>>> osb->blocked_lock_count is
>>> always like this,
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 0
>>> ocfs2_downconvert_thread_do_work:3725: osb->blocked_lock_count: 1
>>> (all are 0-1-0-1-0-1-... in a regular sequence)
>>>
>>>       
>
> I also observed even when no file is created or unlinked, I did nothing. From
> dmesg output, the above information still infinite running, on both nodes.
>
>
>
>   
