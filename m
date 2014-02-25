From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 24 Feb 2014 16:07:41 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: Move dquot_initialize()
	in	ocfs2_delete_inode() somewhat later
In-Reply-To: <1392975904-16944-3-git-send-email-jack@suse.cz>
References: <1392975904-16944-1-git-send-email-jack@suse.cz>
	<1392975904-16944-3-git-send-email-jack@suse.cz>
Message-ID: <20140225000741.GG5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 21, 2014 at 10:45:00AM +0100, Jan Kara wrote:
> Move dquot_initalize() call in ocfs2_delete_inode() after the moment we
> verify inode is actually a sane one to delete. We certainly don't want
> to initialize quota for system inodes etc. This also avoids calling into
> quota code from downconvert thread.
> 
> Add more details into the comment why bailing out from
> ocfs2_delete_inode() when we are in downconvert thread is OK.
> 
> Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/inode.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
