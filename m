From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Apr 2011 14:50:45 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/cluster: Heartbeat mismatch
	message improved
In-Reply-To: <1302042069-25565-4-git-send-email-sunil.mushran@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
	<1302042069-25565-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110421215045.GM13325@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 05, 2011 at 03:21:09PM -0700, Sunil Mushran wrote:
> If o2hb finds unexpected values in the heartbeat slot, it prints a message
> "ERROR: Device "dm-6": another node is heartbeating in our slot!"
> 
> This message could be misleading. This patch adds two more messages to
> help users better diagnose the problem.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
