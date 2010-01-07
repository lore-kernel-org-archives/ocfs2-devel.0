From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 6 Jan 2010 18:50:39 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: set OCFS2_LOCK_BLOCKED properly
In-Reply-To: <20100107021006.GA3270@laptop.oracle.com>
References: <201001051707.o05Gxath022586@acsinet15.oracle.com>
	<4B437BE9.7090803@oracle.com>
	<20100107010319.GZ11402@wotan.suse.de>
	<20100107021006.GA3270@laptop.oracle.com>
Message-ID: <20100107025039.GA11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 07, 2010 at 10:10:06AM +0800, Wengang Wang wrote:
> sorry that I have no test case and it's not from a bug.
> I found it when reading code.

Ok, I forgot to ack the patch previously:

Acked-by: Mark Fasheh <mfasheh@suse.com>

> actually I found it as a side product while I was working on
> freeze/thaw. and the main bug/problem is described in my email titled 
> "ocfs2: fix __ocfs2_cluster_lock() dead lock".

Ok, I'll look there.
	--Mark

--
Mark Fasheh
