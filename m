From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 21 Feb 2006 13:41:03 -0800
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: fix -Wformat warnings when
	building UML on x86-64
In-Reply-To: <20060221183740.GA3068@lst.de>
References: <20060221165730.GA11821@locomotive.unixthugs.org>
	<20060221183740.GA3068@lst.de>
Message-ID: <20060221214103.GO20175@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 21, 2006 at 07:37:41PM +0100, Christoph Hellwig wrote:
> Please just rip out this crap instead and use the normal
> (long long) or (unsigned long long) casts used everywhere else in the
> kernel.
Well, it helps us avoid a ton of those casts, which I guess us wacky OCFS2
folks thought were more ugly.

Unless you have a patch, I'll put removal of ML*64 on my todo list, but in
the meantime lets silence things for Jeff.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
