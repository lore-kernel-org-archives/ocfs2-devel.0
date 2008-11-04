From: Coly Li <coyli@suse.de>
Date: Tue, 04 Nov 2008 18:52:30 +0800
Subject: [Ocfs2-devel] question of ocfs2_do_flock()
Message-ID: <4910296E.4080301@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi list,

These days I am working on a L3 bug on SLES10 SP2. When I read ocfs2_do_flock(), there are some
questions from me. Wish anybody can give me a little hint to understand the code. Thanks.



static int ocfs2_do_flock(struct file *file, struct inode *inode,
                          int cmd, struct file_lock *fl)
{
        int ret = 0, level = 0, trylock = 0;
        struct ocfs2_file_private *fp = file->private_data;
        struct ocfs2_lock_res *lockres = &fp->fp_flock;

        if (fl->fl_type == F_WRLCK)
                level = 1;
        if (!IS_SETLKW(cmd))
                trylock = 1;

        mutex_lock(&fp->fp_mutex);

        if (lockres->l_flags & OCFS2_LOCK_ATTACHED &&
            lockres->l_level > LKM_NLMODE) {
                int old_level = 0;

                if (lockres->l_level == LKM_EXMODE)
                        old_level = 1;

                if (level == old_level)
                        goto out;
-----------
Question: when level and oldlevel are not (0 and 0) or (1 and 1), I don't see any code does dlm lock
compatibility logic. I don't undersand why the code here can try to unlock directly.

-----------

                /*
                 * Converting an existing lock is not guaranteed to be
                 * atomic, so we can get away with simply unlocking
                 * here and allowing the lock code to try at the new
                 * level.
                 */

                flock_lock_file_wait(file,
                                     &(struct file_lock){.fl_type = F_UNLCK});

                ocfs2_file_unlock(file);
        }
[snip]
}

Thanks in advance.
-- 
Coly Li
SuSE PRC Labs
