From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 24 Sep 2008 15:37:13 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
 ocfs2
In-Reply-To: <20080923062853.GT4563@wotan.suse.de>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
	<20080923062853.GT4563@wotan.suse.de>
Message-ID: <48D9EE29.80904@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,Mark,

Mark Fasheh wrote:
  > Don't we need to add a call to 'security_inode_init_security()' when 
creating a new
> inode?
In security_inode_init_security(), it will check IS_PRIVATE(inode), if 
it is not a private inode, it will return.
It seems we don't use S_PRIVATE in ocfs2, do we?

anyway, I can add this call in ocfs2 quickly.

Best regards,
tiger
