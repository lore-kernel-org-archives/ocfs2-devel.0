From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 29 Aug 2008 10:48:31 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Switch over to JBD2.
In-Reply-To: <48B833EE.3050609@oracle.com>
References: <20080829004902.GF15974@mail.oracle.com>
	<48B833EE.3050609@oracle.com>
Message-ID: <20080829174831.GS4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 29, 2008 at 10:37:50AM -0700, Sunil Mushran wrote:
> Any reason we don't want to support both jbd and jdb2. As in, using
> incompat to specifically enable jbd2.

I keep going back and forth on this. On one hand, we want people to be on
JBD2 as it handles all our needs (including backwards compat with JBD). On
the other hand, it might be prudent to allow folks a fallback, just for a
short while until this has been "in the wild" for a bit.


> I am talking about short term only. Long term is jdb2 only.

Yeah. My thinking right now is that we make JBD2 the default, mark Ocfs2 JBD
support as deprecated, and remove JBD support completely in 2.6.29.
	--Mark

--
Mark Fasheh
