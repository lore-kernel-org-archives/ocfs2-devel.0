From: David Howells <dhowells@redhat.com>
Date: Tue, 20 Jun 2006 14:02:25 +0100
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <9630.1150808384@warthog.cambridge.redhat.com> 
References: <9630.1150808384@warthog.cambridge.redhat.com>
	<1150787267.28517.126.camel@lappy>
	<20060619234643.GK3082@ca-server1.us.oracle.com>
	<20060619170736.65237ce7.akpm@osdl.org> 
Message-ID: <9710.1150808545@warthog.cambridge.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>, Mark Fasheh <mark.fasheh@oracle.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

David Howells <dhowells@redhat.com> wrote:

> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > -	if (unlikely(vma->vm_flags & VM_SHARED)) {
> > +	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
> > +				VM_SHARED|VM_WRITE) {
> 
> NAK!
> 
> "==" is higher priority than "|".  What you meant was:
> 
> -	if (unlikely(vma->vm_flags & VM_SHARED)) {
> +	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
> +				(VM_SHARED|VM_WRITE)) {

Or, rather:

-	if (unlikely(vma->vm_flags & VM_SHARED)) {
+	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
+				(VM_SHARED|VM_WRITE))) {

It has insufficient closing brackets otherwise.

David
