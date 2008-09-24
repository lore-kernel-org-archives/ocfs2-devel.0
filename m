From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 01:51:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
	ocfs2
In-Reply-To: <48D9EFD2.8040305@oracle.com>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
	<20080923063329.GU4563@wotan.suse.de> <48D9EFD2.8040305@oracle.com>
Message-ID: <20080924085155.GY4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 24, 2008 at 03:44:18PM +0800, Tiger Yang wrote:
> Mark Fasheh wrote:
> >Oh, almost missed this actually. Isn't it customary to allow the user to
> >select whether to compile in support for security attributes, or acls? You
> >can pretty much copy the code from any other file system really.
> OK. I will refer to others.
> 
> One more question, They also allow user to select whether support EA,
> in ocfs2, do we need this option in Kconfig? or we support EA by default?

Hmm... Do you know why they allow EA's to be compiled optionally? Maybe we
should do the same. I don't have any strong opinions one way or the other
though.


> >Also, would you mind rebasing these against the latest xattrs branch in
> >ocfs2.git? The only change was that I removed the code in '#ifdef
> >CONFIG_OCFS2_FS_SECURITY' and '#ifdef CONFIG_OCFS2_FS_ACL' because we
> >weren't ever defining those yet. Obviously, you get to add them back now  
> >:)
> no problem. I will rebase the branch and generate all the patches.

Thanks, I appreciate this.
	--Mark

--
Mark Fasheh
