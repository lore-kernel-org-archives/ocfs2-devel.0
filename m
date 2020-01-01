From: Gang He <GHe@suse.com>
Date: Wed, 1 Jan 2020 08:37:21 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: make local header paths relative
	to C files
In-Reply-To: <20191231143331.9b77ee5709f2662c54d76a51@linux-foundation.org>
References: <20191227022950.14804-1-ghe@suse.com>,
	<20191231143331.9b77ee5709f2662c54d76a51@linux-foundation.org>
Message-ID: <CH2PR18MB320677E43EE0CE5ED01BD5CCCF210@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



________________________________
From: Andrew Morton <akpm@linux-foundation.org>
Sent: Wednesday, January 1, 2020 6:33 AM
To: Gang He <GHe@suse.com>
Cc: mark at fasheh.com <mark@fasheh.com>; jlbec at evilplan.org <jlbec@evilplan.org>; joseph.qi at linux.alibaba.com <joseph.qi@linux.alibaba.com>; Masahiro Yamada <masahiroy@kernel.org>; linux-kernel at vger.kernel.org <linux-kernel@vger.kernel.org>; ocfs2-devel at oss.oracle.com <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH] ocfs2: make local header paths relative to C files

On Fri, 27 Dec 2019 02:30:15 +0000 Gang He <GHe@suse.com> wrote:

> From: Masahiro Yamada <masahiroy@kernel.org>
>
> Gang He reports the failure of building fs/ocfs2/ as an external module
> of the kernel installed on the system:
>
>  $ cd fs/ocfs2
>  $ make -C /lib/modules/`uname -r`/build M=`pwd` modules
>
> If you want to make it work reliably, I'd recommend to remove ccflags-y
> from the Makefiles, and to make header paths relative to the C files.
> I think this is the correct usage of the #include "..." directive.
>
> Reported-by: Gang He <ghe@suse.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Gang He <ghe@suse.com>

Your signed-off-by should appear here, since you were on the patch
delivery path.  I have made that change, OK?
Sure, thank you, Andrew.
Originally, I just wanted to help Masahiro to send this patch in text mode, instead of attachment.

Thanks
Gang
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200101/2e0d5908/attachment-0001.html 
