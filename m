From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 29 Jan 2010 16:16:39 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
 level is already compatible
In-Reply-To: <20100129222102.GC16606@redhat.com>
References: <4B632024.1090102@oracle.com> <20100129222102.GC16606@redhat.com>
Message-ID: <4B637A67.6070007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> With this patch I ran alternate and make_panic for about 2.5 hours, and
> then one node hit this BUG.  /var/log/messages didn't catch any of it, so
> no additional info this time.
>
> kernel BUG at fs/ocfs2/dlmglue.c:3395

David,

Please could you re-run with this debug patch.

http://oss.oracle.com/~smushran/.dlmglue/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-dl.patch

Thanks
Sunil
