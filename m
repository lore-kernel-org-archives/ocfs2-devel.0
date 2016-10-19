From: Eric Ren <zren@suse.com>
Date: Wed, 19 Oct 2016 13:19:40 +0800
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take inode lock
	in ocfs2_iop_set/get_acl()"? or other ideas?
Message-ID: <1476854382-28101-1-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all!

Commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
results in another deadlock as we have discussed in the recent thread:
    https://oss.oracle.com/pipermail/ocfs2-devel/2016-October/012454.html

Before this one, a similiar deadlock has been fixed by Junxiao:
    commit c25a1e0671fb ("ocfs2: fix posix_acl_create deadlock")
    commit 5ee0fbd50fdf ("ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang")

We are in the situation that we have to avoid recursive cluster locking, but
there is no way to check if a cluster lock has been taken by a precess already.

Mostly, we can avoid recursive locking by writing code carefully. However, as
the deadlock issues have proved out, it's very hard to handle the routines
that are called directly by vfs. For instance:

    const struct inode_operations ocfs2_file_iops = {
            .permission     = ocfs2_permission,
            .get_acl        = ocfs2_iop_get_acl,
            .set_acl        = ocfs2_iop_set_acl,
    };


ocfs2_permission() and ocfs2_iop_get/set_acl() both call ocfs2_inode_lock().
The problem is that the call chain of ocfs2_permission() includes *_acl().

Possibly, there are three solutions I can think of.  The first one is to
implement the inode permission routine for ocfs2 itself, replacing the
existing generic_permission(); this will bring lots of changes and
involve too many trivial vfs functions into ocfs2 code. Frown on this.

The second one is, what I am trying now, to keep track of the processes who
lock/unlock a cluster lock by the following draft patches. But, I quickly
find out that a cluster locking which has been taken by processA can be unlocked
by processB. For example, systemfiles like journal:0000 is locked during mout, and
unlocked during umount. 

The thrid one is to revert that problematic commit! It looks like get/set_acl()
are always been called by other vfs callback like ocfs2_permission(). I think
we can do this if it's true, right? Anyway, I'll try to work out if it's true;-)

Hope for your input to solve this problem;-)

Thanks,
Eric
