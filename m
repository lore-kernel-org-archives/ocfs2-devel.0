From: Eric Ren <zren@suse.com>
Date: Wed, 9 Nov 2016 12:47:13 +0800
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take inode
 lock in ocfs2_iop_set/get_acl()"? or other ideas?
In-Reply-To: <1476854382-28101-1-git-send-email-zren@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
Message-ID: <d861b8e8-7dc1-a0fc-98fb-c0ef7a3a4a86@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

On 10/19/2016 01:19 PM, Eric Ren wrote:
> ocfs2_permission() and ocfs2_iop_get/set_acl() both call ocfs2_inode_lock().
> The problem is that the call chain of ocfs2_permission() includes *_acl().
>
> Possibly, there are three solutions I can think of.  The first one is to
> implement the inode permission routine for ocfs2 itself, replacing the
> existing generic_permission(); this will bring lots of changes and
> involve too many trivial vfs functions into ocfs2 code. Frown on this.
>
> The second one is, what I am trying now, to keep track of the processes who
> lock/unlock a cluster lock by the following draft patches. But, I quickly
> find out that a cluster locking which has been taken by processA can be unlocked
> by processB. For example, systemfiles like journal:0000 is locked during mout, and
> unlocked during umount.
We can avoid the problem above by:

1) not keeping track of system file inode:

    if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)) {
        ....
   }

2) only keeping track of inode metadata lockres:

    OCFS2_I(inode)->ip_inode_lockres;

because inode open lockres can also be get/release by different processes.

Eric
>
> The thrid one is to revert that problematic commit! It looks like get/set_acl()
> are always been called by other vfs callback like ocfs2_permission(). I think
> we can do this if it's true, right? Anyway, I'll try to work out if it's true;-)
>
> Hope for your input to solve this problem;-)
>
> Thanks,
> Eric
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161109/df737ced/attachment.html 
