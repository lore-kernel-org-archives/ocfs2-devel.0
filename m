From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue, 23 Sep 2008 10:16:57 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add spin lock when accessing
 inode->i_nlink.
In-Reply-To: <48D80BB6.9080308@oracle.com>
References: <200809220915.m8M9F1CR004450@wengang.cn.oracle.com>
	<48D80BB6.9080308@oracle.com>
Message-ID: <48D85199.5030008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil and Srini,

Yes, it's protected by the inode_lock. and thanks for your detail.
well, I found a fragment of code in ocfs2_meta_lock_update(),

#ifdef OCFS2_DELETE_INODE_WORKAROUND
        /* We might as well check this here - since the inode is now
         * locked, an up to date view will indicate whether this was
         * never actually orphaned -- i_nlink should be zero for an
         * orphaned inode. */
        spin_lock(&oi->ip_lock);
        if (inode->i_nlink &&
            oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
                mlog(0, "Inode %"MLFu64": clearing maybe_orphaned flag\n",
                     oi->ip_blkno);
                oi->ip_flags &= ~OCFS2_INODE_MAYBE_ORPHANED;
        }
        spin_unlock(&oi->ip_lock);
#endif

the i_nlink and OCFS2_INODE_MAYBE_ORPHANED flag are checked with the 
protection of ip_lock.
If ip_lock is needed here, I think it's need as well in my patch.

thanks,
wengang.

Sunil Mushran wrote:
> NAK
>
> Firstly ip_lock does not protect inode. Secondly, the field is
> protected by inode_lock. Follow the code:
>
> iput (inode_lock taken) => iput_final ==> ocfs2_drop_inode (inode_lock 
> still held).
>
> void iput(struct inode *inode)
> {
> ....
>                if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
>                        iput_final(inode);
> }
>
> static inline void iput_final(struct inode *inode)
> {
>        struct super_operations *op = inode->i_sb->s_op;
>        void (*drop)(struct inode *) = generic_drop_inode;
>
>        if (op && op->drop_inode)
>                drop = op->drop_inode;
>        drop(inode);
> }
>
>
> wangang wang wrote:
>> add spin lock when accessing inode->i_nlink in ocfs2_drop_inode().
>>
>> the patch is against 1.2 svn.
>>
>> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
>> -- 
>> Index: fs/ocfs2/inode.c
>> ===================================================================
>> --- fs/ocfs2/inode.c    (revision 3101)
>> +++ fs/ocfs2/inode.c    (working copy)
>> @@ -991,10 +991,12 @@
>>      /* Testing ip_orphaned_slot here wouldn't work because we may
>>       * not have gotten a delete_inode vote from any other nodes
>>       * yet. */
>> +    spin_lock(&oi->ip_lock);
>>      if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
>>          mlog(0, "Inode was orphaned on another node, clearing 
>> nlink.\n");
>>          inode->i_nlink = 0;
>>      }
>> +    spin_unlock(&oi->ip_lock);
>>  
>>      generic_drop_inode(inode);
>>  
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>   
>

-- 
Wengang Wang
Member of Technical Staff
Oracle Asia R&D Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925
