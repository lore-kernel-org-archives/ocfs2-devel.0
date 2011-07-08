From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 8 Jul 2011 10:31:16 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: let ocfs2_dir_foreach return
 the error turned by filldir
In-Reply-To: <20110708020756.GC3013@laptop.jp.oracle.com>
References: <201107060539.p665dfRB020547@acsmt356.oracle.com>
	<4E161267.8050000@oracle.com>
	<20110708020756.GC3013@laptop.jp.oracle.com>
Message-ID: <20110708023116.GB9895@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-07-08 10:07, Wengang Wang wrote:
> On 11-07-07 13:09, Sunil Mushran wrote:
> > On 07/05/2011 09:40 PM, Wengang Wang wrote:
> > >Let ocfs2_dir_foreach return the error turned by filldir.
> > >
> > >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> > >---
> > >  fs/ocfs2/dir.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > >diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > >index 8582e3f..6d7560a 100644
> > >--- a/fs/ocfs2/dir.c
> > >+++ b/fs/ocfs2/dir.c
> > >@@ -2005,6 +2005,8 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
> > >
> > >  	if (ret>  0)
> > >  		ret = -EIO;
> > >+	if (!ret)
> > >+		ret = filldir_err;
> > >
> > >  	return 0;

I meant "return ret" here.

> > >  }
> > 
> > That's not enough. Shouldn't it be "return ret" too.
> 
> If neccesary, We can return both ret and filldir_err.
> > 
> > Have you triggered this error manually? I have never seen reports of it
> > before.
> 
> No error here. This change is only needed for the following patch:
> [PATCH 3/3] ocfs2: drop and retake orphan_dir.i_mutex in ocfs2_recover_orphans.
> 
> thanks,
> wengang.
