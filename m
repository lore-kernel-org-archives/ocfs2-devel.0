From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Feb 27 13:27:11 2008
Subject: [Ocfs2-devel] Re: [PATCH 8/9] fs/ocfs2/aops.c: Correct use of ! and
	&
In-Reply-To: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
References: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
Message-ID: <20080227212645.GP27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Feb 26, 2008 at 09:45:56PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.
> 
> This is not tested and clearly changes the semantics, so it is only
> something to consider.

That looks fine - it's in Ocfs2.git now, thanks.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
