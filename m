From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Feb 2014 15:53:38 -0800
Subject: [Ocfs2-devel] [patch 09/11] ocfs2: llseek requires ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <20140206155029.b7275670913c34ef6bc9a530@linux-foundation.org>
References: <20140124204709.85C895A4203@corp2gmr1-2.hot.corp.google.com>
	<20140206234253.GR24361@wotan.suse.de>
	<20140206155029.b7275670913c34ef6bc9a530@linux-foundation.org>
Message-ID: <20140206155338.dfbe31f1a5e8519e35d1042c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 6 Feb 2014 15:50:29 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> I suppose we should fix the bug it added.
> 
> --- a/fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end-fix
> +++ a/fs/ocfs2/file.c
> @@ -2631,6 +2631,7 @@ static loff_t ocfs2_file_llseek(struct f
>  		 */
>  		ret = ocfs2_inode_lock(inode, NULL, 0);
>  		if (ret < 0) {
> +			ocfs2_inode_unlock(inode, 0);
>  			mlog_errno(ret);
>  			goto out;
>  		}

oops, scratch that.
