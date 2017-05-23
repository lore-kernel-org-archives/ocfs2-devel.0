From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 23 May 2017 07:26:24 +0300
Subject: [Ocfs2-devel] [bug report] ocfs2: check/fix inode block for
	online file check
In-Reply-To: <59240CD2020000F900077862@prv-mh.provo.novell.com>
References: <20170520094839.f6jtjcao3q3p7ztw@mwanda>
	<59240CD2020000F900077862@prv-mh.provo.novell.com>
Message-ID: <20170523042624.rpkdrgw7tgv2jafn@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 22, 2017 at 08:20:02PM -0600, Gang He wrote:
> Hi Dan,
> 
> What static checker tool did you use? could you paste the detailed warning message to the list too?
> Since I need to write this information into the patch comments due to Andrew Morton's suggestion.
> 

It's some Smatch stuff that I was working on yesterday.  I'm probably
going to publish this in a month or two.  It's hard to say because, of
course, returning NULL is often valid.

Anyway, the warning is triggered when you pass zero to ERR_PTR().

 	fs/ocfs2/inode.c:179 ocfs2_iget()
 	warn: passing zero to 'ERR_PTR'

regards,
dan carpenter
