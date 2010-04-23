From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 15:27:17 -0700
Subject: [Ocfs2-devel] ocfs2: question about dlmfs_file_read()
In-Reply-To: <4BD21A00.3020205@oracle.com>
References: <20100418193201.GD7920@bicker>
	<20100423205037.GC10637@mail.oracle.com>
	<4BD21A00.3020205@oracle.com>
Message-ID: <20100423222716.GF8330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 23, 2010 at 03:06:56PM -0700, Sunil Mushran wrote:
> Joel Becker wrote:
> > On Sun, Apr 18, 2010 at 10:32:01PM +0300, Dan Carpenter wrote:
> >   
> >> Hello list,
> >>
> >> I was looking through the code for something unrelated and I got
> >> confused by this.
> >>
> >> fs/ocfs2/dlmfs/dlmfs.c dlmfs_file_read()
> >>    261          /* don't read past the lvb */
> >>    262          if ((count + *ppos) > i_size_read(inode))
> >>    263                  readlen = i_size_read(inode) - *ppos;
> >>    264          else
> >>    265                  readlen = count - *ppos;
> >>
> >> 	Shouldn't "readlen" just be "count" here?  What prevents it from 
> >> 	being a negative number?
> >>
> >>    266
> >>    267          lvb_buf = kmalloc(readlen, GFP_NOFS);
> >>
> >> Anyway, this code has been around for a long time so I'm probably
> >> missing something.  I was just curious.
> >>     
> >
> > 	No, I think you're right.  Mark, Sunil, anyone?
> 
> Nod.

	Ok, I've pushed this fix to the 'fixes' branch of ocfs2.git.

Joel

From a36d515c7a2dfacebcf41729f6812dbc424ebcf0 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 23 Apr 2010 15:24:59 -0700
Subject: [PATCH] ocfs2_dlmfs: Fix math error when reading LVB.

When asked for a partial read of the LVB in a dlmfs file, we can
accidentally calculate a negative count.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index a99d1ea..b83d610 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -262,7 +262,7 @@ static ssize_t dlmfs_file_read(struct file *filp,
 	if ((count + *ppos) > i_size_read(inode))
 		readlen = i_size_read(inode) - *ppos;
 	else
-		readlen = count - *ppos;
+		readlen = count;
 
 	lvb_buf = kmalloc(readlen, GFP_NOFS);
 	if (!lvb_buf)
-- 
1.7.0.4

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
