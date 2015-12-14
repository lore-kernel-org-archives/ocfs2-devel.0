From: Eric Ren <zren@suse.com>
Date: Mon, 14 Dec 2015 16:57:01 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
In-Reply-To: <566E5BA5.5030308@oracle.com>
References: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
	<566EC6A8020000F90002219D@relay2.provo.novell.com>
	<566E5BA5.5030308@oracle.com>
Message-ID: <20151214085701.GB7837@desktop.lab.bej.apac.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Mon, Dec 14, 2015 at 02:03:17PM +0800, Junxiao Bi wrote: 
> On 12/14/2015 01:39 PM, Gang He wrote:
> > Hello Junxiao,
> > 
> > From the initial description, the second lock_XYZ(PR) should be blocked, since DLM have a fair queue  mechanism, otherwise, it looks to bring a write lock starvation.
> Should be blocked? No, that is a deadlock. I don't think this recursive
> locking is common, so no need care starvation here.
"not common" is really good news. I think we should list recursive use
cases first and try to decrease that use before messing up "__ocfs2_cluster_lock"
further. As for this patch,  cost is too high :/

Thanks,
Eric
> 
> > Second, this issue can be reproduced in old Linux kernels (e.g. 3.16.7-24)? there should not be any regression issue? 
> Maybe just hard to reproduce, ocfs2 supports recursive locking.
> 
> > Finally, really do not like nested using lock, can we avoid this.
> I didn't see a good reason why this should be avoided. Without this,
> developer needs pay more attend to not involve recursive locking,
> usually that is very hard before run a full test or a very detailed review.
> 
> Thanks,
> Junxiao.
> > 
> > Thanks
> > Gang
> > 
> > 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
