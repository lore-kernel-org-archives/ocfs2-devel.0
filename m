From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue, 08 Apr 2014 15:39:55 -0700
Subject: [Ocfs2-devel] [patch 03/11] ocfs2/o2net: incorrect to terminate
 accepting connections loop upon rejecting an invalid one
In-Reply-To: <20140408194241.GR4488@wotan.suse.de>
References: <20140124204702.9871031C2C7@corp2gmr1-1.hot.corp.google.com>
	<20140124215554.GC24361@wotan.suse.de>
	<52E2E7C1.7070801@oracle.com>
	<20140319140143.b3a0fa14b49284fb79c1bd61@linux-foundation.org>
	<534367FD.8060403@oracle.com> <20140408194241.GR4488@wotan.suse.de>
Message-ID: <53447ABB.8000100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/08/2014 12:42 PM, Mark Fasheh wrote:

>> Mark, do you have further questios?
>
> No but we're going to need a comment explaining this above the code in
> question. It's not entirely clear just by reading it.
> 	--Mark
>
> --
> Mark Fasheh
>
I have resubmitted with the patch with comments.
