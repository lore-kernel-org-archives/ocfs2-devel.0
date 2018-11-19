From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 19 Nov 2018 15:15:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix panic due to unrecovered local
 alloc
In-Reply-To: <5BF25019.3050700@huawei.com>
References: <20181116073335.5045-1-junxiao.bi@oracle.com>
	<5BF21D3B.9090300@huawei.com>
	<607f902f-d21d-bf51-a152-7fff84daf0a9@oracle.com>
	<5BF25019.3050700@huawei.com>
Message-ID: <128c905f-8812-36fd-0808-01f653685495@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/19/18 1:54 PM, jiangyiwen wrote:

> On 2018/11/19 11:24, Junxiao Bi wrote:
>> Hi Yiwen
>>
>> On 11/19/18 10:17 AM, jiangyiwen wrote:
>>> Hi Junxiao,
>>>
>>> I think this scenario may be as follows:
>>>
>>> ocfs2_dismount_volume()
>>>     - ocfs2_shutdown_local_alloc()
>>>       1. clear local alloc and commit transaction
>> For jbd2, not commit yet, it could be still in running transaction, that means it was not written into journal yet.
>>
>> Later when flushing the running transaction to journal, io error may happen, this running transaction not only contained local alloc changes but also other metadata. How recovering local alloc only can avoid other metadata corruption?
>>
> Right, so we should judge if journal abort when call ocfs2_journal_toggle_dirty().

jbd2_journal_destroy() already did that, if is_journal_aborted() return 
true, it will reutrn -EIO, so seemed checking the return value enough to 
detect this?

Thanks,

Junxiao.


>
>>>       2. storage disconnection cause data don't update to disk and journal abort.
>>>     - ocfs2_journal_shutdown()
>>>       3. in this function, it will call ocfs2_journal_toggle_dirty() to
>>>          clear dirty even if journal abort.
>> Check rerturn value of jbd2_journal_destroy() seemed OK to judge whether toggle dirty flag.
>>
> I suggest add the judgement of journal_abort too, like ext4_put_super().
>
> Thanks.
>
>> Thanks,
>>
>> Junxiao.
>>
>>> So I suggest we can do two aspects:
>>> 1. Actively recover local alloc when checking journal clean and "local_alloc dirty"
>>> in ocfs2_check_volume(), instead of fsck, it can online recover this case more
>>> intelligently.
>>> 2. Before calling ocfs2_journal_toggle_dirty(), check if journal abort.
>>>
>>> Thanks,
>>> Yiwen.
>>>
>>
>
