From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Dec 2008 16:01:04 -0800
Subject: [Ocfs2-devel] [PATCH 19/56] mm: Export pdflush_operation()
In-Reply-To: <1229982517-3455-20-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-20-git-send-email-mfasheh@suse.com>
Message-ID: <20081222160104.6633cd77.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, jack@suse.cz

On Mon, 22 Dec 2008 13:48:00 -0800
Mark Fasheh <mfasheh@suse.com> wrote:

> OCSF2 will need to queue up work for periodic syncing of quotas
> among nodes in the cluster. pdflush() is good thread for this so
> export it's controlling function so that OCFS2 can use it.

I trust that nothing will explode if pdflush_operation() fails
to do anything and returns -1?
