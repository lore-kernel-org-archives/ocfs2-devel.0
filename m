From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 19 Jun 2006 17:52:24 -0700
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <20060619170736.65237ce7.akpm@osdl.org>
References: <20060619234643.GK3082@ca-server1.us.oracle.com>
	<20060619170736.65237ce7.akpm@osdl.org>
Message-ID: <20060620005224.GL3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, ocfs2-devel@oss.oracle.com

On Mon, Jun 19, 2006 at 05:07:36PM -0700, Andrew Morton wrote:
>   The thing is that get_user_pages(.write=1, .force=1) can generate COW
>   hits on read-only shared mappings, this patch traps those as mkpage_write
>   candidates and fails to handle them the old way.
Ahh ok. Too bad this doesn't seem like it could be causing my bug :( Can I
ask what the old way of handling this is?

> It would be better to get a fix against the existing
> add-page_mkwrite-vm_operations-method.patch so at least we can get that
> merged up.  But nobody seems to be offering that.
Were I capable, I'd certainly offer up a patch :/ Definitely though, I agree
that sorting this out first seems like a reasonable way to go.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
