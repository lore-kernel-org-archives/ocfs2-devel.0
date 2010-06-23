From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Tue, 22 Jun 2010 18:12:01 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <20100623004937.GB20090@mail.oracle.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
Message-ID: <AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 5:49 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Tue, Jun 22, 2010 at 05:11:50PM -0700, Patrick J. LoPresti wrote:
>
> ? ? ? ?This patch is not sufficient. ?The journal options need to be
> checked, as does the block addressing space of the kernel.

OK.  But I am new to this code base and would appreciate some pointers...

Specifically:

Which journal options?  Are they visible at this point in super.c?

By "block addressing space of the kernel", are we just talking
sizeof(some_kernel_type) or something more involved?

Thanks!

 - Pat
