From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug 19 01:02:30 2004
Subject: [Ocfs2-devel] found a subdir with link=1
Message-ID: <3ACA40606221794F80A5670F0AF15F8405388DB1@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I've found the reproduce way, I've submit bug 132 "link for directory =
does not change after mv subdir to another".=20

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Ling, Xiaofeng
>Sent: 2004=C4=EA8=D4=C26=C8=D5 8:06
>To: Ocfs2-Devel
>Subject: [Ocfs2-devel] found a subdir with link=3D1
>
>I found a subdir with link=3D1, in my ocfs2 file system.
>It is a empty directory, so the link should equal to 2, but=20
>now it is 1.
>So I can not remove it. I can not remember what kind of operations I do
>that cause this directory, but there shall be a bug inside the driver.
>Anyone found the same problem?
>My ocfs is svn 1331.
>
>-------------------
>Intel China Software Lab.
>iNet: 8-752-1243
>021-52574545-1243(O)
>xfling@users.sourceforge.net
>Opinions are my own and don't represent those of my employer=20
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
