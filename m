From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Aug  3 20:51:43 2004
Subject: [Ocfs2-devel] Invalid file rights
Message-ID: <B44D37711ED29844BEA67908EAF36F037BB933@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah. You are right.

I take it for granted that a file will be granted some default rights =
for its owner, such as read/write, when it is created with =
open(...,...|O_CREAT) .
I traced the source code of ocfs2 and found the kernel return a mode =
8000 really that means nobody can access the file. Also, I checked it =
with ext3 filesystem and got the same results.

So, I think it is nature and it is not a bug yet.
Thanx.

Aaron

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA8=D4=C24=C8=D5 2:49
To: Chen, Yukun
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Invalid file rights

On Tue, Aug 03, 2004 at 03:25:42PM +0800, Chen, Yukun wrote:
> Hi All
>=20
> I find a file rights bug on kernel 2.4 with svn 1313 code. Steps to
> duplicate
>=20
> Being root, create a file in a ocfs2 partition with the sentence below
>=20
>  open(filename, O_CREAT | O_RDWR )
>=20
> Then the file will be created with a right 000 --- nobody can =
write/read
> it at all.=20
Right, and we get the mode from the kernel for this, right? Is there =
some
policy which we're missing? In ocfs_mknod_locked we do "fe->i_mode =3D =
mode;"
so it's definitely being set on disk. later on we also do "inode->i_mode =
=3D
mode;".

> But, if I use "touch filename" , the file will be created with a right
> of 644.
Well, that'd be because:

[mfasheh@expo ocfs2]$ strace touch file
<snip>
open("file", O_WRONLY|O_NONBLOCK|O_CREAT|O_NOCTTY|O_LARGEFILE, 0666) =3D =
3
<snip>

So that's "touch" setting the mode there.
=20
> Any ideas on it? (a bug # 113 has been reported to oss.oracle.com
> bugzilla)
So the "touch" case is obvious, but I'm not sure that the 1st one is a =
bug
either... If it is, please explain why.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
