From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Sep 2008 23:28:53 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
	ocfs2
In-Reply-To: <1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080923062853.GT4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 19, 2008 at 05:42:33PM +0800, Tiger Yang wrote:
> This patch add security extended attribute support in ocfs2.

Ok, thanks for this.


> +struct xattr_handler ocfs2_xattr_security_handler = {
> +	.prefix	= XATTR_SECURITY_PREFIX,
> +	.list	= ocfs2_xattr_security_list,
> +	.get	= ocfs2_xattr_security_get,
> +	.set	= ocfs2_xattr_security_set,
> +};

Don't we need to add a call to 'security_inode_init_security()' when creating a new
inode?

The patch otherwise looks good. How was it tested?
	--Mark

--
Mark Fasheh
