From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Apr 28 16:13:59 2004
Subject: [Ocfs2-devel] R867 still crash on 2.4.20
In-Reply-To: <000001c42cc2$db834fb0$2bdb10ac@ccr.corp.intel.com>
References: <000001c42cc2$db834fb0$2bdb10ac@ccr.corp.intel.com>
Message-ID: <20040428211353.GA9043@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 28, 2004 at 09:48:05AM +0800, ling-linux wrote:
> I've checked out the newest one rivision 867, on 2.4.20, when mounting,
> it still crashs.
My svn tree shows the latest revision at 873...

> ==========
> <1> Unable to handle kernel NULL point dereference at virtual address
> 0000000.
> Have you ever tried on 2.4 kernel?  Can you reproduce this?
I run it on a 2.4 kernel all the time! :)
Do you have a full stack trace? As in, what's the kernel output!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
