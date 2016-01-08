From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 7 Jan 2016 17:45:56 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <568EF987.9080904@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
	<20160107225507.GB819@wotan.suse.de> <568EF987.9080904@oracle.com>
Message-ID: <20160108014556.GD819@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 07, 2016 at 03:49:27PM -0800, Tariq Saeed wrote:
> 
> On 01/07/2016 02:55 PM, Mark Fasheh wrote:
> >So you could replace that last paragraph with something like this:
> >
> >The deleted version of ocfs2_acl_chmod() calls __posix_acl_chmod() which
> >does not call back into the filesystem. Therefore, we restore
> >ocfs2_acl_chmod() and use that instead.
> Thanks for reviewing. I have two more code paths to fix.

No problem, thanks for the continuing patches.


> 1. ocfs2_mknod()->posix_acl_create()->ocfs2_iop_get_acl()

Ok, that seems straightforward enough.

> 2. ocfs2_reflink ->  ocfs2_init_security_and_acl -> ocfs2_iop_set_acl

Could you elaborate for me on the problem you found there?


Btw, ocfs2_iop_set_acl() isn't doing any cluster locking. That doesn't look
right to me but maybe I'm missing something (like perhaps it gets called
from lock context). I'll try to take a look tommorrow but since you've been
looking around this area I thought I'd mention this to you.

Thanks,
 	--Mark

--
Mark Fasheh
