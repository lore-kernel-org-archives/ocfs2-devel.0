From: Eric Ren <zren@suse.com>
Date: Thu, 12 Nov 2015 17:48:24 +0800
Subject: [Ocfs2-devel] Long io response time doubt
In-Reply-To: <56444708.2050207@huawei.com>
References: <56440208.7070809@huawei.com> <56443E60.9060103@suse.com>
	<56444708.2050207@huawei.com>
Message-ID: <56446068.8010502@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 11/12/15 16:00, Joseph Qi wrote:
> On 2015/11/12 15:23, Eric Ren wrote:
>> Hi Joseph,
>>
>> Thanks for your reply! There're more details I'd like to ask about ;-)
>>
>> On 11/12/15 11:05, Joseph Qi wrote:
>>> Hi Eric,
>>> You reported an issue about sometime io response time may be long.
>>>
>>>   From your test case information, I think it was caused by downconvert.
>>  From what I learned from fs/dlm, lock manager grants all down-conversions requests
>> in place,i.e. on grant queue. Here're some silly questions:
>> 1. who may requests down-convertion?
>> 2. when down-convertion happends?
>> 3. how could a down-convertion takes so long?
> IMO, it happens almost in two cases.
> 1. Owner knows another node is waiting on the lock, in other words, one
> have blocked another's request. It may be triggered in ast, bast, or
> unlock.
> 2. ocfs2cmt does periodically commit.
>
> One case can lead to long time downconvert is, it is indeed that it has
> too much work to do. I am not sure if there are any other cases or code
> bug.
OK, not familiar with ocfs2cmt. Could I bother you to explain what 
ocfs2cmt is used to do,
it's relation with R/W, and why down-conversion can be triggered by when 
it commits?
>> Could you describes more in this case?
>>> And it seemed reasonable because it had to.
>>>
>>> Node 1 wrote file, and node 2 read it. Since you used buffer io, that
>>> was after node 1 had finished written, it might be still in page cache.
>> Sorry, I cannot understand the relationship between "still in page case" and "so...downconvert".
>>> So node 1 should downconvert first then node 2 read could continue.
>>> That was why you said it seemed ocfs2_inode_lock_with_page spent most
>> Actually, it suprises me more with such long time spent than the *most* time compared to "readpage" stuff ;-)
>>> time. More specifically, it was ocfs2_inode_lock after trying nonblock
>>> lock and returning -EAGAIN.
>> You mean read process would repeatedly try nonblock lock until write process down-convertion completes?
> No, after nonblock lock returning -EAGAIN, it will unlock page and then
> call ocfs2_inode_lock and ocfs2_inode_unlock. And ocfs2_inode_lock will
Yes.
> wait until downconvert completion in another node.
Another node which read or write process on?
> This is for an lock inversion case. You can refer the comments of
> ocfs2_inode_lock_with_page.
Yeah, actually I read this comments again and again, but still fail to 
get this idea.
Could you please explain how this works? I'm really really interested 
;-) Forgive me
paste code below, make it convenient to refer.

/*
  * This is working around a lock inversion between tasks acquiring DLM
  * locks while holding a page lock and the downconvert thread which
  * blocks dlm lock acquiry while acquiring page locks.
  *
  * ** These _with_page variantes are only intended to be called from aop
  * methods that hold page locks and return a very specific *positive* error
  * code that aop methods pass up to the VFS -- test for errors with != 
0. **
  *
  * The DLM is called such that it returns -EAGAIN if it would have
  * blocked waiting for the downconvert thread.  In that case we unlock
  * our page so the downconvert thread can make progress.  Once we've
  * done this we have to return AOP_TRUNCATED_PAGE so the aop method
  * that called us can bubble that back up into the VFS who will then
  * immediately retry the aop call.
  *
  * We do a blocking lock and immediate unlock before returning, though, 
so that
  * the lock has a great chance of being cached on this node by the time 
the VFS
  * calls back to retry the aop.    This has a potential to livelock as 
nodes
  * ping locks back and forth, but that's a risk we're willing to take 
to avoid
  * the lock inversion simply.
  */
int ocfs2_inode_lock_with_page(struct inode *inode,
                               struct buffer_head **ret_bh,
                               int ex,
                               struct page *page)
{
         int ret;

         ret = ocfs2_inode_lock_full(inode, ret_bh, ex, 
OCFS2_LOCK_NONBLOCK);
         if (ret == -EAGAIN) {
                 unlock_page(page);
                 if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
                         ocfs2_inode_unlock(inode, ex);
                 ret = AOP_TRUNCATED_PAGE;
         }

         return ret;
}

Thanks,
Eric
>>> And this also explained why direct io didn't have the issue, but took
>>> more time.
>>>
>>> I am not sure if your test case is the same as what the customer has
>>> reported. I think you should recheck the operations in each node.
>> Yes, we've verified several times both on sles10 and sles11.  On sles10, each IO time is smooth, no long time IO peak.
>>> And we have reported an case before about DLM handling issue. I am not
>>> sure if it has relations.
>>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-August/011045.html
>> Thanks, I've read this post. I cannot see any relations yet. Actually, fs/dlm also implements that way, it's the so-called "conversion deadlock"
>> which mentioned in 2.3.7.3 section of "programming locking applications" book.
>>
>> There're only two processes from two nodes. Process A is blocked on wait queue caused by process B in convert queue, that leave grant queue empty,
>> is this possible?
> So we have to investigate why convert request cannot be satisfied.
> If dlm still works fine, it is impossible. Otherwise it is a bug.
>
>> You'know I'm new here, maybe some questions're improper,please point out if so;-)
>>
>> Thank,
>> Eric
