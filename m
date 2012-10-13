From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 13 Oct 2012 12:19:51 -0400
Subject: [Ocfs2-devel] [PATCH 06/22] ocfs2: drop vmtruncate
In-Reply-To: <506FE92F.2000609@gmail.com>
References: <506FE92F.2000609@gmail.com>
Message-ID: <20121013161951.GC19899@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

>  	if ((attr->ia_valid & ATTR_SIZE) &&
>  	    attr->ia_size != i_size_read(inode)) {
> -		status = vmtruncate(inode, attr->ia_size);
> +		status = inode_newsize_ok(inode, attr->ia_size);
>  		if (status) {
>  			mlog_errno(status);
>  			goto bail_commit;
>  		}
> +		truncate_setsize(inode, attr->ia_size);

ocfs2 already calls inode_newsize_ok earlier during ocfs2_setattr,
and there's an XXX comment just above the vmtruncate call about
how ocfs2 hacks around this.  I suspect you just want a plain
truncate_setsize here and remove the comment above it, but I'd
like to have the ocfs2 folks confirm that.
