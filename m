From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 17 Aug 2009 12:54:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Handle quota file corruption more
 gracefully
In-Reply-To: <1249316661-28657-1-git-send-email-jack@suse.cz>
References: <1249316661-28657-1-git-send-email-jack@suse.cz>
Message-ID: <20090817195417.GB29615@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 03, 2009 at 06:24:21PM +0200, Jan Kara wrote:
> ocfs2_read_virt_blocks() does BUG when we try to read a block from a file
> beyond its end. Since this can happen due to filesystem corruption, it
> is not really an appropriate answer. Make ocfs2_read_quota_block() check
> the condition and handle it by calling ocfs2_error() and returning EIO.
> 
> Reported-by: Tristan Ye <tristan.ye@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  Joel, could you please merge this fix? Thanks.

This is now in the fixes branch of ocfs2.git.  That <= check is a little
confusing, because it relies on quota files always being whole blocks.

Joel

-- 

"We'd better get back, `cause it'll be dark soon,
 and they mostly come at night.  Mostly."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
