From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Apr  2 11:45:55 2007
Subject: [Ocfs2-devel] [PATCH 0/3] Properly protect the extent map
In-Reply-To: <460B7B00.30004@ubuntu.com>
References: <20070329005041.518030000@oracle.com> <460B7B00.30004@ubuntu.com>
Message-ID: <20070402184550.GA21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 29, 2007 at 10:38:24AM +0200, Fabio Massimo Di Nitto wrote:
> on all 3 of them. They fix the problem as i reported it, but it looks like they
> introduce a performance hit.

Can you elaborate on that please?

I don't see anything in those patches that should cause any performance
problems but if you have any more information about what you saw, it might
point to something we missed.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
