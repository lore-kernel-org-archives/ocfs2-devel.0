From: Herbert Poetzl <herbert@13thfloor.at>
Date: Sat, 10 Jun 2006 14:32:53 +0200
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
Message-ID: <20060610123253.GA23924@MAIL.13thfloor.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hey Mark! Hey Kurt!

did a first hack on adding the iattrs (ext2)
to OCFS2. it is currently for Linux-VServer
patched kernels and I need to clean it up a
little more (and of course test it), but I
thought I'd ask you folks what you think about
the general idea and the implementation.

here is a link to the patch, if there is some
interest from your side, I'll prepare one for
mainline ...

http://vserver.13thfloor.at/Experimental/delta-ocfs2-feat01.diff

note: some attributes (like the noatime) do
not (yet) make sense for OCFS2, It's just a
generic approach ... 

please ignore the ocfs2_sync_flags, it's only
used in Linux-VServer for now ...

TIA,
Herbert
