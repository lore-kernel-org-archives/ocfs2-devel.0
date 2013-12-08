From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 8 Dec 2013 11:30:34 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] Use the new DLM operation callbacks
	while	requesting new lockspace
In-Reply-To: <20131112140817.GA3955@shrek.lan>
References: <20131112140817.GA3955@shrek.lan>
Message-ID: <20131208193034.GF16774@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 12, 2013 at 08:08:22AM -0600, Goldwyn Rodrigues wrote:
> Attempt to use the new DLM operations. If it is not supported,
> use the traditional ocfs2_controld.
> 
> To exchange ocfs2 versioning, we use the LVB of the version dlm lock.
> It first attempts to take the lock in EX mode (non-blocking). If
> successful (which means it is the first mount), it writes the
> version number and downconverts to PR lock. If it is unsuccessful,
> it reads the version from the lock.

Can you take this description of the protocol and put it (as a comment) in
or above get_protocol_version(). I kind of had to look back to the patch
description to figure out exactly what it meant to do so I figure someone
reading this int he future will have  the same questions.

Otherwise this patch looks good, thanks!
	--Mark

--
Mark Fasheh
