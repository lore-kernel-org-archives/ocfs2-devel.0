From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 18:30:14 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in namei.c
In-Reply-To: <200402200413.i1K4DhZU004262@penguin.co.intel.com>
References: <200402200413.i1K4DhZU004262@penguin.co.intel.com>
Message-ID: <20040224003009.GH1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2004 at 08:13:43PM -0800, Rusty Lynch wrote:
> The following patch fixes more of the same 2.6 porting issues
> for namei.c.  Specifically, moving away from the now gone kdev_t
> references, and adapting to the new timespec values.
> 
>     --rusty
Committed.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
