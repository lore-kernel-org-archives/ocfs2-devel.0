From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Aug 18 00:15:47 2004
Subject: [Ocfs2-devel] [Patch] fix bug 130 & 131 
Message-ID: <3ACA40606221794F80A5670F0AF15F840538806F@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


-------------------------------------------------------------------------=
-------------------------
Index: namei.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- namei.c (revision 1360)
+++ namei.c (working copy)
@@ -429,7 +429,12 @@
    fe->i_suballoc_blkno =3D fileOffset >> osb->sb->s_blocksize_bits;
    fe->i_suballoc_node =3D osb->node_num;
    fe->i_uid =3D current->fsuid;
-   fe->i_gid =3D current->fsgid;
+   if (dir->i_mode & S_ISGID) {
+       fe->i_gid =3D dir->i_gid;
+       if (S_ISDIR(mode))
+           mode |=3D S_ISGID;
+   } else
+       fe->i_gid =3D current->fsgid;
    fe->i_mode =3D mode;
    if (S_ISCHR (mode) || S_ISBLK (mode))
        fe->id1.dev1.i_rdev =3D huge_encode_dev(dev);

>-----Original Message-----
>From: Ling, Xiaofeng=20
>Sent: 2004=C4=EA8=D4=C218=C8=D5 9:57
>To: Ling, Xiaofeng; ocfs2-devel@oss.oracle.com
>Subject: [BUG] LTP:mkdir try to inherits S_ISGID failed
>
>This bug has the same reproduce step as below.
>the dir2 has no S_ISGID set. see bug 131.
>
>>-----Original Message-----
>>From: ocfs2-devel-bounces@oss.oracle.com=20
>>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of=20
>Ling, Xiaofeng
>>Sent: 2004=C4=EA8=D4=C218=C8=D5 9:45
>>To: ocfs2-devel@oss.oracle.com
>>Subject: [Ocfs2-devel] [BUG] LTP:mkdir try to inherits group id failed
>>
>>LTP test case mkdir02 failed.This time, it is not LTP bug. see bug 130
>>You can reproduce it manually:
>>with root
>>1. mkdir dir1
>>2. chmod ugo+w dir1
>>3.chmod g+s dir1
>> with another user user1 and group group1
>>4. cd dir1
>>5. mkdir dir2
>>6.ls -l dir2
>>The group id is group1, not root. While in ext3, it is root.
>>
>>
>>
>>-------------------
>>Intel China Software Lab.
>>iNet: 8-752-1243
>>8621-52574545-1243(O)
>>503-712-6740(Temp)
>>
>>xfling@users.sourceforge.net
>>Opinions are my own and don't represent those of my employer=20
>>_______________________________________________
>>Ocfs2-devel mailing list
>>Ocfs2-devel@oss.oracle.com
>>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>
