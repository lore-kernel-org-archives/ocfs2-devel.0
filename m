From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 23 Oct 2012 09:02:38 -0400
Subject: [Ocfs2-devel] [PATCH 06/21] ocfs2: drop vmtruncate
In-Reply-To: <20121023085448.GM5635@localhost>
References: <508296B4.60508@gmail.com>
 <20121023085448.GM5635@localhost>
Message-ID: <20121023130237.GA21594@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Stornelli <marco.stornelli@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:54:48AM -0700, Joel Becker wrote:
> On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> > Removed vmtruncate
> > 
> > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Acked-by: Joel Becker <jlbec@evilplan.org>
> 
> Do you want me to pull this, or are you going to send it with your set?

Is this really correct?  It now updates i_size before starting a
transaction.
