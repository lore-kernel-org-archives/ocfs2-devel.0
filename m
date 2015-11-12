From: Eric Ren <zren@suse.com>
Date: Thu, 12 Nov 2015 15:23:12 +0800
Subject: [Ocfs2-devel] Long io response time doubt
In-Reply-To: <56440208.7070809@huawei.com>
References: <56440208.7070809@huawei.com>
Message-ID: <56443E60.9060103@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

Thanks for your reply! There're more details I'd like to ask about ;-)

On 11/12/15 11:05, Joseph Qi wrote:
> Hi Eric,
> You reported an issue about sometime io response time may be long.
>
>  From your test case information, I think it was caused by downconvert.
 From what I learned from fs/dlm, lock manager grants all 
down-conversions requests
in place,i.e. on grant queue. Here're some silly questions:
1. who may requests down-convertion?
2. when down-convertion happends?
3. how could a down-convertion takes so long?

Could you describes more in this case?
> And it seemed reasonable because it had to.
>
> Node 1 wrote file, and node 2 read it. Since you used buffer io, that
> was after node 1 had finished written, it might be still in page cache.
Sorry, I cannot understand the relationship between "still in page case" 
and "so...downconvert".
> So node 1 should downconvert first then node 2 read could continue.
> That was why you said it seemed ocfs2_inode_lock_with_page spent most
Actually, it suprises me more with such long time spent than the *most* 
time compared to "readpage" stuff ;-)
> time. More specifically, it was ocfs2_inode_lock after trying nonblock
> lock and returning -EAGAIN.
You mean read process would repeatedly try nonblock lock until write 
process down-convertion completes?
>
> And this also explained why direct io didn't have the issue, but took
> more time.
>
> I am not sure if your test case is the same as what the customer has
> reported. I think you should recheck the operations in each node.
Yes, we've verified several times both on sles10 and sles11.  On sles10, 
each IO time is smooth, no long time IO peak.
>
> And we have reported an case before about DLM handling issue. I am not
> sure if it has relations.
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-August/011045.html
Thanks, I've read this post. I cannot see any relations yet. Actually, 
fs/dlm also implements that way, it's the so-called "conversion deadlock"
which mentioned in 2.3.7.3 section of "programming locking applications" 
book.

There're only two processes from two nodes. Process A is blocked on wait 
queue caused by process B in convert queue, that leave grant queue empty,
is this possible?

You'know I'm new here, maybe some questions're improper,please point out 
if so;-)

Thank,
Eric
