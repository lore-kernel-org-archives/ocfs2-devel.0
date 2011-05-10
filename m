From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 10 May 2011 13:24:21 -0700
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2: remove unnecessary
 dentry_unhash on rmdir/rename_dir
In-Reply-To: <1305002616-16782-17-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
	<1305002616-16782-17-git-send-email-sage@newdream.net>
Message-ID: <20110510202420.GA29657@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@newdream.net>
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Mon, May 09, 2011 at 09:43:34PM -0700, Sage Weil wrote:
> Ocfs2 has no issues with lingering references to unlinked directory inodes.
> 
> CC: Mark Fasheh <mfasheh@suse.com>
> CC: Joel Becker <jlbec@evilplan.org>
> CC: ocfs2-devel at oss.oracle.com
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/ocfs2/namei.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index f3582a6..e5d738c 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -810,9 +810,6 @@ static int ocfs2_unlink(struct inode *dir,
>  			   (unsigned long long)OCFS2_I(dir)->ip_blkno,
>  			   (unsigned long long)OCFS2_I(inode)->ip_blkno);
>  
> -	if (S_ISDIR(inode->i_mode))
> -		dentry_unhash(dentry);
> -

	I'm wary about this.  If ocfs2_unlink/ocfs2_rename fail,
d_delete is not called.  Also, d_delete doesn't always clear it.  I
worry that we'll have a dentry that can be traversed even though its
state in the cluster is bad or unknown.
	However, I think our d_revalidate checks should correctly catch
these cases.  If we get to the point of doing actual work, we've
assuredly told other nodes to forget about this directory.  So I'll
tentatively Ack this, and hope it doesn't explode ;-)

Acked-by: Joel Becker <jlbec@evilplan.org>


-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."

			http://www.jlbec.org/
			jlbec at evilplan.org
