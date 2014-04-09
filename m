From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 9 Apr 2014 13:44:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: Remove NULL assignments on
 static
In-Reply-To: <534499FA.8010107@oracle.com>
References: <20140408221342.9759bea1dd852f2787f82586@skynet.be>
	<534499FA.8010107@oracle.com>
Message-ID: <20140409134448.cb23b34622bf986d145f1eaa@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wengang <wen.gang.wang@oracle.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, 09 Apr 2014 08:53:14 +0800 Wengang <wen.gang.wang@oracle.com> wrote:

> ___ 2014___04___09___ 04:13, Fabian Frederick ______:
> > static values are automatically initialized to NULL.
> >
>
> What's the badness if we do the assignments?

(top-posting repaired...)

Back in the olden days,

	static int x = 0;

would consume space in the .data segment and

	static int x;

would consume space in the .bss segment.


The .data segment is a part of vmlinux (because it contains non-zero
data) whereas .bss does not occupy space in vmlinux because .bss is
all-zero and can be built at runtime

So the effect of this patch would be to reduce the size of the kernel
image.  Less disk space, less ROM space, etc.


I think more recent gcc's and linkers got smarter about that and move
initialized-to-zero .data into .bss anyway.
