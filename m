From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 31 Dec 2019 14:33:31 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make local header paths relative
	to C files
In-Reply-To: <20191227022950.14804-1-ghe@suse.com>
References: <20191227022950.14804-1-ghe@suse.com>
Message-ID: <20191231143331.9b77ee5709f2662c54d76a51@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <GHe@suse.com>
Cc: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>, Masahiro Yamada <masahiroy@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

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
