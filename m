From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 20 Feb 2011 18:04:12 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <4D611047.9010607@oracle.com>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>
	<1296368761-23043-3-git-send-email-tristan.ye@oracle.com>
	<20110220120707.GG17784@noexit> <4D611047.9010607@oracle.com>
Message-ID: <20110221020412.GK17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Feb 20, 2011 at 08:59:51PM +0800, Tristan Ye wrote:
> > /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c: In function ?ocfs2_info_handle_freeinode?:
> > /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:441: warning: the frame size of 4192 bytes is larger than 2048 bytes
> >
> > 	This is speaking to the fact that you've put struct
> > ocfs2_info_freeinode oifi on the stack.  It's over 4K in size.  It needs
> > to be allocated.
> 
>     Joel, great catch, how did you builder get warning like that, needs 
> to change makefile a bit?

	I didn't change anything.  My gcc (4.4.3 on amd64) noticed it.
I can't think of anything terribly odd about my .config.

> And we're not allowed to put structure more than 2k, on stack for each 
> function in kernel?

	We shouldn't put anything remotely close to that on the stack.
Ever.  Imagine a function with a 2K object calling another function with
a 2K object.  Bammo!  If you have anything larger than probably 256B on
the stack, you should know, precisely, what it calls, and that it can't
take a deep interrupt.

Joel

-- 

"I'm so tired of being tired,
 Sure as night will follow day.
 Most things I worry about
 Never happen anyway."

			http://www.jlbec.org/
			jlbec at evilplan.org
