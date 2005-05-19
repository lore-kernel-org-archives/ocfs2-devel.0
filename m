From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu May 19 01:54:13 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <200505190230.23624.phillips@istop.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<200505190230.23624.phillips@istop.com>
Message-ID: <20050519065405.GI1340@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@istop.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On Thu, May 19, 2005 at 02:30:23AM -0400, Daniel Phillips wrote:
> Zero terminated strings for lock names is bad taste.  It generates a bunch of 
> useless strlen executions and you force an ascii namespace for no apparent 
> reason.  Add a 9th parameter, namelen, to the lock call maybe?
Or perhaps pass in a qstr? Anyway I have to agree. That shouldn't be
difficult to fix up.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
