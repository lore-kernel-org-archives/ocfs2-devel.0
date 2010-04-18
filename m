From: Dan Carpenter <error27@gmail.com>
Date: Sun, 18 Apr 2010 19:32:13 -0000
Subject: [Ocfs2-devel] ocfs2: question about dlmfs_file_read()
Message-ID: <20100418193201.GD7920@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello list,

I was looking through the code for something unrelated and I got
confused by this.

fs/ocfs2/dlmfs/dlmfs.c dlmfs_file_read()
   261          /* don't read past the lvb */
   262          if ((count + *ppos) > i_size_read(inode))
   263                  readlen = i_size_read(inode) - *ppos;
   264          else
   265                  readlen = count - *ppos;

	Shouldn't "readlen" just be "count" here?  What prevents it from 
	being a negative number?

   266
   267          lvb_buf = kmalloc(readlen, GFP_NOFS);

Anyway, this code has been around for a long time so I'm probably
missing something.  I was just curious.

regards,
dan carpenter
