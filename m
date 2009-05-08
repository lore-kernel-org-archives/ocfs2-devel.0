From: jim owens <jowens@hp.com>
Date: Thu, 07 May 2009 22:59:04 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090507221535.GA31624@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com>
Message-ID: <4A039FF8.7090807@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, joel.becker@oracle.com
Cc: linux-fsdevel@vger.kernel.org

Joel Becker wrote:
> Hi again,
> 	Here's version 2 of reflink.  Changes since the first version:
> 
> - One patch, not three.
> - Documentation/filesystems/reflink.txt is no longer a pseudo-manpage.
>   It also tries to encapsulate all the feedback from the discussion to
>   make the operation clearer.

You certainly did not address:

- desire for one single system call to handle both
   owner preservation and create with current owner.

   I see no reason to have 2 vfs_xxx and 2 inode functions for those.

- please just add the flag to the defined reflink API...
   there is no reason to keep saying "it is just like link(2)".
   that not true and you will just cause confusion.

- fix the
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;

   to be an ISREG check unless you have an argument for
   special files and symlinks being COWed.

jim
