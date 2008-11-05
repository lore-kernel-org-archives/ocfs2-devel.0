From: Coly Li <coyli@suse.de>
Date: Wed, 05 Nov 2008 19:15:20 +0800
Subject: [Ocfs2-devel] question of ocfs2_do_flock()
In-Reply-To: <20081104210032.GU15154@wotan.suse.de>
References: <4910296E.4080301@suse.de> <20081104210032.GU15154@wotan.suse.de>
Message-ID: <49118048.2000600@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh Wrote:
> On Tue, Nov 04, 2008 at 06:52:30PM +0800, Coly Li wrote:
>> Hi list,
>>
>> These days I am working on a L3 bug on SLES10 SP2. When I read ocfs2_do_flock(), there are some
>> questions from me. Wish anybody can give me a little hint to understand the code. Thanks.
>>
>>
>>
>> static int ocfs2_do_flock(struct file *file, struct inode *inode,
>>                           int cmd, struct file_lock *fl)
>> {
>>         int ret = 0, level = 0, trylock = 0;
>>         struct ocfs2_file_private *fp = file->private_data;
>>         struct ocfs2_lock_res *lockres = &fp->fp_flock;
>>
>>         if (fl->fl_type == F_WRLCK)
>>                 level = 1;
>>         if (!IS_SETLKW(cmd))
>>                 trylock = 1;
>>
>>         mutex_lock(&fp->fp_mutex);
>>
>>         if (lockres->l_flags & OCFS2_LOCK_ATTACHED &&
>>             lockres->l_level > LKM_NLMODE) {
>>                 int old_level = 0;
>>
>>                 if (lockres->l_level == LKM_EXMODE)
>>                         old_level = 1;
> 
> Hmm, we shouldn't really be using LKM_* constants any more. This must have
> slipped past me in the last merge. There shouldn't be any real problem
> though since each dlm uses the same values for the locking mode constants.
> Still, we should fix this. There also seems to be some debug stuff in
> dlmglue.c which is doing this too.

So what we are using to replace LKM_* right now ?
> 
> 
>>                 if (level == old_level)
>>                         goto out;
>> -----------
>> Question: when level and oldlevel are not (0 and 0) or (1 and 1), I don't see any code does dlm lock
>> compatibility logic. I don't undersand why the code here can try to unlock directly.
>>
>> -----------
> 
> It's just as the below comment says - flock conversion between two modes is
> not guaranteed to be atomic. The easiest method for us to deal with these
> sorts of requests then, is to simply unlock and relock at the new level.
> From the flock man page:
> 
>        Converting a lock (shared to exclusive, or vice versa) is  not guaran-
>        teed  to  be atomic: the existing lock is first removed, and then a new
>        lock is established.
> 
> Dealing with upconversion and downconversion of locks at the distributed
> locking level is rather complex. Enough so that it's only worth the effort
> on locks which really need it.
> 
If the resource is PR locked by other holder, a caller wants to hold a CR lock, does it means the
caller should wait for the resource to be unlocked firstly ?
Is this what confused me here.

> 
>>                 /*
>>                  * Converting an existing lock is not guaranteed to be
>>                  * atomic, so we can get away with simply unlocking
>>                  * here and allowing the lock code to try at the new
>>                  * level.
>>                  */
>>
>>                 flock_lock_file_wait(file,
>>                                      &(struct file_lock){.fl_type = F_UNLCK});
>>
>>                 ocfs2_file_unlock(file);
>>         }
>> [snip]
>> }


-- 
Coly Li
SuSE PRC Labs
