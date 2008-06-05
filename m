From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu, 05 Jun 2008 09:28:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: check return value
	of	ocfs2_journal_load()
In-Reply-To: <48475501.9090904@oracle.com>
References: <48475501.9090904@oracle.com>
Message-ID: <48481440.5060808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang,

Thanks. The patch looks good.

However, please can you respin the patch for mainline. As we have now
have a 1.4 tree too, inorder to ensure that we don't miss any patches,
we want all patches to hit mainline before trickling down to 1.2/1.4.
And as this is a bugfix, we should be able to push this in before
2.6.26 is released.

Sunil

wengang wang wrote:
> we should check the return value of ocfs2_journal_load() before going on.
> this patch is based on 1.2 svn, but mainline git should has the same fix.
>
> Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
> ---
> super.c |    6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
