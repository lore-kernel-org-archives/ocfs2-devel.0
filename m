From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 18 Feb 2009 16:30:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <20090218013700.GA26431@mail.oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
	<20090218013700.GA26431@mail.oracle.com>
Message-ID: <499BC715.2000701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>> this patch is based on 1.4 git.
> 
> 	Going forward, fixes really need to be against mainline.  Let's
> finish out this patch against 1.4 and then you can port it to mainline.
> But for the future, we fix against mainline and backport.
> 
Ok, I will follow that from next posting.

> 
> 	You can drop the suballocator lock here.  Taking the lock has
> made sure that other nodes flushed their journals.  You have just
> validated that the bit is set, and other nodes cannot clear the bit
> until they get the nfs_sync lock, which you already hold.  So it is safe
> to call ocfs2_inode_unlock(inode_alloc_inode, 0) and
> mutex_unlock(&inode_alloc_inode->i_mutex) before calling ocfs2_iget().
> 	This has two benefits.  Number 1, we don't take the suballoc
> lock and the inode lock (in iget()) at the same time.  The fewer locks
> we take at the same time, the better.  Number 2, this means the entire
> suballocator lookup code above can be made into a subfunction.  This
> improves the readability of the code.
>
good point! will revise the code.

>> +	if (suballoc_slot)
>> +		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
> 
> 	Probably want to validate that suballoc_slot is within the range
> of valid slot numbers.  Just in case.
in what case could the suballoc_slot be out of range?

> 	Otherwise, everything looks good.  The nfs_sync_lock is good.
> It will need to be added to debugfs.ocfs2's lock displays.

next post will be against mainline. and the patch for debugfs.ocfs2 will
be available later to ocfs2-tools-devel@

thanks,
wengang.
