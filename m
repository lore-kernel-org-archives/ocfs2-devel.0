From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 21 Apr 2011 16:39:48 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/cluster: Increase the live
 threshold
In-Reply-To: <4DB0AC1A.5020303@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
	<1302042069-25565-3-git-send-email-sunil.mushran@oracle.com>
	<20110421214928.GL13325@wotan.suse.de>
	<4DB0AC1A.5020303@oracle.com>
Message-ID: <20110421233947.GA20184@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 21, 2011 at 03:13:46PM -0700, Sunil Mushran wrote:
> We have seen isolated cases (very few, I might add) of o2hb not
> detecting all live nodes on startup. One plausible reasoning for it
> is that other node had a hb io delay at the same time. The live
> threshold currently is 2. That's as low as it can be. As we set it to
> that because we start the heartbeat on mount.
> 
> With global heartbeat we can afford to increase that timeout. The
> patch increases it for only global heartbeat and that too only for
> the first heartbeat region.
> 
> Makes sense?

	I think Mark wants this in the patch description.  We won't find
this email a year from now ;-)

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

			http://www.jlbec.org/
			jlbec at evilplan.org
