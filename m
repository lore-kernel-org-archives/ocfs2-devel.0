From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 21 Apr 2009 15:00:44 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add missing iput() during
	error handling in ocfs2_dentry_attach_lock()
In-Reply-To: <1240288458-14162-1-git-send-email-sunil.mushran@oracle.com>
References: <1240288458-14162-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090421220044.GD4585@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 20, 2009 at 09:34:18PM -0700, Sunil Mushran wrote:
> In ocfs2_dentry_attach_lock(), if unable to get the dentry lock(), we need to
> call iput(inode) because a failure here means no d_instantiate(), which means
> the normally matching iput() will not be called during dput(dentry).
> 
> This patch fixes the oops that accompanies the following message:
> (3996,1):dlm_empty_lockres:2708 ERROR: lockres W00000000000000000a1046b06a4382 still has local locks!
> kernel BUG in dlm_empty_lockres at /rpmbuild/smushran/BUILD/ocfs2-1.4.2/fs/ocfs2/dlm/dlmmaster.c:2709!
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
