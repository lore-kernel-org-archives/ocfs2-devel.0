From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed May 26 20:16:04 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
Message-ID: <20040527011601.GH25513@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For the last couple of weeks we've been making some important format changes
for OCFS2. We're not done yet, but much of it is in a state where we feel it
can be merged back into trunk and played with. There are bugs, and there
will be more disk format changes, but at least now others can pitch in.

You will absolutely have to reformat your filesystems after picking up this
revision (946). The userspace tools aren't as ready for ocfs-tools trunk yet
though, so you'll need to pick up the new-dir-format branch of ocfs-tools
and use that to create ocfs2 file systems.

$ svn co http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/ ocfs-tools

Those of you who have read the ext3 code might find some of this new stuff
familiar. This is because we've finally done away with our dirnode
structures and gone to something a little less... broken :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
