From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri May 28 13:37:53 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED6@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	Do you plan to add more format changes to the OCFS2 recently?=20

	We are now working on stabilize the OCFS2 on top of IPF and kernel 2.6. =
We hope we can get a stable release for kernel 2.4 and IA32. What's your =
plan?

	Thanks.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com =
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
Sent: 2004=C4=EA5=D4=C226=C8=D5 18:16
To: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946

For the last couple of weeks we've been making some important format =
changes
for OCFS2. We're not done yet, but much of it is in a state where we =
feel it
can be merged back into trunk and played with. There are bugs, and there
will be more disk format changes, but at least now others can pitch in.

You will absolutely have to reformat your filesystems after picking up =
this
revision (946). The userspace tools aren't as ready for ocfs-tools trunk =
yet
though, so you'll need to pick up the new-dir-format branch of =
ocfs-tools
and use that to create ocfs2 file systems.

$ svn co =
http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/ =
ocfs-tools

Those of you who have read the ext3 code might find some of this new =
stuff
familiar. This is because we've finally done away with our dirnode
structures and gone to something a little less... broken :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
