From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed May 18 23:30:51 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <8E7D9068-5392-4479-9207-18C63618A133@mac.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<8E7D9068-5392-4479-9207-18C63618A133@mac.com>
Message-ID: <20050519043049.GH1340@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On Wed, May 18, 2005 at 10:30:56PM -0400, Kyle Moffett wrote:
> Does this include support for UNIX sockets and named pipes?
Unfortunately no, at least not on a clustered level. Local node, those
should work as normal. If you absolutely need this functionality, I believe
OpenSSI currently supports it.

If you're looking for an easy way to share small amounts data between
applications in an OCFS2 cluster, you might be interested in looking at
dlmfs. Once mounted, it's quite trivial to create dlm domains and lock
resources between nodes via regular file system operations (open, close,
etc). File read and write will return and set the resource LVB for you,
currently 64 bytes. Though this can all be controlled from shell, a small
library (libo2cb) to take advantage of this is provided in the current
toolchain distribution.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
