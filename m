From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 16 Nov 2015 09:40:01 +0800
Subject: [Ocfs2-devel] Long io response time doubt
In-Reply-To: <20151114052333.GA5173@laptop.ha>
References: <56440208.7070809@huawei.com> <56443E60.9060103@suse.com>
	<56444708.2050207@huawei.com> <56446068.8010502@suse.com>
	<5645598F.7010304@huawei.com> <20151114052333.GA5173@laptop.ha>
Message-ID: <564933F1.80906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

On 2015/11/14 13:23, Eric Ren wrote:
> Hi Joseph,
> 
>>>> > >> 2. ocfs2cmt does periodically commit.
>>>> > >>
>>>> > >> One case can lead to long time downconvert is, it is indeed that it has
>>>> > >> too much work to do. I am not sure if there are any other cases or code
>>>> > >> bug.
>>> > > OK, not familiar with ocfs2cmt. Could I bother you to explain what ocfs2cmt is used to do,
>>> > > it's relation with R/W, and why down-conversion can be triggered by when it commits?
>> > Sorry, the above explanation is not right and may mislead you.
>> > 
>> > jbd2/xxx (previously called kjournald2?) does periodically commit,
>> > the default interval is 5s and can be set with mount option "commit=".
>> > 
>> > ocfs2cmt does the checkpoint, it can be waked up:
>> > a) unblock lock during downconvert, and if jbd2/xxx has already done the
>> > commit, ocfs2cmt won't be actually waken up because it has already been
>> > checkpointed. So ocfs2cmt works with jbd2/xxx.
> OK, thanks for your knowledge;-)
>> > b) evict inode and then do downconvert.
> Sorry, I'm confused about b). You mean b) is also part of ocfs2cmt's
> work? Does b) have something to do with a)? And what's the meaning of "evict inode"?
> Actually, I can hardly understand the idea of b).
You can go through the code flow:
iput->iput_final->evict->evict_inode->ocfs2_evict_inode
->ocfs2_clear_inode->ocfs2_checkpoint_inode->ocfs2_start_checkpoint

It happens that one node do not use the inode any longer (but not
delete), and will free its related lockres.

Thanks,
Joseph

>> > 
>>>>> > >>> Could you describes more in this case?
>>>>>> > >>>> And it seemed reasonable because it had to.
>>>>>> > >>>>
>>>>>> > >>>> Node 1 wrote file, and node 2 read it. Since you used buffer io, that
>>>>>> > >>>> was after node 1 had finished written, it might be still in page cache.
>>>>> > >>> Sorry, I cannot understand the relationship between "still in page case" and "so...downconvert".
>>>>>> > >>>> So node 1 should downconvert first then node 2 read could continue.
>>>>>> > >>>> That was why you said it seemed ocfs2_inode_lock_with_page spent most
>>>>> > >>> Actually, it suprises me more with such long time spent than the *most* time compared to "readpage" stuff ;-)
>>>>>> > >>>> time. More specifically, it was ocfs2_inode_lock after trying nonblock
>>>>>> > >>>> lock and returning -EAGAIN.
>>>>> > >>> You mean read process would repeatedly try nonblock lock until write process down-convertion completes?
>>>> > >> No, after nonblock lock returning -EAGAIN, it will unlock page and then
>>>> > >> call ocfs2_inode_lock and ocfs2_inode_unlock. And ocfs2_inode_lock will
>>> > > Yes.
>>>> > >> wait until downconvert completion in another node.
>>> > > Another node which read or write process on?
>> > Yes, the node blocks my request.
>> > For example, node 1 has EX, then node 2 wants to get PR, it should wait
>> > for node 1 downconvert first.
> OK~
> 
> Thanks,
> Eric
