From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 24 Sep 2008 16:01:46 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add posix ACL support in ocfs2
 v1
In-Reply-To: <20080923071118.GV4563@wotan.suse.de>
References: <48D3725A.1030701@oracle.com>
	<1221817381-11133-1-git-send-email-tiger.yang@oracle.com>
	<20080923071118.GV4563@wotan.suse.de>
Message-ID: <48D9F3EA.9090205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Mark,

Mark Fasheh wrote:
> I think we also need some acl-specific handling of chmod in ocfs2_setattr.
> See ext3_acl_chmod, where it's called and what it does.
OK. I will add it later after learning ext3.

> Err, this is a pretty bad place for a call which must do work only if we're
> succesfull in creating the inode. A better place would be a few lines up,
> maybe even just before the call to 'ocfs2_add_entry()', so that an acl
> failure won't result in a non-acl-copied inode which is accessible from a
> directory.
I put this function here because ocfs2_xattr_set need start transaction.
So I put it after commit transaction.

To avoid the issue you mentioned, I modify it to the following
-       status = ocfs2_init_acl(inode, dir);
+       if (!status) {
+               if (ocfs2_init_acl(inode, dir))
+                       mlog(0, "Init acl error\n");
+       }
is this acceptable?

> Same as before about the #ifdef's, and adding a proper Kconfig item for
> this.
No problem.

Best regards,
tiger
