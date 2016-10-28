From: Eric Ren <zren@suse.com>
Date: Fri, 28 Oct 2016 15:06:51 +0800
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take inode
 lock in ocfs2_iop_set/get_acl()"? or other ideas?
In-Reply-To: <20161028062056.GA9994@lst.de>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<20161028062056.GA9994@lst.de>
Message-ID: <3560e3e5-00e1-60a9-31eb-77f0d0a47a8e@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@versity.com>

Hi Christoph!

Thanks for your attention.

On 10/28/2016 02:20 PM, Christoph Hellwig wrote:
> Hi Eric,
>
> I've added linux-fsdevel to the cc list as this should get a bit
> broader attention.
>
> On Wed, Oct 19, 2016 at 01:19:40PM +0800, Eric Ren wrote:
>> Mostly, we can avoid recursive locking by writing code carefully. However, as
>> the deadlock issues have proved out, it's very hard to handle the routines
>> that are called directly by vfs. For instance:
>>
>>      const struct inode_operations ocfs2_file_iops = {
>>              .permission     = ocfs2_permission,
>>              .get_acl        = ocfs2_iop_get_acl,
>>              .set_acl        = ocfs2_iop_set_acl,
>>      };
>>
>>
>> ocfs2_permission() and ocfs2_iop_get/set_acl() both call ocfs2_inode_lock().
>> The problem is that the call chain of ocfs2_permission() includes *_acl().
> What do you actually protect in ocfs2_permission?  It's a trivial
> wrapper around generic_permission which just looks at the VFS inode.
Yes, it is.

https://github.com/torvalds/linux/blob/master/fs/ocfs2/file.c#L1321
---
ocfs2_permission
       ocfs2_inode_lock()
generic_permission
ocfs2_inode_unlock
>
> I think the right fix is to remove ocfs2_permission entirely and use
> the default VFS implementation.  That both solves your locking problem,
> and it will also get you RCU lookup instead of dropping out of
> RCU mode all the time.
But, from my understanding, the pair of ocfs2_inode_lock/unlock() is used to prevent any 
concurrent changes
to the permission of the inode on the other cluster node while we are checking on it. It's a 
common  case for cluster
filesystem, such as GFS2: https://github.com/torvalds/linux/blob/master/fs/gfs2/inode.c#L1777

Thanks for your suggestion again!
Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161028/9a90961d/attachment.html 
