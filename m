From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 25 Nov 2013 15:00:34 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] Add DLM recovery callbacks
In-Reply-To: <20131112140654.GA3934@shrek.lan>
References: <20131112140654.GA3934@shrek.lan>
Message-ID: <20131125230034.GX29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 12, 2013 at 08:06:59AM -0600, Goldwyn Rodrigues wrote:
> These are the callbacks called by the fs/dlm code in case the membership
> changes. If there is a failure while/during calling any of these, the
> DLM creates a new membership and relays to the rest of the nodes.
> 
> recover_prep() is called when DLM understands a node is down.
> recover_slot() is called once all nodes have acknowledged recover_prep
> and recovery can begin.
> recover_done() is called once the recovery is complete. It returns the
> new membership.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks good, I didn't have anything last time, nothing still this time so:

Reviewed-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
