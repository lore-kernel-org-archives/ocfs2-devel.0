From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Apr  7 23:56:23 2004
Subject: [Ocfs2-devel] Is hardlink support in the todo list?
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8403E42EE4@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8403E42EE4@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040408045617.GB32526@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

It is currently not planned for version 2, but it would not be too
difficult to implement.  With recent changes to inode handling this is
made much easier.  The best approach based on the disk structure that is
already there would be to have the first file entry be the "master" for
the hardlink, and all other names which are added later would have a
pointer back to this file entry.  We have flags in the fs already for
handling the case where the master is deleted (marking it so as not to
show up in readdir).  Would just need to do some refcounting on the
master to do final cleanup.  Renames would be just like they are today
for regular files, but would just need to migrate the "master" pointer
to the new file entry instead of the data pointers.

If anyone feels like implementing this (hint hint ;-) we can discuss the
specifics further.

Thanks!
-kurt

On Thu, Apr 08, 2004 at 10:46:43AM +0800, Ling, Xiaofeng wrote:
> Hi,
>      It seems currently hardlink is not support by ocfs2,  is it planned
> to do?
> Is it possible for the current ocfs format?
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
