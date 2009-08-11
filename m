From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 11 Aug 2009 15:09:15 -0700
Subject: [Ocfs2-devel] Why do we read the blocks in
	__ocfs2_xxattr_set_value_outside()?
Message-ID: <20090811220915.GF28478@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

	In __ocfs2_xattr_set_value_outside(), we walk each block of the
xattr value and read it before we copy the new data on top and dirty it.
Why are we reading the block from disk if we're just overwriting it?
Would't "sb_getblk(); ocfs2_set_buffer_uptodate()" work better?

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
