From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Apr  2 11:58:34 2007
Subject: [Ocfs2-devel] [PATCH 0/3] Properly protect the extent map
In-Reply-To: <46114FE6.8030704@ubuntu.com>
References: <20070329005041.518030000@oracle.com> <460B7B00.30004@ubuntu.com>
	<20070402184550.GA21982@ca-server1.us.oracle.com>
	<46114FE6.8030704@ubuntu.com>
Message-ID: <20070402185828.GC21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 02, 2007 at 08:48:06PM +0200, Fabio Massimo Di Nitto wrote:
> i kept logging all the info in the bug:

Ahh, great, thanks.


> http://oss.oracle.com/bugzilla/show_bug.cgi?id=859

So it looks like nobody was able to reproduce the performance problem -
phew! I'll push these patches into ocfs2.git shortly.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
