From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue, 23 Sep 2008 15:42:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add spin lock when accessing
 inode->i_nlink.
In-Reply-To: <48D86122.1040209@oracle.com>
References: <200809220915.m8M9F1CR004450@wengang.cn.oracle.com>	<48D80BB6.9080308@oracle.com>
	<48D85199.5030008@oracle.com> <48D86122.1040209@oracle.com>
Message-ID: <48D89DEB.70607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Tao Ma wrote:
> Hi wengang,
>
> wengang wang wrote:
>> Sunil and Srini,
>>
>> Yes, it's protected by the inode_lock. and thanks for your detail.
>> well, I found a fragment of code in ocfs2_meta_lock_update(),
>>
>> #ifdef OCFS2_DELETE_INODE_WORKAROUND
>>         /* We might as well check this here - since the inode is now
>>          * locked, an up to date view will indicate whether this was
>>          * never actually orphaned -- i_nlink should be zero for an
>>          * orphaned inode. */
>>         spin_lock(&oi->ip_lock);
>>         if (inode->i_nlink &&
>>             oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
>>                 mlog(0, "Inode %"MLFu64": clearing maybe_orphaned 
>> flag\n",
>>                      oi->ip_blkno);
>>                 oi->ip_flags &= ~OCFS2_INODE_MAYBE_ORPHANED;
>>         }
>>         spin_unlock(&oi->ip_lock);
>> #endif
>>
>> the i_nlink and OCFS2_INODE_MAYBE_ORPHANED flag are checked with the 
>> protection of ip_lock.
>> If ip_lock is needed here, I think it's need as well in my patch.
>>   
> ip_lock here is used to protect the set of ip_flags.
>
my concern is that the two function runs as following in timer order.
process A running in ocfs2_drop_inode() and B running in 
ocfs2_meta_lock_update()

A        if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
C(omment): now inode->i_nlink is not 0.
B        if (inode->i_nlink && oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
B                mlog(0, "Inode %"MLFu64": clearing maybe_orphaned 
flag\n", oi->ip_blkno);
B                oi->ip_flags &= ~OCFS2_INODE_MAYBE_ORPHANED;
B        }
A                mlog(0, "Inode was orphaned on another node, clearing 
nlink.\n");
A                inode->i_nlink = 0;
A        }

thus, as a result,
1) OCFS2_INODE_MAYBE_ORPHANED is cleared but inode->i_nlink is 0. 
but result we wanted is
2) OCFS2_INODE_MAYBE_ORPHANED is set and i_nlink is 0  or
3) OCFS2_INODE_MAYBE_ORPHANED is cleared and i_nlink is not 0.

well, seems 1) won't happen.
when ocfs2_drop_inode() is running, the inode is with 0 ref count and 
with inode_lock's protect. so other process can't get any ref on this 
inode and so won't run ocfs2_meta_lock_update() on this inode.
so the original code is no problem.
but if it's not in ocfs2_drop_inode(), it's not a good code.

thanks,
wengang.
> Regards,
> Tao
>
