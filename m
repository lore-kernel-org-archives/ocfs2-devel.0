From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Aug 2009 11:40:09 -0700
Subject: [Ocfs2-devel] [PATCH 12/17] ocfs2: Update syncing after
 splicing to match generic version
In-Reply-To: <20090824183543.GF2818@wotan.suse.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-13-git-send-email-jack@suse.cz>
	<20090824183543.GF2818@wotan.suse.de>
Message-ID: <20090824184009.GC7698@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Aug 24, 2009 at 11:35:43AM -0700, Mark Fasheh wrote:
> On Fri, Aug 21, 2009 at 07:24:02PM +0200, Jan Kara wrote:
> > Update ocfs2 specific splicing code to use generic syncing helper. The sync now
> > does not happen under rw_lock because generic_write_sync() acquires i_mutex
> > which ranks above rw_lock. That should not matter because standard fsync path
> > does not hold it either.
> 
> Thanks Jan,
> 
> Acked-by: Mark Fasheh <mfasheh@suse.com>

<aol>Me too!</aol>
Acked-by: Joel Becker <joel.becker@oracle.com>

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
