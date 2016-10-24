From: Eric Ren <zren@suse.com>
Date: Mon, 24 Oct 2016 17:13:14 +0800
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take inode
 lock in ocfs2_iop_set/get_acl()"? or other ideas?
In-Reply-To: <1476854382-28101-1-git-send-email-zren@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
Message-ID: <80bd0df3-d704-536e-d69a-59eb0279d829@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,


On 10/19/2016 01:19 PM, Eric Ren wrote:
> The thrid one is to revert that problematic commit! It looks like get/set_acl()
> are always been called by other vfs callback like ocfs2_permission(). I think
> we can do this if it's true, right? Anyway, I'll try to work out if it's true;-)
After looking into more, I get to know get/set_acl() can be invoked 
directly from vfs,
for instance:

fsetxattr()
  setxattr()
    vfs_setxattr()
      __vfs_setxattr()
        handler->set(handler, dentry, inode, name, value, size) // 
posix_acl_access_xattr_handler.set = posix_acl_xattr_set
          posix_acl_xattr_set()
             set_posix_acl()
               inode->i_op->set_acl()


So, this problem looks really hard to solve:-/

Eric

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
