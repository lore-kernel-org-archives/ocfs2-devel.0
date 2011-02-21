From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Feb 2011 10:17:45 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <4D611047.9010607@oracle.com>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>	<1296368761-23043-3-git-send-email-tristan.ye@oracle.com>	<20110220120707.GG17784@noexit>
	<4D611047.9010607@oracle.com>
Message-ID: <4D62AC49.3090600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 02/20/2011 04:59 AM, Tristan Ye wrote:
>      Joel, great catch, how did you builder get warning like that, needs
> to change makefile a bit?
>
> And we're not allowed to put structure more than 2k, on stack for each
> function in kernel?

In 32-bit kernels, the stack is set to 4K. In 64 bit, 8K. These are the
typical values chosen by various distros.

So using 2K is dangerous as it could easily lead to an overflow and oops/panic
the box.

There is no magic cut-off value for the max stack footprint for a function.
The number depends on the stack depth. Also we have no control on a lot of
functions in the stack. So we try to keep our footprint as small as possible.

BTW, you can run scripts/checkstack.pl to check the stack footprint of the
functions.

# objdump -d fs/ocfs2/ocfs2.ko | scripts/checkstack.pl
0x0001873a ocfs2_extend_dir [ocfs2]:        316
0x00044060 ocfs2_rename [ocfs2]:            316
0x0003b5af __ocfs2_recovery_thread [ocfs2]: 232
0x00046cd8 ocfs2_symlink [ocfs2]:           220
0x000762f6 ocfs2_xattr_set [ocfs2]:         220

(So 316 bytes is the current max footprint for a function in 32-bit builds.)

Sunil
