From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 27 Jul 2012 13:32:33 -0700
Subject: [Ocfs2-devel] [patch] ocfs2/dlm: use GFP_ATOMIC inside a
	spin_lock
In-Reply-To: <20120726130505.GA30865@elgon.mountain>
References: <20120726130505.GA30865@elgon.mountain>
Message-ID: <20120727203233.GB11126@wotan.suse.de>
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

Looks reasonable to me. Sunil, we might just want to have that dlm_work_item
allocated by the caller, yes?

Acked-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
