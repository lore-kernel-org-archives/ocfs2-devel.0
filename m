From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 14 Aug 2012 23:40:23 -0700
Subject: [Ocfs2-devel] [patch] ocfs2/dlm: use GFP_ATOMIC inside a
	spin_lock
In-Reply-To: <20120726130505.GA30865@elgon.mountain>
References: <20120726130505.GA30865@elgon.mountain>
Message-ID: <20120815064023.GE31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 26, 2012 at 04:05:05PM +0300, Dan Carpenter wrote:
> My static checker complains that this is called with a spin_lock held
> in dlm_master_requery_handler() from dlmrecovery.c.  Probably the reason
> we have not received any bug reports about this is that recovery is not
> a common operation.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This patch is now part of the fixes branch of ocfs2.git.

Joel

> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 005261c..33ecbe0 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2020,7 +2020,7 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
>  			       int ignore_higher, u8 request_from, u32 flags)
>  {
>  	struct dlm_work_item *item;
> -	item = kzalloc(sizeof(*item), GFP_NOFS);
> +	item = kzalloc(sizeof(*item), GFP_ATOMIC);
>  	if (!item)
>  		return -ENOMEM;
>  

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

			http://www.jlbec.org/
			jlbec at evilplan.org
