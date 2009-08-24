From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 24 Aug 2009 11:35:43 -0700
Subject: [Ocfs2-devel] [PATCH 12/17] ocfs2: Update syncing after
	splicing to match generic version
In-Reply-To: <1250875447-15622-13-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-13-git-send-email-jack@suse.cz>
Message-ID: <20090824183543.GF2818@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>

On Fri, Aug 21, 2009 at 07:24:02PM +0200, Jan Kara wrote:
> Update ocfs2 specific splicing code to use generic syncing helper. The sync now
> does not happen under rw_lock because generic_write_sync() acquires i_mutex
> which ranks above rw_lock. That should not matter because standard fsync path
> does not hold it either.

Thanks Jan,

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
