From: David Howells <dhowells@redhat.com>
Date: Tue, 20 Jun 2006 13:59:44 +0100
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <1150787267.28517.126.camel@lappy> 
References: <1150787267.28517.126.camel@lappy>
	<20060619234643.GK3082@ca-server1.us.oracle.com>
	<20060619170736.65237ce7.akpm@osdl.org> 
Message-ID: <9630.1150808384@warthog.cambridge.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@osdl.org>, Mark Fasheh <mark.fasheh@oracle.com>, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> -	if (unlikely(vma->vm_flags & VM_SHARED)) {
> +	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
> +				VM_SHARED|VM_WRITE) {

NAK!

"==" is higher priority than "|".  What you meant was:

-	if (unlikely(vma->vm_flags & VM_SHARED)) {
+	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
+				(VM_SHARED|VM_WRITE)) {

David
