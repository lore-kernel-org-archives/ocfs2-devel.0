From: Fabio Massimo Di Nitto <fabbione@ubuntu.com>
Date: Mon Apr  2 12:00:45 2007
Subject: [Ocfs2-devel] [PATCH 0/3] Properly protect the extent map
In-Reply-To: <20070402185828.GC21982@ca-server1.us.oracle.com>
References: <20070329005041.518030000@oracle.com> <460B7B00.30004@ubuntu.com>
	<20070402184550.GA21982@ca-server1.us.oracle.com>
	<46114FE6.8030704@ubuntu.com>
	<20070402185828.GC21982@ca-server1.us.oracle.com>
Message-ID: <461152CF.6030600@ubuntu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Apr 02, 2007 at 08:48:06PM +0200, Fabio Massimo Di Nitto wrote:
>> i kept logging all the info in the bug:
> 
> Ahh, great, thanks.

no problem.

> 
> 
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=859
> 
> So it looks like nobody was able to reproduce the performance problem -
> phew! I'll push these patches into ocfs2.git shortly.

Yes.. i also tested them on 2.6.20 + the 2.6.20_fixes branch that Sunil pointed
me too, so they should be good to go there too.

Fabio

-- 
I'm going to make him an offer he can't refuse.
