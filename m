From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Feb  2 17:17:00 2004
Subject: [Ocfs2-devel] RE: [Ocfs2-users] RE: Playing with OCFS2
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A56872@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Enclosed please find a patch which fixes the issue I had.

The root cause is that spin_trylock will always return 1 on a
Uniprocessor (UP) system.

It appears the code in this case had an assumption of a SMP system.  The
spin_trylock appears to be used as a debugging mechanism to make sure
that a lock had been previously made before the function was called.

My patch is just to use the #ifdef CONFIG_SMP but I think that this may
go against the kernel guidelines but I am not sure.

John
-------------- next part --------------
A non-text attachment was scrubbed...
Name: up-fix.diff
Type: application/octet-stream
Size: 565 bytes
Desc: up-fix.diff
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040202/6edf6c6f/up-fix.obj
