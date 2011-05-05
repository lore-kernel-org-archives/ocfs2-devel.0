From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 5 May 2011 15:00:08 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Target node death during
	resource migration leads to thread spin
In-Reply-To: <1304530489-16123-1-git-send-email-sunil.mushran@oracle.com>
References: <1304530489-16123-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110505220008.GC17822@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 04, 2011 at 10:34:49AM -0700, Sunil Mushran wrote:
> During resource migration, if the target node were to die, the thread doing
> the migration spins until the target node is not removed from the domain map.
> This patch slows the spin by making the thread wait for the recovery to kick in.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
