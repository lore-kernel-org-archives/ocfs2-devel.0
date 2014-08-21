From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Aug 2014 14:58:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: delete double assignment
In-Reply-To: <20140728152632.GA2926@himangi-Dell>
References: <20140728152632.GA2926@himangi-Dell>
Message-ID: <20140821145844.a661662c0823ec930ae39a6f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr

On Mon, 28 Jul 2014 20:56:32 +0530 Himangi Saraogi <himangi774@gmail.com> wrote:

> Delete successive assignments to the same location. The two assignments are
> simply identical.
> 
> A simplified version of Coccinelle semantic match that finds this problem is as
> follows:
> 
> // <smpl>
> @@
> expression i;
> @@
> 
> *i = ...;
>  i = ...;
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> Should the fist assignment be initializing the pv_minor field?

I'd say so, yes.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/ocfs2/stack_user.c: fix typo in ocfs2_control_release()

It is supposed to zero pv_minor.

Reported-by: Himangi Saraogi <himangi774@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release
+++ a/fs/ocfs2/stack_user.c
@@ -591,7 +591,7 @@ static int ocfs2_control_release(struct
 		 */
 		ocfs2_control_this_node = -1;
 		running_proto.pv_major = 0;
-		running_proto.pv_major = 0;
+		running_proto.pv_minor = 0;
 	}
 
 out:
_
