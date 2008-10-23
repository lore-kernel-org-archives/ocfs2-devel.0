From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu, 23 Oct 2008 16:33:32 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fix for nfs getting stale
	inode.
In-Reply-To: <20081023081650.GA1580@mail.oracle.com>
References: <200810230419.m9N4JLpn012453@localhost.localdomain>
	<20081023081650.GA1580@mail.oracle.com>
Message-ID: <490036DC.8000406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

Joel Becker wrote:
> On Thu, Oct 23, 2008 at 12:19:21PM +0800, wengang wang wrote:
>   
>> Ocfs2 supports exporting. 
>>
>> PROBLEM:
>> There are 2 problems
>> (1) Current version of ocfs2_get_dentry() may read from disk
>> the inode WITHOUT any cross cluster lock. This may lead to load a stale inode.
>> (2) for deleting an inode, ocfs2_remove_inode() doesn't sync/checkpoint to disk.
>> This also may lead ocfs2_get_dentry() from other node read out stale inode.
>>
>>     
> <snip> 
>   
>> SOLUTION:
>> (I) adds cross cluster lock for deletion and reading inode from nfs. Deletion
>> takes EX lock which blocks readings on the same inode block; readings take PR
>> lock which blocks deleting the same inode block.
>> (II) checkpoints disk updates for deletion within the cross cluster lock.
>>     
>
> 	Cluster locking in an already slow path really bothers me,
> especially since I gotta believe we already have the state to do this
> locally.
>   
surely, it hurts performance.
while, by my test, the ocfs2_get_dentry() is not called very frequently.
actually we can take the cluster lock only when we need do disk read, 
instead of each time
ocfs2_get_dentry() is called.
> 	What's the problem other than ESTALE?  That's perfectly valid in
> the world of NFS.
>
>   
ESTALE is not a big problem, what is important is that:
it cause kernel panic during ocfs2_meta_lock_update() at later 
operations when it updates metadata from disk.

code
---------------------------------------------------
...
                mlog_bug_on_msg(inode->i_generation !=
                                le32_to_cpu(fe->i_generation),
                                "Invalid dinode %"MLFu64" disk 
generation: %u "
                                "inode->i_generation: %u\n",
                                oi->ip_blkno, le32_to_cpu(fe->i_generation),
                                inode->i_generation);
...
---------------------------------------------------

see bug 
https://bug.oraclecorp.com/pls/bug/webbug_edit.edit_info_top?rptno=7029797.

the patch is my fix for that bug.
by testing, seems it fixes that bug.

thanks
wengang.
