From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 14 Oct 2008 13:54:58 -0700
Subject: [Ocfs2-devel] [RFC] Inode block reads
Message-ID: <20081014205458.GB8025@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,
	Attached are the two patches making inode block reads a
dedicated function and cleaning up the haphazard error checking
associated with the old style.  I'd love a quick once-over on the
approach before I go after the other metadata types.  Just a quick "that
works" or "don't do it that way you fool!" will suffice ;-)

Joel

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Wrap-inode-block-reads-in-a-dedicated-functio.patch
Type: text/x-diff
Size: 18312 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081014/d2ca2dd2/attachment-0002.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0002-ocfs2-Morph-the-haphazard-OCFS2_IS_VALID_DINODE-c.patch
Type: text/x-diff
Size: 8503 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081014/d2ca2dd2/attachment-0003.bin 
