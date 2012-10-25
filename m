From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 24 Oct 2012 17:17:32 -0700
Subject: [Ocfs2-devel] [PATCH 06/21] ocfs2: drop vmtruncate
In-Reply-To: <20121023130237.GA21594@infradead.org>
References: <508296B4.60508@gmail.com> <20121023085448.GM5635@localhost>
	<20121023130237.GA21594@infradead.org>
Message-ID: <20121025001731.GB3140@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 09:02:38AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 23, 2012 at 01:54:48AM -0700, Joel Becker wrote:
> > On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> > > Removed vmtruncate
> > > 
> > > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> > 
> > Acked-by: Joel Becker <jlbec@evilplan.org>
> > 
> > Do you want me to pull this, or are you going to send it with your set?
> 
> Is this really correct?  It now updates i_size before starting a
> transaction.

	Ok, I missed that, and I need to re-check.

Joel

-- 

"If at first you don't succeed, cover all traces that you tried."
                                                        -Unknown

			http://www.jlbec.org/
			jlbec at evilplan.org
