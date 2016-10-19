From: Eric Ren <zren@suse.com>
Date: Wed, 19 Oct 2016 15:46:06 +0800
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take inode
 lock in ocfs2_iop_set/get_acl()"? or other ideas?
In-Reply-To: <5B4B400B-CBF5-4F50-B6C5-2AED4BA6365C@oracle.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<5B4B400B-CBF5-4F50-B6C5-2AED4BA6365C@oracle.com>
Message-ID: <c9da7406-69c9-7102-9fa3-e199881e77df@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 10/19/2016 02:57 PM, Junxiao Bi wrote:
> I had ever implemented generic recursive locking support, please check the patch at https://oss.oracle.com/pipermail/ocfs2-devel/2015-December/011408.html <https://oss.oracle.com/pipermail/ocfs2-devel/2015-December/011408.html> , the issue that locking and unlocking in different processes was considered. But it was rejected by Mark as recursive locking is not allowed in ocfs2/kernel .
Yes, I can remember it. The different point is that I just want to have a function to check 
recursive locking
than supporting recursive locking;-)

Honestly, I cannot understand your patch thoroughly until now.  Back to that time, it's the 
complication of your patch
that concerns me. Besides, looks like the "PR+EX" + "non-block" request cannot be handled well?
>> The thrid one is to revert that problematic commit! It looks like get/set_acl()
>> are always been called by other vfs callback like ocfs2_permission(). I think
>> we can do this if it's true, right? Anyway, I'll try to work out if it's true;-)
> Not sure whether get/set_acl() will be called directly by vfs. Even not now, we can?t make sure that in the future. So revert it may be a little risky. But if refactor is complicated, then this maybe the only way we can do.
Agree. Let's investigate more into it;-)

Thanks,
Junxiao
>
> Thanks,
> Junxiao.
>> Hope for your input to solve this problem;-)
>>
>> Thanks,
>> Eric
>>
>
