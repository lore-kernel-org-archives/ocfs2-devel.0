From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed May 26 22:26:57 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
Message-ID: <3ACA40606221794F80A5670F0AF15F8404737CF4@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Is there any simple description about the changes of the format?=20
Are there still 8 system files. Is the file entry still store in =
DirNode?

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
>Sent: 2004=C4=EA5=D4=C227=C8=D5 9:16
>To: ocfs2-devel@oss.oracle.com=20
>Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
>
>For the last couple of weeks we've been making some important=20
>format changes
>for OCFS2. We're not done yet, but much of it is in a state=20
>where we feel it
>can be merged back into trunk and played with. There are bugs,=20
>and there
>will be more disk format changes, but at least now others can pitch in.
>
>You will absolutely have to reformat your filesystems after=20
>picking up this
>revision (946). The userspace tools aren't as ready for=20
>ocfs-tools trunk yet
>though, so you'll need to pick up the new-dir-format branch of=20
>ocfs-tools
>and use that to create ocfs2 file systems.
>
>$ svn co=20
>http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-
>format/ ocfs-tools
>
>Those of you who have read the ext3 code might find some of=20
>this new stuff
>familiar. This is because we've finally done away with our dirnode
>structures and gone to something a little less... broken :)
>	--Mark
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
