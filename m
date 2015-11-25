From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 25 Nov 2015 13:44:26 +0800
Subject: [Ocfs2-devel] [PATCH v2 4/4] ocfs2: check/fix inode block for
 online file check
In-Reply-To: <5655B1C0020000F90001FCB5@relay2.provo.novell.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<1446013561-22121-5-git-send-email-ghe@suse.com>
	<56385E63.80808@oracle.com>
	<20151124221604.GX15575@wotan.suse.de> <565534D5.5060002@oracle.com>
	<5655B1C0020000F90001FCB5@relay2.provo.novell.com>
Message-ID: <56554ABA.10104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, Mark Fasheh <mfasheh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

On 11/25/2015 01:04 PM, Gang He wrote:
> Hi Mark and Junxiao,
> 
> 
>>>>
>> Hi Mark,
>>
>> On 11/25/2015 06:16 AM, Mark Fasheh wrote:
>>> Hi Junxiao,
>>>
>>> On Tue, Nov 03, 2015 at 03:12:35PM +0800, Junxiao Bi wrote:
>>>> Hi Gang,
>>>>
>>>> This is not like a right patch.
>>>> First, online file check only checks inode's block number, valid flag,
>>>> fs generation value, and meta ecc. I never see a real corruption
>>>> happened only on this field, if these fields are corrupted, that means
>>>> something bad may happen on other place. So fix this field may not help
>>>> and even cause corruption more hard.
>>>
>>> I agree that these are rather uncommon, we might even consider removing the
>>> VALID_FL fixup. I definitely don't think we're ready for anything more
>>> complicated than this though either. We kind of have to start somewhere too.
>>>
>> Yes, the fix is too simple, and just a start, I think we'd better wait
>> more useful parts done before merging it.
> I agree, just remark VALID_FL flag to fix this field is too simple, we should delay this field fix before 
> I have a flawless solution, I will remove these lines code in the first version patches. In the future submits,
> I also hope your guys to help review the code carefully, shout out your comments when you doubt somewhere.
Sure.

> 
> 
> 
>>>
>>>> Second, the repair way is wrong. In
>>>> ocfs2_filecheck_repair_inode_block(), if these fields in disk don't
>>>> match the ones in memory, the ones in memory are used to update the disk
>>>> fields. The question is how do you know these field in memory are
>>>> right(they may be the real corrupted ones)?
>>>
>>> Your second point (and the last part of your 1st point) makes a good
>>> argument for why this shouldn't happen automatically. Some of these
>>> corruptions might require a human to look at the log and decide what to do.
>>> Especially as you point out, where we might not know where the source of the
>>> corruption is. And if the human can't figure it out, then it's probably time
>>> to unmount and fsck.
>> The point is that the fix way is wrong, just flush memory info to disk
>> is not right. I agree online fsck is good feature, but need carefully
>> design, it should not involve more corruptions. A rough idea from mine
>> is that maybe we need some "frezee" mechanism in fs, which can hung all
>> fs op and let fs stop at a safe area. After freeze fs, we can do some
>> fsck work on it and these works should not cost lots time. What's your idea?
> If we need to touch some global data structures, freezing fs can be considered when we can't
> get any way in case using the locks.
> If we only handle some independent problem, we just need to lock the related data structures. 
Hmm, I am not sure whether it's hard to decide an independent issue.

Thanks,
Junxiao.
> 
>>
>> Thanks,
>> Junxiao.
>>
>>>
>>> Thanks,
>>> 	--Mark
>>>
>>> --
>>> Mark Fasheh
>>>
> 
