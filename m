From: Joseph Qi <joseph.qi@huawei.com>
Date: Sun, 30 Jun 2013 11:10:13 +0800
Subject: [Ocfs2-devel] ocfs2: Should move ocfs2_start_trans out of
	lock_page
In-Reply-To: <20130629131732.GI13405@ZenIV.linux.org.uk>
References: <51C1691F.8060504@huawei.com> <51C80978.2030705@huawei.com>
	<20130629131732.GI13405@ZenIV.linux.org.uk>
Message-ID: <51CFA195.1070403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
Thanks very much for replying this message.
Actually we just met this issue in a case which did a mess of read/write
IOs.
And after analyzing, we found it is just the lock_page that caused this
issue.

We have tried to solve this issue by looking up ext4. Since there are 5
functions related, it requires a lot code changes. So firstly I'd like
to get a second opinion from you.

On 2013/6/29 21:17, Joel Becker wrote:
> I'm pretty sure we did it for a reason, which means we need to think
> about it more than just looking at ext4.  Remember that we get access
> coming from other node actions.
> 
> Joel
> 
> On Mon, Jun 24, 2013 at 04:55:20PM +0800, Joseph Qi wrote:
>> Any different opinion?
>>
>> On 2013/6/19 16:17, Joseph Qi wrote:
>>> Currently ocfs2_start_trans/ocfs2_commit_trans are in
>>> lock_page/unlock_page. This may cause dead lock.
>>>
>>> Here is the situation:
>>> write -> lock_page -> ocfs2_start_trans -> ocfs2_commit_trans -> unlock_page
>>> ocfs2_start_trans/ocfs2_commit_trans calls
>>> jbd2_journal_start/jbd2_journal_stop which may also call lock_page. So
>>> if the page operated is unfortunately the same with the page to be
>>> committed, dead lock happens.
>>>
>>> In ext4, lock_page/unlock_page are in
>>> ext4_journal_start/ext4_journal_stop, this can avoid such kind of dead
>>> lock. So I think we should move ocfs2_start_trans/ocfs2_commit_trans out
>>> of lock_page/unlock_page.
>>>
>>> Totally there are 5 related functions:
>>> ocfs2_write_begin_nolock
>>> ocfs2_write_begin_inline
>>> ocfs2_write_end_nolock
>>> ocfs2_write_zero_page
>>> ocfs2_convert_inline_data_to_extents
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>
>>>
>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
