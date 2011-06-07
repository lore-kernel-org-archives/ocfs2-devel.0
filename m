From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 7 Jun 2011 10:41:42 -0500
Subject: [Ocfs2-devel] Do filesystem need to turn RO on dx corruptions?
Message-ID: <BANLkTikh_cV_AHYR-nDJC_V5zzt8AEnGvA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

There have been index tree corruptions, where the directory entries
are correct however the index directory is not. In this case, the
filesystem turns read-only where as all the information to complete
the operation is still available because the primary directory
structure is sane. The ocfs2 module could just disable indexed
directory for this directory and continue handling the operation like
the normal directories without indexes. Of course, it still writes the
warning message, to run fsck, to the kernel log  but avoid the RO
filesystem which halt all I/O writes.

Th ocfs2-tools fix is posted at:
http://oss.oracle.com/pipermail/ocfs2-tools-devel/2011-May/003812.html
However, it would need changes for indexed directory rebuilds.

Let me know what you think.

-- 
Goldwyn
