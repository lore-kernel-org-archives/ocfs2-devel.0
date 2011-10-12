From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 12 Oct 2011 15:10:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Commit transactions in error cases.
In-Reply-To: <4E947E51.2040401@oracle.com>
References: <201109250913.p8P9DPGZ032059@acsmt356.oracle.com>
	<4E947E51.2040401@oracle.com>
Message-ID: <20111012071044.GB11852@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-10-11 10:35, Sunil Mushran wrote:
> The first two are ok. Have a comment for the last one.
> 
> On 09/25/2011 02:13 AM, Wengang Wang wrote:
> >Commit transactions in error cases.
> >
> >There are three cases found that in error cases, journal transactions are not
> >committed nor aborted. We should take care of these case by committing the
> >transactions. Otherwise, there would left a journal handle which will lead to
> >, in same process context, the comming ocfs2_start_trans() gets wrong credits.
> >
> >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
<snip>
> >@@ -2376,12 +2376,12 @@ static int ocfs2_remove_value_outside(struct inode*inode,
> >  		}
> >
> >  		ret = ocfs2_xattr_value_truncate(inode, vb, 0,&ctxt);
> >+		ocfs2_commit_trans(osb, ctxt.handle);
> >  		if (ret<  0) {
> >  			mlog_errno(ret);
> >  			break;
> >  		}
> >
> >-		ocfs2_commit_trans(osb, ctxt.handle);
> >  		if (ctxt.meta_ac) {
> >  			ocfs2_free_alloc_context(ctxt.meta_ac);
> >  			ctxt.meta_ac = NULL;
> 
>  		ret = ocfs2_xattr_value_truncate(inode, vb, 0,&ctxt);
> - 		if (ret<  0) {
> - 			mlog_errno(ret);
> - 			break;
> - 		}
> 
> 		ocfs2_commit_trans(osb, ctxt.handle);
>  		if (ctxt.meta_ac) {
>  			ocfs2_free_alloc_context(ctxt.meta_ac);
>  			ctxt.meta_ac = NULL;
> 
> + 		if (ret<  0) {
> + 			mlog_errno(ret);
> + 			break;
> + 		}
> 
> 
> I don't like the commit_trans() shoe horned. The above reads cleaner imo.

Agree.

thanks,
wengang.
