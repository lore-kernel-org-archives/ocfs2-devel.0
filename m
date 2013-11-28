From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 28 Nov 2013 09:40:41 +0800
Subject: [Ocfs2-devel] ocfs2: a dead lock case when running
	dirop_fileop_racer
In-Reply-To: <527C4A4B.6020402@huawei.com>
References: <527B8392.8010807@huawei.com> <20131107131948.GH24799@localhost>
	<527C4A4B.6020402@huawei.com>
Message-ID: <52969F19.9080502@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/11/8 10:19, Joseph Qi wrote:
> On 2013/11/7 21:19, Joel Becker wrote:
>> On Thu, Nov 07, 2013 at 08:12:02PM +0800, Joseph Qi wrote:
>>> We ran ocfs2 test program dirop_fileop_racer and found a dead lock case.
>>>
>>> The case is described below.
>>> 2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
>>> /race/16/1 in the filesystem, and let the inode number of dir 16 is less
>>> than the inode number of dir race.
>>>
>>> Node A                            Node B
>>> mv /race/16/1 /race/
>>>                                   right after Node A has got the
>>>                                   EX mode of /race/16/, and tries to
>>>                                   get EX mode of /race/
>>>                                   ls /race/16/
>>>
>>> In this case, Node A has got the EX mode of /race/16/, and wants to get
>>> EX mode of /race/. Node B has got the PR mode of /race/, and wants to
>>> get the PR mode of /race/16/. Since EX and PR are mutually exclusive,
>>> dead lock happens.
>>
>> Interesting.  What DLM are you using, o2dlm or fs/dlm?  I would expect
>> that fs/dlm would do deadlock detection, but I could be wrong.
>>
> We are using ocfs2 dlm.
> 
>> There's no way the PR on /race/ will downconvert, because there is a
>> reference.  We really want a signal to that PR waiting on /race/16/, but
>> there's no in-progress work happening on node A for that.
>>
> Can timeout resolve this issue?
> A glancing thought is, once timeout happens, cancel the queued lock and
> let it lock operation fail.
> 
If this case happens, it seems that we can try to get the lock of /race/
first (parent), and then get the lock of /race/16/ (child).
That is to mean, check if one inode is the ancestor of the other.
Anything I am missing?

>> I suppose we could hack this to check for ancestors.  That is, rename
>> locks should be in ancestor order before trying inode number order.  I'm
>> not sure that always works, though, especially if the ancestors are not
>> consecutive and might also be affected by in-flight moves...
>>
>> Joel
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
