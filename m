From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Nov 2017 16:46:42 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: The goto is not useful in the
 function ocfs2_reserve_cluster_bitmap_bits, so remove it.
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7B2EF@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4F3CDE3A9@H3CMLB14-EX.srv.huawei-3com.com>
	<63ADC13FD55D6546B7DECE290D39E373CED7B2EF@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <20171115164642.b1437a59be5bd46a4e6d258e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 16 Nov 2017 00:42:09 +0000 Changwei Ge <ge.changwei@h3c.com> wrote:

> Hi Zhonghua,
> On 2017/11/15 20:04, Guozhonghua wrote:
> > The goto is not useful anymore, removed from the context.
> 
> Perhaps we can make this change-log more clear like:
> The bail declare is not necessary any more, so trim it. If code path 
> falls into error branch, ocfs2_reserve_cluster_bitmap_bits will return 
> in next following step, too.
> 
> And this title can be changed into 'ocfs2: clean up unnecessary bail 
> declare'
> 
> I suppose after that this patch will be neater.
> 
> Can you resend this patch?
> Moreover, I think we should also CC this patch to OCFS2 maintainers.

The patch is OK.  I reworked it as below.  It's so obvious that no changelog
is needed.


From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: remove unneeded goto in ocfs2_reserve_cluster_bitmap_bits()

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_71604351584F6A4EBAE558C676F37CA4F3CDE3A9-40H3CMLB14-2DEX.srv.huawei-2D3com.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=lcqqp5PvLSjaJ5MT6uqUC9J6gAhx8KP5Fd62d4ii4BA&s=KqlZy8JoC39DDT5b_TM6C12Vtg7AZhEE0QsYSC9ZJ30&e=
Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it
+++ a/fs/ocfs2/suballoc.c
@@ -1147,12 +1147,9 @@ int ocfs2_reserve_cluster_bitmap_bits(st
 					     GLOBAL_BITMAP_SYSTEM_INODE,
 					     OCFS2_INVALID_SLOT, NULL,
 					     ALLOC_NEW_GROUP);
-	if (status < 0 && status != -ENOSPC) {
+	if (status < 0 && status != -ENOSPC)
 		mlog_errno(status);
-		goto bail;
-	}
 
-bail:
 	return status;
 }
 
_
