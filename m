From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 19 Apr 2011 10:44:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm: Use negotiated o2dlm
	protocol version
In-Reply-To: <1302042069-25565-2-git-send-email-sunil.mushran@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
	<1302042069-25565-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110419174448.GI13325@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 05, 2011 at 03:21:07PM -0700, Sunil Mushran wrote:
> Patch fixes a bug in the o2dlm protocol negotiation in that it is using
> the builtin version rather than the negotiated version during the domain
> join. This causes join errors when a node having kernel >= 2.6.37 joins
> a cluster with nodes having kernels < 2.6.37.
> 
> This only affects the o2cb cluster stack.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Reported-by: Jacek Stepniewski <Jacek.Stepniewski@agora.pl>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
