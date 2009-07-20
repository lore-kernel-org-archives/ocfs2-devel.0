From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 20 Jul 2009 22:33:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync
	ocfs2 volume.
In-Reply-To: <20090720123401.GA15341@duck.suse.cz>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
	<20090720123401.GA15341@duck.suse.cz>
Message-ID: <4A648037.1060508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan Kara Wrote:
>   Hi,
>
> On Mon 20-07-09 17:08:42, Tao Ma wrote:
>   
>> In commit ea455f8ab68338ba69f5d3362b342c115bea8e13, we move the
>> dentry lock put process into ocfs2_wq. This is OK for most case,
>> but as for umount, it lead to at least 2 bugs. See
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1133 and
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1135. And it happens
>> easily if we have opened a lot of inodes.
>>
>> For 1135, the reason is that during umount will call
>> generic_shutdown_super and it will do:
>> 1. shrink_dcache_for_umount
>> 2. sync_filesystem.
>> 3. invalidate_inodes.
>>
>> In shrink_dcache_for_umount, we will drop the dentry, and queue
>> ocfs2_wq for dentry lock put. While in invalidate_inodes we will
>> call invalidate_list which will iterate all the inodes for the sb.
>> The bad thing is that in this function it will call
>> cond_resched_lock(&inode_lock). So if in any case, we are scheduled
>> out and ocfs2_wq is scheduled and drop some inodes, the "next" in
>> invalidate_list will get damaged(have next->next = next). And the
>> invalidate_list will enter dead loop and cause very high cpu.
>>     
>   Aw, well spotted. Sorry for the bug.
>
>   
>> So the only chance that we can solve this problem is flush dentry put
>> in step 2 of generic_shutdown_super, that is sync_filesystem. And
>> this patch is just adding dentry put flush process in ocfs2_sync_fs.
>>
>> Jan,
>> 	Will dentry put in sync_fs have potential dead lock with quota
>> lock? If yes, maybe we have to revert that commit which cause this umount
>> problem and find other ways instead.
>>     
>   Well, it might be OK but IMHO it's a crude hack. I think the right fix
> should be different: OCFS2 should provide it's own .kill_sb function. In
> that function we should make sure ocfs2_wq stops putting inode references
> and then flush the list from ocfs2_put_super.
>   Regarding quota this should be safe as the only lock we hold is
> umount_sem.
>   Below is a patch doing what I'd imagine (lightly tested only). Could you
> verify whether it fixes the issue you can see?
>   
yeah, your patch looks more natural. I will test it in my box. Great thanks.

Regards,
Tao
