From: Jeff Garzik <jgarzik@pobox.com>
Date: Thu May 19 15:09:56 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <200505190230.23624.phillips@istop.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<200505190230.23624.phillips@istop.com>
Message-ID: <428C69EA.6080001@pobox.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@istop.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

Daniel Phillips wrote:
> Zero terminated strings for lock names is bad taste.  It generates a bunch of 
> useless strlen executions and you force an ascii namespace for no apparent 
> reason.  Add a 9th parameter, namelen, to the lock call maybe?

What's wrong with ascii strings?

We call those 'UTF8' these days.

	Jeff
