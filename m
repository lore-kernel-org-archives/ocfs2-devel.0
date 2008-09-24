From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 24 Sep 2008 15:44:18 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
 ocfs2
In-Reply-To: <20080923063329.GU4563@wotan.suse.de>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
	<20080923063329.GU4563@wotan.suse.de>
Message-ID: <48D9EFD2.8040305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> Oh, almost missed this actually. Isn't it customary to allow the user to
> select whether to compile in support for security attributes, or acls? You
> can pretty much copy the code from any other file system really.
OK. I will refer to others.

One more question, They also allow user to select whether support EA,
in ocfs2, do we need this option in Kconfig? or we support EA by default?

> Also, would you mind rebasing these against the latest xattrs branch in
> ocfs2.git? The only change was that I removed the code in '#ifdef
> CONFIG_OCFS2_FS_SECURITY' and '#ifdef CONFIG_OCFS2_FS_ACL' because we
> weren't ever defining those yet. Obviously, you get to add them back now  :)
no problem. I will rebase the branch and generate all the patches.

best regards,
tiger
