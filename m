From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 15 Feb 2012 20:31:59 -0000
Subject: [Ocfs2-devel] Ocfs2/move_extents: move/defrag extents within a
	certain range.
Message-ID: <20120215203151.GA17399@elgon.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Tristan Ye,

This is a semi-automatic email about new static checker warnings.

The patch 53069d4e7695: "Ocfs2/move_extents: move/defrag extents 
within a certain range." from May 25, 2011, leads to the following 
Smatch complaint:

fs/ocfs2/move_extents.c:980 ocfs2_move_extents()
	 warn: variable dereferenced before check 'inode' (see line 978)

fs/ocfs2/move_extents.c
   977		struct buffer_head *di_bh = NULL;
   978		struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
                                                   ^^^^^^^^^^^
Dereference.

   979	
   980		if (!inode)
                    ^^^^^^
Check.

   981			return -ENOENT;
   982	

regards,
dan carpenter
