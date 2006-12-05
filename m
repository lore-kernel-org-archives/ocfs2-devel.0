From: Andrew Morton <akpm@osdl.org>
Date: Tue Dec  5 22:12:03 2006
Subject: [Ocfs2-devel] Re: Relative atime (was Re: What's in ocfs2.git)
In-Reply-To: <20061205222027.GA4497@ca-server1.us.oracle.com>
References: <20061203203149.GC19617@ca-server1.us.oracle.com>
	<1165229693.3752.629.camel@quoit.chygwyn.com>
	<20061205001007.GF19617@ca-server1.us.oracle.com>
	<20061205003619.GC8482@goober>
	<20061205222027.GA4497@ca-server1.us.oracle.com>
Message-ID: <20061205221145.53dab6bf.akpm@osdl.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Valerie Henson <val_henson@linux.intel.com>, Steven Whitehouse <steve@chygwyn.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>

On Tue, 5 Dec 2006 14:20:27 -0800
Mark Fasheh <mark.fasheh@oracle.com> wrote:

> Update ocfs2_should_update_atime() to understand the MNT_RELATIME flag and
> to test against mtime / ctime accordingly.
> 
> ...
>
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -154,6 +154,15 @@ int ocfs2_should_update_atime(struct ino
>  		return 0;
>  
>  	now = CURRENT_TIME;
> +
> +	if (vfsmnt->mnt_flags & MNT_RELATIME) {
> +		if ((timespec_compare(&inode->i_atime, &inode->i_mtime) < 0) ||
> +		    (timespec_compare(&inode->i_atime, &inode->i_ctime) < 0))
> +			return 1;
> +
> +		return 0;

So if atime == mtime == ctime, we don't update the atime.

I think we should.  It seems risky to leave them all equal.
