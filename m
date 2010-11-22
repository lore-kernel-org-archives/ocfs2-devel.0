From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 22 Nov 2010 10:59:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full'
 O_DIRECT writes to correctly up_read i_alloc_sem.
In-Reply-To: <4CE9D3DF.4070707@oracle.com>
References: <1290155919-4280-1-git-send-email-tristan.ye@oracle.com>
	<4CE68B0B.8010308@oracle.com> <4CE9D3DF.4070707@oracle.com>
Message-ID: <4CE9DC7B.9010703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,

On 11/22/2010 10:22 AM, Tristan Ye wrote:
> Tao Ma wrote:
>> Hi Tristan,
>> Just add joel to the cc in case he has a different option.
>>
>> On 11/19/2010 04:38 PM, Tristan Ye wrote:
>>> Former logic of ocfs2_file_aio_write() was a bit stricky to unlock
>>> the rw_lock
>>> and i_alloc_sem, by using some private bits in struct 'iocb' to
>>> communite with
>>> ocfs2_dio_end_io(), it did work before we introduce the patch of
>>> supporting
>>> 'coherency=full,buffered' option, since rw_lock and i_alloc_sem were
>>> never
>>> acquired both at the same time, no mattar we doing buffered or direct
>>> IO or not.
>> These 2 locks can be acquired at the same time.
>> So if we go with direct_io, we do have i_alloc_sem and rw_lock locked
>> simultaneously. why do you get this?
>
> For coherency_full direct_io, we have these 2 locks, while for
> coherency_buffered direct_io, we only acquire i_alloc_sem.
How do you get this? We always get rw_lock?
>
>>
>> I have gone through your patch and the bug. It sees to me that the
>> real cause for the bug is that you have EX rw_lock because of
>> full_coherency while locking i_alloc_sem. So finally in
>> ocfs2_dio_end_io, only rw_lock is freed and i_alloc_sem is left,
>> right? If yes, please update the above commit log for it.
>
> Didn't quite get you here, there is no lock was blocking i_alloc_sem,
> instead, i_alloc_sem was not up_read() correctly and explicitly somewhere.
yes, it isn't freed because of the rw_level, right? In your case, 
rw_level is 1, so in ocfs2_dio_end_io, i_alloc_sem isn't freed, right?
>
>>
>>
>> I don't like your solution either. full_coherency is only used in
>> direct write and ocfs2_dio_end_io is used for both direct read/write.
>> So why add the complexity of coherency to ocfs2_dio_end_io? Also you
>> long comment in ocfs2_file_aio_write does indicate that it is really
>> hard for the code reader to learn why we need to set this flag.
>
> The complexity is just introduce by the nature that 'coherency_full' and
> 'coherency_buffered' direct_io writes is gonna have different locks, as
> you known, we only have one mode for direct_io writes before.
>
>>
>> My suggestion is: why not use another flag to indicate the state of
>> i_alloc_sem instead of full_coherency? So in place we down_read the
>> i_alloc_sem, set the flag accordingly, and in ocfs2_dio_end_io, just
>> check this flag instead of !rw_locked_level to up_read it. It should
>> be more straightforward. Agree?
>
> Yep, I do agree that this fix looks tricky a bit, while the all existed
> ocfs2_dio_end_io() things were already tricky there;)
No, ocfs2_dio_end_io isn't tricky. So in general, you lock something in 
ocfs2_file_aio_{read,write}, and then they are freed in 
ocfs2_dio_end_io. That's it. The only thing that you may think as tricky 
is that we use a rw_level to indicate whether we need to up_read 
i_alloc_sem. It worked in the old case, but doesn't work now.
>
> Using 'ocfs2_iocb_set_sem_locked' or 'ocfs2_iocb_set_coherency' didn't
> simplify the logic quite a bit, however, I still appreciated
> your suggestion to follow existing convention, such as
> ocfs2_iocb_set_rw_locked' things, they just look more similar and in a
> series;-)
yes, it looks more natural and easy. So when you lock i_alloc_sem, just 
call ocfs2_iocb_set_sem_locked, and when  you lock rw_lock, just set the 
ocfs2_iocb_set_rw_locked. That's it. You don't neet to think about some 
stuff like coherency or not.

Regards,
Tao
