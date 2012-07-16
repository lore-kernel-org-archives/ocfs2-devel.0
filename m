From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 16 Jul 2012 16:39:15 -0700
Subject: [Ocfs2-devel] a bug about deadlock when enable quota on ocfs2
In-Reply-To: <20120713220907.GB12532@quack.suse.cz>
References: <4FFCF397.20108@oracle.com> <20120713220907.GB12532@quack.suse.cz>
Message-ID: <5004A623.5000909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

thanks for helping.

Jan Kara wrote:
>   Hello,
>> his comments:
>> @ With those patches in, all other nodes will now queue downgrade of dentry
>> @ locks to ocfs2_wq thread. Then Node 1 gets a lock is in use when it calls
>> @ ocfs2_try_open_lock and so does other nodes and hence orphans lie
>> around. Now
>> @ orphans will keep growing and only gets cleared when all nodes umount the
>> @ volume. This causes a different problems 1)space is not cleared 2)
>> as orphans
>> @ keep growing, orphan thread takes long time to scan all orphans(but still
>> @ fails to clear oprhans because of open lock still around) and hence will
>> @ block new unlinks for that duration because it gets a EX on orphan
>> scan lock.
>>     
>   I think the analysis is not completely correct (or I misunderstood it).
> We defer only putting of inode reference to workqueue (lockres is freed
> already in ocfs2_drop_dentry_lock()). However it is correct that the queue
> of inodes to put can get long and the system gets into trouble.
>   
Sorry for not being clear. This is an issue when thread running unlink 
and ocfs2_wq on other node end up running ocfs2_delete_inode at the same 
time. They both call ocfs2_try_open_lock during query wipe inode and get 
EAGAIN. So they both defer the actual clean up.

This will become a problem if a user deletes tons of files at the same 
time. Lot of  orphans gets queued and it becomes a problem when user 
continues to delete.
>> My questions are
>> 1.) what kind of "potential deadlock" in your comment?
>>     
>   Dropping inode reference can result in deletion of inode when this was
> the last reference to an unlinked file. However ocfs2_delete_inode() needs
> to take locks which rank above locks held when ocfs2_drop_dentry_lock() is
> called. You can check this by removing my patches, enabling
> CONFIG_PROVE_LOCKING and see the warning lockdep spits.
I am not familiar with which locks get out of order. Tiger can you 
please check this.
>> .) I have tried removing this patch, ocfs2 became more durable,
>> although it caused another panic but not get deadlock again, could
>> we remove this patch and just to fix the new problem? may the new
>> problem is the "potential deadlock" you mentioned.
>>     
>   I talked about possible solutions to Wengang already. Basically before we
> start unlinking we could check whether there aren't too many queued puts of
> inode references and if yes, drop some of them directly from unlink process
> before we acquire any cluster locks or so.
>   
We could do this but if there is a deadlock bug we could still run into 
it when we try deleting directly right?
> 								Honza
>
> PS: I CC'ed ocfs2-devel so that this discussion gets archived and other
> developers can help as well.
> PS2: I'm going for a longer vacation now so I won't be responding to email
> for some time.
>   
Have a good vacation :)
