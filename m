From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 04 May 2011 13:09:39 -0700
Subject: [Ocfs2-devel] freeing memory allocated in
	security_inode_init_security()
In-Reply-To: <1304536698.3227.36.camel@localhost.localdomain>
References: <1304536698.3227.36.camel@localhost.localdomain>
Message-ID: <4DC1B283.8080105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/04/2011 12:18 PM, Mimi Zohar wrote:
> Although it isn't documented in security.c, the LSM
> security_inode_init_security() hook allocates memory for xattr name and
> value, expecting the caller to release the memory afterwards.
>
> I'm making my way through the different filesystems adding a subsequent
> call to evm_inode_post_init_security().  I see the call to
> ocfs2_init_security_and_acl() calls ocfs2_init_security_get(), which in
> turn calls security_inode_init_security(), but am having a hard time
> finding where the name and value are subsequently freed.  Would
> appreciate if someone could point it out.

I think we have a leak in the reflink code path. mknod and symlink
code paths free the name/value pair.

Tiger, Please could you post a fix.
