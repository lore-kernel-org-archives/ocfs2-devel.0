From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 15:14:57 -0800
Subject: [Ocfs2-devel] [PATCH 3/6] Shift allocation
	ocfs2_live_connection to	user_connect()
In-Reply-To: <20131018144534.GA4583@shrek.lan>
References: <20131018144534.GA4583@shrek.lan>
Message-ID: <20131103231457.GI29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 18, 2013 at 09:45:39AM -0500, Goldwyn Rodrigues wrote:
> We perform this because the DLM recovery callbacks will require
> the ocfs2_live_connection structure to record the node information
> when dlm_new_lockspace() is updated.

Ok but what I see below is that you took the alloc out of
ocfs2_live_connecion_new() and just do it above that call in
user_cluster_connect(), then call ocfs2_live_connection_new().

Aside from that though this doesn't seem to add new functionality, which is
fine if the later patches use what you've done here but I don't where this
change has made any impact on patches 4-6. So my guess is that there's one
of two things going on here:

1) This change was just left in by accident in which case you can just
remove this patch from your series.

2) I made an error reading the later patches and this _is_ used :)
If that's the case do me a favor and point out what I missed :)
Also, if this needs to stay I would rename ocfs2_live_connecion_new() since
_new() usually makes me think "allocates" and we're not doing that any more.
Maybe something like ocfs2_live_connection_attach()?
	--Mark

--
Mark Fasheh
