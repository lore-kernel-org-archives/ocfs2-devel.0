From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 29 Oct 2008 15:58:32 -0700
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <12248859043309-git-send-email-jack@suse.cz>
References: <12248859043309-git-send-email-jack@suse.cz>
Message-ID: <20081029225832.GH15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:05:04AM +0200, Jan Kara wrote:
> Hello,
> 
> the following patch series implements quotas for OCFS2. The patch
> series is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next

Great, thanks for posting these again.


> I've adressed Joel's comments, also node recovery is now fully working
> and I've fixed a few issues I found during my testing. So I'm currently
> not aware of any bugs. Please review, test, comment. Thanks.

How are we going to handle the vfs patches? I think realistically, they
should just all go into the merge_window branch of ocfs2.git along with the
Ocfs2 patches to add quoata support (and make use of the VFS features you
added). The VFS patches at least though, should probably get posted to
linux-fsdevel before I pick them up.
	--Mark

--
Mark Fasheh
