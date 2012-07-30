From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Mon, 30 Jul 2012 10:22:13 -0700
Subject: [Ocfs2-devel] [patch] ocfs2/dlm: use GFP_ATOMIC inside a
	spin_lock
In-Reply-To: <20120727203233.GB11126@wotan.suse.de>
References: <20120726130505.GA30865@elgon.mountain>
	<20120727203233.GB11126@wotan.suse.de>
Message-ID: <CAEeiSHXWy+dC5U_DH+MpG-8gyYRwhQg7Z0hERxQQk7_6OXPEFA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 27, 2012 at 1:32 PM, Mark Fasheh <mfasheh@suse.de> wrote:

> On Thu, Jul 26, 2012 at 04:05:05PM +0300, Dan Carpenter wrote:
> > My static checker complains that this is called with a spin_lock held
> > in dlm_master_requery_handler() from dlmrecovery.c.  Probably the reason
> > we have not received any bug reports about this is that recovery is not
> > a common operation.
>
> Looks reasonable to me. Sunil, we might just want to have that
> dlm_work_item
> allocated by the caller, yes?
>


My static checker complains that this is called with a spin_lock held
in dlm_master_requery_handler() from dlmrecovery.c.  Probably the reason
we have not received any bug reports about this is that recovery is not
a common operation.

Signed-off-by: Dan Carpenter <dan.carpenter@xxxxxxxxxx>

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..33ecbe0 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2020,7 +2020,7 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 			       int ignore_higher, u8 request_from, u32 flags)
 {
 	struct dlm_work_item *item;
-	item = kzalloc(sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_ATOMIC);
 	if (!item)
 		return -ENOMEM;

--




I don't think the caller needs to hold the lockres spinlock. But this will
do too.

Yes, this is rare because this gets triggered only if a node that is
migrating
ownership (to or from) dies before migration completes. This part of the
code
is any case shaky as best as it is hard to test all cases.

Sunil
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120730/26e1b515/attachment.html 
