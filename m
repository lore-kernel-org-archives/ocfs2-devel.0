From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 09 Jun 2009 12:20:00 +0800
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: automatic dlm hash table
 size
In-Reply-To: <4A2D6169.6060603@oracle.com>
References: <200906080515.n585F9Mu012898@rgminet15.oracle.com>	<4A2CA7CC.7020407@oracle.com>
	<4A2CAE87.6070605@oracle.com>	<4A2CB249.5050304@oracle.com>
	<4A2CB464.5000103@oracle.com> <4A2D6169.6060603@oracle.com>
Message-ID: <4A2DE2F0.90007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,

Sunil Mushran wrote:
> Wengang Wang wrote:
>> just increasing it works. I'm concerning memory waste for few inodes
>> usage case. I don't know how large it is going to be in the future..
>> even now, I just don't hope a memory waste though it's small though
>> memory is cheap now... :)
> 
> So, we did discuss dynamic resizing of the lockres hash over a
> year ago. At that time our hash was very small. 1 page in 1.2,
> and 4 pages in 1.4-beta/mainline. At that time, we decided to
> bump up the default in 1.4 to 64 pages.
> 

sorry I missed that.

> Resizing requires a feedback loop. As in... lookup is taking too
> much time. I am working on adding instrumentation that provides this
> info. (The number of lockres' is too crude a stat.)
> 

I don't understand why the lookup is taking too much time.
As my idea of resizing, it can follow the steps.

1) a insertion comes, it inserts the lockres to "current" hash table.
after insertion, it checks the number of lockres' in the table. if 
resizing is needs, it kicks a ASYNC resizing.
2) the ASYNC resizing can be dealled with in different processes(a 
kernel thread, exp. in dlm_thread).
the resizing process, in turn, does
2.1) allocates pages without the spinlock.
2.2) does the actual removing work:
2.2.1) takes spinlock;
2.2.2) moves a fixed number of lockres' to the new table from the 
"current" hash table;
2.2.3) if no lockres' left in the "current" table, let "current" point 
to the new table.
2.2.4) release spinlock;
2.2.5) free pages for the "current" table before step 2.2.3.
2.2.6) release cpu if needed.
3) a lookup comes. after taking the spinlock, it looks at the "current" 
hash table, if not found, it looks at the new hash table. then it 
release the spinlock.
I can't see where the lookup can take too much time than it does before 
resizing. or I missed something?

I didn't cover all detail about the resizing such as flags marking 
resizing in progress; the new table available to use; recalculate hash 
value for new hash table and so on.


> Once we have that, I would prefer we make the lock per chain instead
> of a global. That will allow us to get more bang for the buck. Will
> allow us to reduce the hashtable from 64 pages.
> 

that is a smart way to go:).
however, I think we shouldn't add too many stuff to lockres structure. 
if we do, the memory used for the new added stuff will be much more than 
the memory used for enlarging the hash table.

> In the end, I am not yet sold on dynamic resizing. One data point is
> that inode/dcache hashes are not dynamically resized.

:), but discussing is interesting!

thanks,
wengang.
-- 
--just begin to learn, you are never too late...
