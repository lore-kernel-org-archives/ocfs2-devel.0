From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 07 Jan 2016 15:49:27 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <20160107225507.GB819@wotan.suse.de>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
	<20160107225507.GB819@wotan.suse.de>
Message-ID: <568EF987.9080904@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 01/07/2016 02:55 PM, Mark Fasheh wrote:
> So you could replace that last paragraph with something like this:
>
> The deleted version of ocfs2_acl_chmod() calls __posix_acl_chmod() which
> does not call back into the filesystem. Therefore, we restore
> ocfs2_acl_chmod() and use that instead.
Thanks for reviewing. I have two more code paths to fix.

1. ocfs2_mknod()->posix_acl_create()->ocfs2_iop_get_acl()
2. ocfs2_reflink ->  ocfs2_init_security_and_acl -> ocfs2_iop_set_acl

I will make your suggested change and submit again
a 3-part patch, including the above two.
-Tariq
